import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intL;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/assets/fonts.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

import '../three_option_bottom_sheet.dart';

class SubmitRequestForm extends StatefulWidget {
  final List<RequestStateAttributesDTO>? fields;
  final List<LeaveBalanceResponseDTO>? leaveBalancesValues;
  final String? requestStateId;
  final String? title;
  final String? requestKind;
  final Employee? employee;
  final bool summary;
  final bool resubmit;
  final List<LeaveBalanceBriefDTO>? leaveBalanceBrief;

  const SubmitRequestForm({
    Key? key,
    this.fields,
    this.requestStateId,
    this.summary = false,
    this.title,
    this.requestKind,
    this.employee,
    this.resubmit = false,
    this.leaveBalanceBrief,
    this.leaveBalancesValues,
  }) : super(key: key);

  const SubmitRequestForm.summary({
    Key? key,
    this.fields,
    this.requestStateId,
    this.summary = true,
    this.title,
    this.requestKind,
    this.employee,
    this.resubmit = false,
    this.leaveBalanceBrief,
    this.leaveBalancesValues,
  }) : super(key: key);

  const SubmitRequestForm.summaryResubmit({
    Key? key,
    this.fields,
    this.requestStateId,
    this.summary = true,
    this.title,
    this.requestKind,
    this.employee,
    this.resubmit = true,
    this.leaveBalanceBrief,
    this.leaveBalancesValues,
  }) : super(key: key);

  const SubmitRequestForm.resubmit({
    Key? key,
    this.fields,
    this.requestStateId,
    this.summary = false,
    this.title,
    this.requestKind,
    this.employee,
    this.resubmit = true,
    this.leaveBalanceBrief,
    this.leaveBalancesValues,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => SubmitRequestFormState();
}

class SubmitRequestFormState extends State<SubmitRequestForm> {
  final _refreshableKey = GlobalKey<RefreshableState>();
  String? submitterId;
  bool showPassword = false;
  bool showBalanceDetails = false;
  num allBalancesSum = 0.0;
  var defaultSumBalance = 0.0;
  bool isBalanceValid = true;
  bool leavePeriodHasError = false;
  String? hint;

  DateTime startDate = DateTime.now(), endDate = DateTime.now();
  DateTime? tempEndDate;
  LeaveBalanceResponseDTO leaveBalanceSummary = LeaveBalanceResponseDTO();
  LeaveBalanceResponseDTO? leaveBalancesPeriod = LeaveBalanceResponseDTO();

  final formKey = GlobalKey<FormState>();

  List<RequestStateAttributesDTO> fields = <RequestStateAttributesDTO>[];
  List<RequestStateAttributesDTO> hidefields = <RequestStateAttributesDTO>[];

  final _expenseRangeLimitStart = DateTimeRange(
    start: DateTime(DateTime.now().year, 1, 1),
    end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
  );

  var _leaveRangeLimitStart = DateTimeRange(
    start: DateTime(DateTime.now().year - 1, DateTime.now().month, DateTime.now().day),
    end: DateTime(DateTime.now().year + 1, DateTime.now().month, DateTime.now().day),
  );

  Future _submitRequest(List<RequestStateAttributesDTO> allfields, {bool resubmit = false}) async {
    final submitRequestResponse = await showFutureProgressDialog<BaseResponse<String>>(
      context: context,
      initFuture: () => resubmit
          ? ApiRepo()
              .reSubmitRequest(widget.employee?.id, submitterId, widget.requestKind, widget.requestStateId, allfields)
          : ApiRepo().submitRequest(widget.employee?.id, submitterId, widget.requestKind, allfields),
    );

    if (submitRequestResponse?.status ?? false) {
      await showCustomModalBottomSheet(
        context: context,
        isDismissible: false,
        desc: submitRequestResponse?.message ?? " ",
      );

      if (widget.requestKind == RequestKind.expenseClaim) {
        context.read<KeyProvider>().expensePageKey!.currentState!.refresh();
        Navigator.of(context).popUntil(ModalRoute.withName(AppRoute.expenseClaim));
      } else if (widget.requestKind == RequestKind.leave) {
        context.read<KeyProvider>().leavePageKey!.currentState!.refresh();
        Navigator.of(context).popUntil(ModalRoute.withName(AppRoute.leaveManagement));
      } else if (widget.requestKind == RequestKind.ducoment) {
        if (resubmit) {
          context.read<KeyProvider>().documentRequestrefreshableKey!.currentState!.refresh();
          Navigator.of(context).popUntil(ModalRoute.withName(AppRoute.documentRequests));
        } else {
          Navigator.of(context).popUntil(ModalRoute.withName(AppRoute.document));
        }
      }
    } else {
      await showCustomModalBottomSheet(
        context: context,
        isDismissible: false,
        desc: submitRequestResponse?.message ?? " ",
      );
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    submitterId = context.read<EmployeeProvider>().employee?.id;
    widget.fields?.forEach((element) {
      if (element.requestDefinitionStateAttribute!.isHidden! ||
          (element.requestDefinitionStateAttribute!.isPostCalculated! && !widget.summary))
        hidefields.add(element);
      else
        fields.add(element);
    });

    var allGategories =
        groupBy(fields, (RequestStateAttributesDTO field) => field.requestDefinitionStateAttribute?.categoryOrder);

    var sortedKeys = allGategories.keys.toList(growable: false)..sort((k1, k2) => k1!.compareTo(k2!));
    LinkedHashMap sortedMap = new LinkedHashMap.fromIterable(sortedKeys, key: (k) => k, value: (k) => allGategories[k]);

    Map<int?, List<RequestStateAttributesDTO>?> map =
        sortedMap.map((a, b) => MapEntry(a as int?, b as List<RequestStateAttributesDTO>?));

    fields = [];
    map.forEach((key, value) {
      value?.sort((a, b) =>
          a.requestDefinitionStateAttribute!.defaultOrder!.compareTo(b.requestDefinitionStateAttribute!.defaultOrder!));
      fields.addAll(value!);
    });

    if (widget.requestKind == RequestKind.leave) {
      double _currentBalance = 0.0;
      double _totalBalance = 0.0;

      widget.leaveBalanceBrief?.forEach((element) {
        _currentBalance = _currentBalance + (element.balanceAfter ?? 0.0);
        _totalBalance = _totalBalance + (element.totalBalance ?? 0.0);
      });
      leaveBalanceSummary = LeaveBalanceResponseDTO(
        currentBalance: _currentBalance,
        totalBalance: _totalBalance,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          ListView.builder(
            itemCount: fields.length + 1,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              if (fields.length == 0) return SizedBox();
              if (index == fields.length) return _footer();

              RequestStateAttributesDTO fieldInfo = fields[index];

              if (fieldInfo.requestDefinitionStateAttribute?.type == DynamicRequestTypes.text)
                return (widget.summary && fieldInfo.stringValue == null)
                    ? SizedBox()
                    : labelWidget(textType(fieldInfo), fieldInfo);

              if (fieldInfo.requestDefinitionStateAttribute?.type == DynamicRequestTypes.bigText)
                return (widget.summary && fieldInfo.stringValue == null)
                    ? SizedBox()
                    : labelWidget(bigtextType(fieldInfo), fieldInfo);

              if (fieldInfo.requestDefinitionStateAttribute?.type == DynamicRequestTypes.decimal)
                return ((widget.summary && fieldInfo.bigDecimalValue == null) ||
                        fieldInfo.requestDefinitionStateAttribute!.code == "CURRENT_VACATION_BALANCE")
                    ? SizedBox()
                    : labelWidget(decimalType(fieldInfo), fieldInfo);

              if (fieldInfo.requestDefinitionStateAttribute?.type == DynamicRequestTypes.number)
                return (widget.summary && fieldInfo.bigDecimalValue == null)
                    ? SizedBox()
                    : labelWidget(numberType(fieldInfo), fieldInfo);

              if (fieldInfo.requestDefinitionStateAttribute?.type == DynamicRequestTypes.email)
                return (widget.summary && fieldInfo.stringValue == null)
                    ? SizedBox()
                    : labelWidget(emailType(fieldInfo), fieldInfo);

              if (fieldInfo.requestDefinitionStateAttribute?.type == DynamicRequestTypes.phoneNumber)
                return (widget.summary && fieldInfo.stringValue == null)
                    ? SizedBox()
                    : labelWidget(phoneNumberType(fieldInfo), fieldInfo);

              if (fieldInfo.requestDefinitionStateAttribute?.type == DynamicRequestTypes.password)
                return (widget.summary && fieldInfo.stringValue == null)
                    ? SizedBox()
                    : labelWidget(passwordType(fieldInfo), fieldInfo);

              if (fieldInfo.requestDefinitionStateAttribute?.type == DynamicRequestTypes.checkbox)
                return (widget.summary && fieldInfo.booleanValue == null)
                    ? SizedBox()
                    : labelWidget(checkBoxType(fieldInfo), fieldInfo);

              if (fieldInfo.requestDefinitionStateAttribute?.type == DynamicRequestTypes.date)
                return (widget.summary && fieldInfo.dateValue == null)
                    ? SizedBox()
                    : labelWidget(dateType(fieldInfo), fieldInfo);

              if (fieldInfo.requestDefinitionStateAttribute?.type == DynamicRequestTypes.time)
                return (widget.summary && fieldInfo.dateValue == null)
                    ? SizedBox()
                    : labelWidget(timeType(fieldInfo), fieldInfo);

              if (fieldInfo.requestDefinitionStateAttribute?.type == DynamicRequestTypes.dateTime)
                return (widget.summary && fieldInfo.dateValue == null)
                    ? SizedBox()
                    : labelWidget(dateTimeType(fieldInfo), fieldInfo);

              if (fieldInfo.requestDefinitionStateAttribute?.type == DynamicRequestTypes.file ||
                  fieldInfo.requestDefinitionStateAttribute?.type == DynamicRequestTypes.image)
                return (widget.summary && fieldInfo.attachment == null && fieldInfo.fileDescriptor == null)
                    ? SizedBox()
                    : labelWidget(_attachmentWidget(fieldInfo), fieldInfo);

              if (fieldInfo.requestDefinitionStateAttribute?.type == DynamicRequestTypes.lookup ||
                  fieldInfo.requestDefinitionStateAttribute?.type == DynamicRequestTypes.list)
                return (widget.summary && fieldInfo.uuidValue == null)
                    ? SizedBox()
                    : labelWidget(lookupType(fieldInfo), fieldInfo);

              return Container();
            },
          ),
        ],
      ),
    );
  }

  Widget labelWidget(Widget dynamicWidget, RequestStateAttributesDTO fieldInfo) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(fieldInfo.requestDefinitionStateAttribute!.defaultName!,
              style: Theme.of(context).textTheme.caption!.copyWith(color: DefaultThemeColors.nepal)),
          if (fieldInfo.requestDefinitionStateAttribute?.type != DynamicRequestTypes.date &&
              fieldInfo.requestDefinitionStateAttribute?.type != DynamicRequestTypes.time)
            const SizedBox(height: 10),
          dynamicWidget,
          if ((fieldInfo.requestDefinitionStateAttribute?.type == DynamicRequestTypes.lookup &&
                  widget.requestKind == RequestKind.leave) &&
              (fieldInfo.requestDefinitionStateAttribute?.code == "LEAVE_TYPE" && showBalanceDetails)) ...[
            SizedBox(height: 10),
            leaveBalanceDialoug(fieldInfo),
            SizedBox(height: 10),
            if (!widget.summary && hint != null) Text(hint!),
          ],
          if ((fieldInfo.requestDefinitionStateAttribute?.type == DynamicRequestTypes.lookup &&
                  widget.requestKind == RequestKind.leave) &&
              (fieldInfo.requestDefinitionStateAttribute?.code == "LEAVE_TYPE" && widget.summary)) ...[
            SizedBox(height: 10),
            InkWell(
              onTap: () => briefLeaveBalanceBottomSheet(
                context: context,
                leaveBalanceBriefs: widget.leaveBalanceBrief,
              ),
              child: Container(
                height: 92,
                decoration: BoxDecoration(
                  color: DefaultThemeColors.cultured,
                  border: Border.all(color: DefaultThemeColors.jetStream),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //show when its summary
                      CircularPercentIndicator(
                        radius: 35.0,
                        lineWidth: 5.0,
                        percent: max(0.0, calculatePercentage(leaveBalanceSummary)),
                        center: percentageText(context, leaveBalanceSummary, 9, isSummary: widget.summary),
                        progressColor: Theme.of(context).colorScheme.secondary,
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      SizedBox(width: 30),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 44,
                            width: MediaQuery.of(context).size.width / 2,
                            child: Center(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemCount: widget.leaveBalanceBrief?.length,
                                itemBuilder: (context, index) {
                                  if (widget.leaveBalanceBrief![index].allocatedDays == 0.0) return SizedBox();
                                  return Container(
                                    padding: EdgeInsets.symmetric(vertical: 3),
                                    constraints:
                                        BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2, maxHeight: 20),
                                    child: Text(
                                      "${(widget.leaveBalanceBrief![index].allocatedDays?.toString().split(".")[1] == "0" ? (widget.leaveBalanceBrief![index].allocatedDays?.toStringAsFixed(0).toString() ?? "") : (widget.leaveBalanceBrief![index].allocatedDays?.toStringAsFixed(1).toString() ?? ""))} ${widget.leaveBalanceBrief![index].originalLeaveRuleName}",
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10,
                                            fontFamily: Fonts.montserrat,
                                          ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
                            child: Text(
                              "Show Balance after and before",
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10,
                                    fontFamily: Fonts.montserrat,
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget leaveBalanceDialoug(RequestStateAttributesDTO fieldInfo) {
    LeaveBalanceResponseDTO leaveBalanceDefault =
        widget.leaveBalancesValues!.firstWhere(((element) => element.leaveRuleId == fieldInfo.uuidValue));
    if (leaveBalanceDefault.leaveType == "CUSTOM_BALANCE") {
      defaultSumBalance = leaveBalanceDefault.currentBalance! - 1.toDouble();
    } else if (leaveBalanceDefault.leaveType == "SELF_BALANCE") {
      defaultSumBalance = leaveBalanceDefault.currentBalance as double? ??
          0 + (leaveBalanceDefault.carryForwardBalance as double) ??
          0 + (leaveBalanceDefault.remainingNegativeBalance as double) ??
          0 - 1.toDouble();
    } else if (leaveBalanceDefault.leaveType == "REQUEST_BASED") {
      defaultSumBalance = leaveBalanceDefault.maxDaysPerRequest as double? ?? 0 - 1.toDouble();
    }
    if (fields.firstWhere((e) => e.requestDefinitionStateAttribute!.code == "START_DATE").dateValue == null) {
      return InkWell(
        onTap: () => showLeaveBalanceBottomSheet(context: context, leaveBalanceInfo: leaveBalanceDefault),
        child: Container(
          height: 92,
          decoration: BoxDecoration(
            color: DefaultThemeColors.cultured,
            border: Border.all(color: DefaultThemeColors.jetStream),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // first reload of the page
                CircularPercentIndicator(
                  radius: 35.0,
                  lineWidth: 5.0,
                  percent: max(0.0, leaveBalanceDefault.percentage as double),
                  center: percentageText(context, leaveBalanceDefault, 9, isSummary: widget.summary),
                  progressColor: Theme.of(context).primaryColor,
                  backgroundColor: DefaultThemeColors.nepal,
                ),
                SizedBox(width: 30),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
                      child: Text(
                        leaveBalanceDefault.leaveRuleName ?? "",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              fontFamily: Fonts.montserrat,
                            ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
                      child: Text(
                        "Show Balance details",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              fontFamily: Fonts.montserrat,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }
    return CustomFutureBuilder<LeaveBalanceResponse>(
      initFuture: () => ApiRepo().getLeaveBalance(widget.employee?.id),
      onSuccess: (context, snapshot) {
        var leaveBalances = snapshot.data!.result;
        if (leaveBalances == null) leaveBalances = [];
        LeaveBalanceResponseDTO leaveBalanceInfo =
            leaveBalances.firstWhere(((element) => element.leaveRuleId == fieldInfo.uuidValue));
        if (endDate == null) {
          return SizedBox.shrink();
        }
        return Refreshable(
          key: _refreshableKey,
          child: CustomFutureBuilder<List<BaseResponse<LeaveBalanceResponseDTO>>>(
            initFuture: () async {
              final before = await ApiRepo().leaveBalancePeriod(
                widget.employee?.id,
                dateFormat2.format(startDate),
                dateFormat2.format(startDate),
                leaveBalanceInfo.leaveBalanceId,
                leaveBalanceInfo.leaveRuleId,
              );

              var after = await ApiRepo().leaveBalancePeriod(
                widget.employee?.id,
                dateFormat2.format(startDate),
                dateFormat2.format(endDate),
                leaveBalanceInfo.leaveBalanceId,
                leaveBalanceInfo.leaveRuleId,
              );

              return [before, after];
            },
            onSuccess: (context, snapshot) {
              if (snapshot.data![1].status == false) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    leavePeriodHasError = true;
                  });
                });
                return Text(
                  snapshot.data![1].message!,
                  style: TextStyle(color: Colors.red),
                );
              } else {
                leaveBalancesPeriod = snapshot.data![1].result;
                final before = snapshot.data![0].result;

                if (leaveBalancesPeriod?.customLeaveBalances == null &&
                    (leaveBalancesPeriod!.carryForwardTotalAllowedBalance ?? 0) >
                        (leaveBalancesPeriod?.totalBalance ?? 0)) {
                  _leaveRangeLimitStart = DateTimeRange(
                    start: DateTime(DateTime.now().year - 2, DateTime.now().month, DateTime.now().day),
                    end: DateTime(DateTime.now().year + 1, DateTime.now().month, DateTime.now().day),
                  );
                } else if (leaveBalancesPeriod?.customLeaveBalances != null) {
                  for (LeaveBalanceResponseDTO l in leaveBalancesPeriod!.customLeaveBalances!) {
                    if (l.carryForwardTotalAllowedBalance! > l.totalBalance!) {
                      _leaveRangeLimitStart = DateTimeRange(
                        start: DateTime(DateTime.now().year - 2, DateTime.now().month, DateTime.now().day),
                        end: DateTime(DateTime.now().year + 1, DateTime.now().month, DateTime.now().day),
                      );
                      break;
                    }
                  }
                }

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    leavePeriodHasError = false;
                    hint = leaveBalancesPeriod!.hint;
                    if (leaveBalancesPeriod!.percentage < leaveBalanceInfo.maxNegativeBalanceMinus ||
                        allBalancesSum < leaveBalanceInfo.maxNegativeBalanceMinus) {
                      isBalanceValid = false;
                    } else {
                      isBalanceValid = true;
                    }
                    if (leaveBalancesPeriod!.leaveType == "CUSTOM_BALANCE") {
                      allBalancesSum = before!.currentBalance! - before.maxNegativeBalanceMinus;
                    } else if (leaveBalancesPeriod!.leaveType == "SELF_BALANCE") {
                      if(before?.currentBalance !=null && before?.carryForwardBalance !=null){
                        allBalancesSum = before!.currentBalance! + before.carryForwardBalance! ;
                    }
                     else if(before?.remainingNegativeBalance !=null){
                        allBalancesSum = before!.remainingNegativeBalance! +0.0;
                      }
                      else if(before?.maxNegativeBalanceMinus !=null){
                        allBalancesSum = 0.0- before!.maxNegativeBalanceMinus;
                      }
                      else {
                        allBalancesSum=0.0;
                      }
                    } else if (leaveBalancesPeriod!.leaveType == "REQUEST_BASED") {
                      if (fields.firstWhere((e) => e.requestDefinitionStateAttribute!.code == "END_DATE").dateValue !=
                              null &&
                          fields.firstWhere((e) => e.requestDefinitionStateAttribute!.code == "START_DATE").dateValue !=
                              null) {
                        allBalancesSum = 0;
                        leaveBalancesPeriod!.maxDaysPerRequest = 0;
                      } else {
                        allBalancesSum = before!.maxDaysPerRequest! - 1;
                      }
                    }
                  });
                });
                //if (isBalanceValid) {
                return InkWell(
                  onTap: () => showLeaveBalanceBottomSheet(context: context, leaveBalanceInfo: leaveBalancesPeriod),
                  child: Container(
                    height: 92,
                    decoration: BoxDecoration(
                      color: DefaultThemeColors.cultured,
                      border: Border.all(color: DefaultThemeColors.jetStream),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // show when select start & end dates
                          CircularPercentIndicator(
                            radius: 35.0,
                            lineWidth: 5.0,
                            percent: max(0.0, leaveBalancesPeriod!.percentage as double),
                            center: percentageText(context, leaveBalancesPeriod!, 9, isSummary: widget.summary),
                            progressColor: Theme.of(context).primaryColor,
                            backgroundColor: DefaultThemeColors.nepal,
                          ),
                          SizedBox(width: 30),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
                                child: Text(
                                  leaveBalancesPeriod?.leaveRuleName ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                        fontFamily: Fonts.montserrat,
                                      ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
                                child: Text(
                                  "Show Balance details",
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                        fontFamily: Fonts.montserrat,
                                        color: Theme.of(context).colorScheme.secondary,
                                      ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
              // }
              // else {
              return Text(
                "Balance Is not Valid please choose valid start date and end date",
                style: TextStyle(color: Colors.red),
              );
              // }
            },
          ),
        );
      },
    );
  }

  Widget textType(RequestStateAttributesDTO fieldInfo) {
    return InnerTextFormField(
      hintText: context.appStrings!.typeHere,
      initialValue: fieldInfo.stringValue == null ? null : fieldInfo.stringValue,
      readOnly: (fieldInfo.stringValue != null && widget.summary) ||
          (fieldInfo.requestDefinitionStateAttribute?.code == "EMPLOYEE_NUMBER" ||
              fieldInfo.requestDefinitionStateAttribute?.code == "EMPLOYEE_NAME"),
      textStyle: (fieldInfo.requestDefinitionStateAttribute?.code == "EMPLOYEE_NUMBER" ||
              fieldInfo.requestDefinitionStateAttribute?.code == "EMPLOYEE_NAME")
          ? Theme.of(context).textTheme.bodyText2!.copyWith(color: DefaultThemeColors.nobel)
          : Theme.of(context).textTheme.bodyText2,
      validator: (value) => fieldInfo.requestDefinitionStateAttribute!.isRequired!
          ? (value?.isEmpty ?? true
              ? context.appStrings!.requiredField
              : value!.length > 200
                  ? "${fieldInfo.requestDefinitionStateAttribute?.defaultName} ${context.appStrings!.maxLengthIsTwoHundredCharacter}"
                  : null)
          : value!.isNotEmpty
              ? value!.length > 200
                  ? "${fieldInfo.requestDefinitionStateAttribute?.defaultName} ${context.appStrings!.maxLengthIsTwoHundredCharacter}"
                  : null
              : null,
      onSaved: (String? value) =>
          (value?.isNotEmpty ?? false) ? fieldInfo.stringValue = value?.trim() ?? "" : fieldInfo.stringValue = null,
    );
  }

  Widget emailType(RequestStateAttributesDTO fieldInfo) {
    return InnerTextFormField(
      hintText: context.appStrings!.typeHere,
      initialValue: fieldInfo.stringValue == null ? null : fieldInfo.stringValue,
      readOnly: fieldInfo.stringValue != null && widget.summary,
      validator: (value) => fieldInfo.requestDefinitionStateAttribute!.isRequired!
          ? Validation().checkEmail(value ?? "", context)
          : value?.isNotEmpty ?? true
              ? Validation().checkEmail(value ?? "", context)
              : null,
      onSaved: (String? value) =>
          (value?.isNotEmpty ?? true) ? fieldInfo.stringValue = value?.trim() ?? "" : fieldInfo.stringValue = null,
    );
  }

  Widget passwordType(RequestStateAttributesDTO fieldInfo) {
    return InnerTextFormField(
      hintText: context.appStrings!.typeHere,
      initialValue: fieldInfo.stringValue == null ? null : fieldInfo.stringValue,
      readOnly: fieldInfo.stringValue != null && widget.summary,
      obscureText: !showPassword,
      suffixIcon: InkWell(
        onTap: () {
          setState(() {
            showPassword = !showPassword;
          });
        },
        child: SvgPicture.asset(
          showPassword ? VPayIcons.visibility_on : VPayIcons.visibility_off,
          fit: BoxFit.none,
        ),
      ),
      validator: (value) => fieldInfo.requestDefinitionStateAttribute!.isRequired!
          ? Validation().checkPassword(value ?? "", context)
          : value?.isNotEmpty ?? false
              ? Validation().checkPassword(value, context)
              : null,
      onSaved: (String? value) =>
          (value?.isNotEmpty ?? false) ? fieldInfo.stringValue = value?.trim() ?? "" : fieldInfo.stringValue = null,
    );
  }

  Widget bigtextType(RequestStateAttributesDTO fieldInfo) {
    return InnerTextFormField(
      hintText: context.appStrings!.typeHere,
      maxLines: 3,
      initialValue: fieldInfo.stringValue?.isNotEmpty == true ? fieldInfo.stringValue : null,
      readOnly: fieldInfo.stringValue?.isNotEmpty == true && widget.summary,
      validator: (value) => fieldInfo.requestDefinitionStateAttribute!.isRequired!
          ? (value?.isEmpty ?? true
              ? context.appStrings!.requiredField
              : value!.length > 200
                  ? "${fieldInfo.requestDefinitionStateAttribute?.defaultName} ${context.appStrings!.maxLengthIsTwoHundredCharacter}"
                  : null)
          : value?.isNotEmpty ??false
              ? value!.length > 200
                  ? "${fieldInfo.requestDefinitionStateAttribute?.defaultName} ${context.appStrings!.maxLengthIsTwoHundredCharacter}"
                  : null
              : null,
      onSaved: (String? value) =>
          (value?.isNotEmpty??false) ? fieldInfo.stringValue = value?.trim()??"" : fieldInfo.stringValue = null,
    );
  }

  Widget decimalType(RequestStateAttributesDTO fieldInfo) {
    return DecimalTypeWidget(
      fieldInfo,
      summary: widget.summary,
    );
  }

  Widget numberType(RequestStateAttributesDTO fieldInfo) {
    return NumberTypeWidget(
      fieldInfo,
      summary: widget.summary,
    );
  }

  Widget phoneNumberType(RequestStateAttributesDTO fieldInfo) {
    return PhoneNumberTypeWidget(
      fieldInfo,
      summary: widget.summary,
    );
  }

  Widget checkBoxType(RequestStateAttributesDTO? fieldInfo) {
    return Row(
      children: [
        Text(
          fieldInfo?.requestDefinitionStateAttribute?.defaultName ?? "",
          style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 16),
        ),
        Spacer(),
        Checkbox(
          value: fieldInfo?.booleanValue ?? false,
          activeColor: Theme.of(context).colorScheme.secondary,
          onChanged: (value) {
            setState(() {
              fieldInfo?.booleanValue = value;
            });
          },
        ),
      ],
    );
  }

  Widget dateType(RequestStateAttributesDTO fieldInfo) {
    return DatePickerWidget(
      date: fieldInfo.dateValue != null ? dateFormat2.parse(fieldInfo.dateValue!) : null,
      textStyle: Theme.of(context).textTheme.bodyText2,
      hint: fieldInfo.requestDefinitionStateAttribute?.defaultName,
      validator: (value) => fieldInfo.requestDefinitionStateAttribute!.isRequired!
          ? fieldInfo.dateValue == null
              ? context.appStrings!.requiredField
              : null
          : null,
      onChange: widget.summary
          ? () {}
          : () async {
              ///////
              final result = await showDatePicker(
                  context: context,
                  initialDate: tempEndDate != null && tempEndDate!.isAfter(startDate) ? tempEndDate! : startDate,
                  firstDate: widget.requestKind == "EXPENSE_CLAIM"
                      ? _expenseRangeLimitStart.start
                      : (widget.requestKind == RequestKind.leave &&
                              fieldInfo.requestDefinitionStateAttribute?.code == "END_DATE")
                          ? startDate
                          : _leaveRangeLimitStart.start,
                  lastDate: widget.requestKind == "EXPENSE_CLAIM"
                      ? _expenseRangeLimitStart.end
                      : (widget.requestKind == RequestKind.leave &&
                              fieldInfo.requestDefinitionStateAttribute?.code == "END_DATE")
                          ? //isBalanceValid
                          // ? startDate.add(new Duration(days: allBalancesSum.toInt()))
                          DateTime(2050)
                          : DateTime(2050),
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        colorScheme: ColorScheme.light().copyWith(
                          primary: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      child: child!,
                    );
                  });

              if (result == null) return;
              setState(() {
                DateTime dateTime = DateTime(result.year, result.month, result.day, 00, 00, 00);

                fieldInfo.dateValue = intL.DateFormat('yyyy-MM-dd 00:00:00.000').format(dateTime);
                if (widget.requestKind == RequestKind.leave &&
                    fieldInfo.requestDefinitionStateAttribute?.code == "END_DATE") {
                  endDate = dateFormat3.parse(fieldInfo.dateValue!);
                  tempEndDate = endDate;
                  if (showBalanceDetails) _refreshableKey.currentState?.refresh();
                }
                if (widget.requestKind == RequestKind.leave &&
                    fieldInfo.requestDefinitionStateAttribute?.code == "START_DATE") {
                  startDate = dateFormat3.parse(fieldInfo.dateValue!);
                  endDate = startDate;
                  fields.firstWhere((e) => e.requestDefinitionStateAttribute!.code == "END_DATE").dateValue = null;
                  fields.firstWhere((e) => e.requestDefinitionStateAttribute!.code == "END_DATE").endDate = startDate;
                  if (startDate.isAfter(endDate)) {
                    endDate = startDate;
                    fields.firstWhere((e) => e.requestDefinitionStateAttribute!.code == "END_DATE").dateValue =
                        intL.DateFormat('yyyy-MM-dd 00:00:00.000').format(dateTime);
                  }
                  if (showBalanceDetails) _refreshableKey.currentState?.refresh();
                }
                allBalancesSum = defaultSumBalance;
              });
            },
    );
  }

  Widget timeType(RequestStateAttributesDTO fieldInfo) {
    return InnerTextFormField(
      textAlignVertical: TextAlignVertical.bottom,
      controller: TextEditingController(
        text: fieldInfo.dateValue != null ? timeFormat.format(dateFormat3.parse(fieldInfo.dateValue!)) : "",
      ),
      readOnly: true,
      hintText: fieldInfo.requestDefinitionStateAttribute?.defaultName,
      suffixIcon: SvgPicture.asset(
        VPayIcons.calendar,
        fit: BoxFit.none,
        alignment: Alignment.center,
      ),
      validator: (value) =>
          fieldInfo.requestDefinitionStateAttribute!.isRequired! ? context.appStrings!.requiredField : null,
      onTap: () async {
        final result = await showTimePicker(
          context: context,
          initialTime: fieldInfo.dateValue != null
              ? TimeOfDay(
                  hour: dateFormat3.parse(fieldInfo.dateValue!).hour,
                  minute: dateFormat3.parse(fieldInfo.dateValue!).minute)
              : TimeOfDay.now(),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: ColorScheme.light().copyWith(primary: Theme.of(context).colorScheme.secondary),
              ),
              child: child!,
            );
          },
        );
        if (result == null) return;
        setState(() {
          DateTime dateTime =
              DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, result.hour, result.minute);
          fieldInfo.dateValue = dateFormat3.format(dateTime);
        });
      },
    );
  }

  Widget dateTimeType(RequestStateAttributesDTO fieldInfo) {
    return DateTimePickerWidget(
      date: fieldInfo.dateValue != null ? dateFormat3.parse(fieldInfo.dateValue!) : null,
      textStyle: Theme.of(context).textTheme.bodyText2,
      hint: fieldInfo.requestDefinitionStateAttribute?.defaultName,
      validator: (value) =>
          fieldInfo.requestDefinitionStateAttribute!.isRequired! ? context.appStrings!.requiredField : null,
      onChange: widget.summary
          ? () {}
          : () async {
              final dateResult = await showDatePicker(
                  context: context,
                  initialDate: fieldInfo.dateValue != null ? dateFormat3.parse(fieldInfo.dateValue!) : DateTime.now(),
                  firstDate: widget.requestKind == "EXPENSE_CLAIM"
                      ? _expenseRangeLimitStart.start
                      : _leaveRangeLimitStart.start,
                  lastDate: widget.requestKind == "EXPENSE_CLAIM"
                      ? _expenseRangeLimitStart.end
                      : _leaveRangeLimitStart.start.add(Duration(days: 3652)),
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        colorScheme: ColorScheme.light().copyWith(
                          primary: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      child: child!,
                    );
                  });

              final timeResult = await showTimePicker(
                context: context,
                initialTime: fieldInfo.dateValue != null
                    ? TimeOfDay(
                        hour: dateFormat3.parse(fieldInfo.dateValue!).hour,
                        minute: dateFormat3.parse(fieldInfo.dateValue!).minute)
                    : TimeOfDay.now(),
                builder: (BuildContext context, Widget? child) {
                  return Theme(
                    data: ThemeData.light().copyWith(
                      colorScheme: ColorScheme.light().copyWith(primary: Theme.of(context).colorScheme.secondary),
                    ),
                    child: child!,
                  );
                },
              );

              if (dateResult == null || timeResult == null) return;
              setState(() {
                DateTime dateAndTime =
                    DateTime(dateResult.year, dateResult.month, dateResult.day, timeResult.hour, timeResult.minute);

                fieldInfo.dateValue = dateFormat3.format(dateAndTime);
              });
            },
    );
  }

  Widget lookupType(RequestStateAttributesDTO fieldInfo) {
    List<LookupValueDTO> validLeavesId = [];
    num? checkBalanceIsNOTZero = -5000;
    if (widget.leaveBalancesValues != null && widget.leaveBalancesValues != []) {
      for (int i = 0; i < widget.leaveBalancesValues!.length; i++) {
        if (widget.leaveBalancesValues![i].leaveType == "CUSTOM_BALANCE") {
          checkBalanceIsNOTZero = widget.leaveBalancesValues![i].currentBalance ?? 0;
        } else if (widget.leaveBalancesValues![i].leaveType == "SELF_BALANCE") {
          checkBalanceIsNOTZero = widget.leaveBalancesValues?[i].currentBalance ??
               widget.leaveBalancesValues?[i].carryForwardBalance ??
               widget.leaveBalancesValues?[i].remainingNegativeBalance ??
              0;
        } else if (widget.leaveBalancesValues![i].leaveType == "REQUEST_BASED") {
          checkBalanceIsNOTZero = widget.leaveBalancesValues![i].maxDaysPerRequest;
        }
        if (checkBalanceIsNOTZero != 0) {
          validLeavesId.add(LookupValueDTO.fromJson({
            "name": widget.leaveBalancesValues![i].leaveRuleName,
            "id": widget.leaveBalancesValues![i].leaveRuleId,
            "code": widget.leaveBalancesValues![i].leaveRuleCode,
          }));
        }
      }
    }
    if (fieldInfo.requestDefinitionStateAttribute?.type == DynamicRequestTypes.lookup)
      fieldInfo.requestDefinitionStateAttribute!.lookupValues!.sort((a, b) => a.name!.compareTo(b.name!));
    else if (fieldInfo.requestDefinitionStateAttribute?.type == DynamicRequestTypes.list)
      fieldInfo.requestDefinitionStateAttribute!.listValues!.sort((a, b) => a.name!.compareTo(b.name!));

    if ((fieldInfo.requestDefinitionStateAttribute?.type == DynamicRequestTypes.lookup &&
            widget.requestKind == RequestKind.ducoment) &&
        ((!widget.employee!.hasRole(Role.CanViewDepartmentsDetails) &&
                !widget.employee!.hasRole(Role.CanViewAllDepartmentsDetails)) &&
            (!widget.employee!.hasRole(Role.CanViewAllDepartmentsDetails) &&
                widget.employee!.hasRole(Role.CanUploadDocument)))) {
      fieldInfo.uuidValue = widget.employee?.department?.id;
    }
    return fieldInfo.requestDefinitionStateAttribute?.type == DynamicRequestTypes.lookup &&
            widget.requestKind == RequestKind.ducoment
        ? (widget.employee!.hasRole(Role.CanViewDepartmentsDetails) ||
                widget.employee!.hasRole(Role.CanViewAllDepartmentsDetails) ||
                widget.employee!.hasRole(Role.CanViewAllDepartmentsDetails))
            ? CustomFutureBuilder<BaseResponse<List<Department>>>(
                initFuture: () => widget.employee!.hasRole(Role.CLevel) ||
                        widget.employee!.hasRole(Role.CanViewAllDepartmentsDetails)
                    ? ApiRepo().getDepartments(employeeGroupId: widget.employee!.employeesGroup!.id, accessible: false)
                    : ApiRepo().getDepartments(employeeId: widget.employee!.id, accessible: true),
                onSuccess: (context, departmentsSnapshot) {
                  List<Department> departments = [];
                  var departmentsAcc = departmentsSnapshot.data!.result;
                  if (departmentsAcc != null || departmentsAcc!.isNotEmpty) {
                    departmentsAcc.forEach((element) => departments.add(element));
                  }
                  if (departments.length == 1) {
                    fieldInfo.uuidValue = departments[0].id;
                  }
                  return departments.length == 1
                      ? Text(
                          departments[0].name!,
                          style: Theme.of(context).textTheme.bodyText2,
                        )
                      : IgnorePointer(
                          ignoring: widget.summary,
                          child: InnerSearchableDropdown<Department>(
                            hint:
                                "${context.appStrings!.select} ${fieldInfo.requestDefinitionStateAttribute?.defaultName}",
                            itemAsString: (lookup) => lookup.name??"",
                            filterFunction: (value, filter) =>
                                value.name!.toLowerCase().contains(filter.trim().toLowerCase()),
                            value: fieldInfo.uuidValue == null
                                ? null
                                : fieldInfo.requestDefinitionStateAttribute?.type == DynamicRequestTypes.lookup
                                    ? (departments.firstWhere(
                                        (element) => element.id == fieldInfo.uuidValue,
                                        orElse: () => Department(),
                                      ))
                                    : (departments.firstWhere(
                                        (element) => element.id == fieldInfo.uuidValue,
                                        orElse: () => Department(),
                                      )),
                            items: departments,
                            onChanged: (value) => setState(() {
                              fieldInfo.uuidValue = value!.id;
                              if (widget.requestKind == RequestKind.leave &&
                                  fieldInfo.requestDefinitionStateAttribute?.code == "LEAVE_TYPE") {
                                showBalanceDetails = true;
                              }
                            }),
                            validator: (value) => fieldInfo.requestDefinitionStateAttribute!.isRequired!
                                ? (value == null ? context.appStrings!.requiredField : null)
                                : null,
                          ),
                        );
                },
              )
            : widget.employee!.hasRole(Role.CanUploadDocument)
                ? Text(
                    widget.employee!.department!.name!,
                    style: Theme.of(context).textTheme.bodyText2,
                  )
                : Container()
        : IgnorePointer(
            ignoring: widget.summary,
            child: InnerSearchableDropdown<LookupValueDTO>(
              hint: "${context.appStrings!.select} ${fieldInfo.requestDefinitionStateAttribute?.defaultName}",
              itemAsString: (lookup) => lookup.name??"",
              filterFunction: (value, filter) => value.name!.toLowerCase().startsWith(filter.trim().toLowerCase()),
              value: fieldInfo.uuidValue == null
                  ? null
                  : fieldInfo.requestDefinitionStateAttribute?.type == DynamicRequestTypes.lookup
                      ? (fieldInfo.requestDefinitionStateAttribute!.lookupValues!.firstWhere(
                          (element) => element.id == fieldInfo.uuidValue,
                          orElse: () => LookupValueDTO(),
                        ))
                      : (fieldInfo.requestDefinitionStateAttribute!.listValues!.firstWhere(
                          (element) => element.id == fieldInfo.uuidValue,
                          orElse: () => LookupValueDTO(),
                        )),
              items: fieldInfo.requestDefinitionStateAttribute?.type == DynamicRequestTypes.lookup
                  ? fieldInfo.requestDefinitionStateAttribute?.code == "LEAVE_TYPE"
                      ? validLeavesId
                      : fieldInfo.requestDefinitionStateAttribute!.lookupValues
                  : fieldInfo.requestDefinitionStateAttribute!.listValues,
              onChanged: (value) => setState(() {
                fieldInfo.uuidValue = value!.id;
                fields.firstWhere((e) => e.requestDefinitionStateAttribute!.code == "END_DATE").dateValue = null;
                fields.firstWhere((e) => e.requestDefinitionStateAttribute!.code == "START_DATE").dateValue = null;
                startDate = DateTime.now();
                if (widget.requestKind == RequestKind.leave &&
                    fieldInfo.requestDefinitionStateAttribute?.code == "LEAVE_TYPE") {
                  if (!showBalanceDetails)
                    showBalanceDetails = true;
                  else {
                    try {
                      _refreshableKey.currentState!.refresh();
                    } catch (e) {}
                  }
                }
              }),
              validator: (value) => fieldInfo.requestDefinitionStateAttribute!.isRequired!
                  ? (value == null ? context.appStrings!.requiredField : null)
                  : null,
            ),
          );
  }

  Widget _attachmentWidget(RequestStateAttributesDTO fieldInfo) {
    return FormField<Attachment>(
      initialValue: fieldInfo.attachment ?? fieldInfo.fileDescriptor,
      builder: (state) => Column(
        children: [
          InputDecorator(
            decoration: InputDecoration(
              errorText: state.errorText,
              errorStyle: Theme.of(context).textTheme.subtitle2!.copyWith(height: 1.20),
            ),
            child: AttachmentTypeWidget(
              fieldInfo,
              requestKind: widget.requestKind,
              summary: widget.summary,
              resubmit: widget.resubmit,
              fields: widget.fields,
              onUpdate: () => setState(() {
                state.didChange(fieldInfo.attachment);
              }),
            ),
          ),
          //if (state.errorText != null) Text(state.errorText),
        ],
      ),
      validator: (attachment) {
        if (fieldInfo.requestDefinitionStateAttribute!.isRequired! && attachment == null) {
          return context.appStrings!.requiredAttachment;
        }
        return null;
      },
    );
  }

  Widget _footer() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 300),
          child: CustomElevatedButton(
              text: widget.summary && widget.resubmit
                  ? context.appStrings!.resubmit.toUpperCase()
                  : widget.summary
                      ? context.appStrings!.submit.toUpperCase()
                      : context.appStrings!.summary.toUpperCase(),
              onPressed: leavePeriodHasError
                  ? null
                  : () async {
                      if (widget.summary) {
                        List<RequestStateAttributesDTO> allFields = [
                          ...fields,
                          ...hidefields,
                        ];
                        await _submitRequest(allFields, resubmit: widget.resubmit);
                      } else {
                        final FormState form = formKey.currentState!;
                        if (form.validate()) {
                          form.save();

                          List<RequestStateAttributesDTO> allFields = [
                            ...fields,
                            ...hidefields,
                          ];

                          Navigation.navToSubmitRequestSummary(
                            context,
                            widget.requestKind,
                            "${widget.title} ${context.appStrings!.summary}",
                            allFields,
                            widget.employee,
                            widget.requestStateId,
                            resubmit: widget.resubmit,
                          );
                        }
                      }
                    }),
        ),
      ),
    );
  }
}

class DecimalTypeWidget extends StatelessWidget {
  final RequestStateAttributesDTO fieldInfo;
  final bool? summary;

  DecimalTypeWidget(
    this.fieldInfo, {
    this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InnerTextFormField(
          key: Key(fieldInfo.bigDecimalValue?.toString() ?? "AMOUNT_FIELD"),
          hintText: context.appStrings!.typeHere,
          keyboardType: TextInputType.number,
          initialValue: fieldInfo.bigDecimalValue?.toString(),
          readOnly: (fieldInfo.bigDecimalValue?.toString().isNotEmpty == true && summary!) ||
              fieldInfo.requestDefinitionStateAttribute!.isPreCalculated!,
          validator: (value) => fieldInfo.requestDefinitionStateAttribute!.isRequired!
              ? (value?.isEmpty ?? true
                  ? context.appStrings!.requiredField
                  : value!.length > 15
                      ? "${fieldInfo.requestDefinitionStateAttribute?.defaultName}  ${context.appStrings!.maxLengthIsFifteenNumber}"
                      : null)
              : value!.isNotEmpty
                  ? value!.length > 15
                      ? "${fieldInfo.requestDefinitionStateAttribute?.defaultName}  ${context.appStrings!.maxLengthIsFifteenNumber}"
                      : null
                  : null,
          onSaved: (String? value) => (value?.isNotEmpty??false)
              ? fieldInfo.bigDecimalValue = double.tryParse(value?.trim()??"")
              : fieldInfo.bigDecimalValue = null,
        ),
      ],
    );
  }
}

class NumberTypeWidget extends StatelessWidget {
  final RequestStateAttributesDTO fieldInfo;
  final bool? summary;

  NumberTypeWidget(
    this.fieldInfo, {
    this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InnerTextFormField(
          hintText: context.appStrings!.typeHere,
          keyboardType: TextInputType.number,
          initialValue: fieldInfo.integerValue?.toString(),
          readOnly: fieldInfo.integerValue?.toString().isNotEmpty == true && summary!,
          validator: (value) => fieldInfo.requestDefinitionStateAttribute!.isRequired!
              ? (value?.isEmpty ?? true
                  ? context.appStrings!.requiredField
                  : value!.length > 15
                      ? "${fieldInfo.requestDefinitionStateAttribute?.defaultName} ${context.appStrings!.maxLengthIsFifteenNumber}"
                      : null)
              : value!.isNotEmpty
                  ? value.length > 15
                      ? "${fieldInfo.requestDefinitionStateAttribute?.defaultName}  ${context.appStrings!.maxLengthIsFifteenNumber}"
                      : null
                  : null,
          onSaved: (String? value) => (value?.isNotEmpty ?? false)
              ? fieldInfo.integerValue = int.tryParse(value?.trim() ?? "")
              : fieldInfo.integerValue = null,
        ),
      ],
    );
  }
}

class PhoneNumberTypeWidget extends StatelessWidget {
  final RequestStateAttributesDTO fieldInfo;
  final bool? summary;

  PhoneNumberTypeWidget(
    this.fieldInfo, {
    this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return InnerTextFormField(
      hintText: context.appStrings!.typeHere,
      keyboardType: TextInputType.phone,
      initialValue: fieldInfo.stringValue?.isNotEmpty == true ? fieldInfo.stringValue?.toString() : null,
      readOnly: fieldInfo.stringValue?.isNotEmpty == true && summary!,
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s|-|\.|,|#|\*|N| |;|/|\(|\)"))],
      validator: (value) {
        if (fieldInfo.requestDefinitionStateAttribute!.isRequired! || (value?.isNotEmpty ?? false)) {
          if (value?.isEmpty ?? true) {
            return context.appStrings!.requiredField;
          } else {
            if (value!.length >= 5 && value.length <= 20) {
              return null;
            } else {
              return "Number must be 5 to 20 digits";
            }
          }
        } else {
          return null;
        }
      },
      onSaved: (String? value) => ((value?.isNotEmpty ?? false) == true)
          ? fieldInfo.stringValue = (value?.trim() ?? "")
          : fieldInfo.stringValue = null,
    );
  }
}

class AttachmentTypeWidget extends StatefulWidget {
  final RequestStateAttributesDTO fieldInfo;
  final bool summary;
  final bool resubmit;
  final String? requestKind;
  final List<RequestStateAttributesDTO>? fields;
  final Function onUpdate;

  AttachmentTypeWidget(
    this.fieldInfo, {
    required this.requestKind,
    required this.summary,
    required this.resubmit,
    required this.fields,
    required this.onUpdate,
  });

  @override
  State<AttachmentTypeWidget> createState() => _AttachmentTypeWidgetState();
}

class _AttachmentTypeWidgetState extends State<AttachmentTypeWidget> {
  @override
  Widget build(BuildContext context) {
    var exists = widget.fieldInfo.attachment != null || widget.fieldInfo.fileDescriptor != null;
    if (widget.requestKind == "EXPENSE_CLAIM") {
      return Column(
        children: [
          if (!exists) ...[
            Text(context.appStrings!.uploadOrScan, style: Theme.of(context).textTheme.subtitle1),
            SizedBox(height: 12),
          ],
          OCRTypeField(
            widget.fieldInfo,
            requestKind: widget.requestKind,
            summary: widget.summary,
            resubmit: widget.resubmit,
            fields: widget.fields,
            onUpdate: widget.onUpdate,
          ),
        ],
      );
    }

    if (exists) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 8,
            child: Text(
              (widget.fieldInfo.attachment?.name ?? widget.fieldInfo.fileDescriptor?.name!)!,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Spacer(flex: 1),
          //if (widget.fieldInfo.fileDescriptor == null || widget.resubmit)
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () => showConfirmationBottomSheet(
                context: context,
                desc: context.appStrings!.pleaseConfirmToDeleteThisFile,
                isDismissible: false,
                onConfirm: () async {
                  setState(() {
                    widget.fieldInfo.attachment = null;
                    widget.fieldInfo.fileDescriptor = null;
                  });
                  Navigator.of(context).pop();
                },
              ),
              child: SvgPicture.asset(VPayIcons.delete),
            ),
          ),
        ],
      );
    }

    return CameraUploadWidget(
      uploadFile: () async {
        var pickedFile = await pickFile(context, allowedExtensions: allowExtensions);
        if (pickedFile == null) return;
        setState(() {
          widget.fieldInfo.attachment = pickedFile;
          widget.fieldInfo.fileDescriptor = pickedFile;
          widget.onUpdate();
        });
      },
    );
  }
}

class OCRTypeField extends StatefulWidget {
  final RequestStateAttributesDTO fieldInfo;
  final bool summary;
  final bool resubmit;
  final String? requestKind;
  final List<RequestStateAttributesDTO>? fields;
  final Function onUpdate;

  OCRTypeField(
    this.fieldInfo, {
    required this.requestKind,
    required this.summary,
    required this.resubmit,
    required this.fields,
    required this.onUpdate,
  });

  @override
  _OCRTypeFieldState createState() => _OCRTypeFieldState();
}

class _OCRTypeFieldState extends State<OCRTypeField> {
  final textDetector = GoogleMlKit.vision.textRecognizer();

  @override
  void dispose() {
    super.dispose();
    textDetector.close();
  }

  List<String>? ocrKeywords = [];
  List<String>? ocrNegativeKeywords = [];

  Future processImage(String filePath, Attachment attachment) async {
    var result = await showFutureProgressDialog<double>(
      context: context,
      initFuture: () async {
        if (ocrKeywords!.isEmpty || ocrNegativeKeywords!.isEmpty) {
          final keywords = await ApiRepo().getOCRKeywords();
          final negKeywords = await ApiRepo().getOCRNegativeKeywords();
          ocrKeywords = keywords.result;
          ocrNegativeKeywords = negKeywords.result;
        }
        final inputImage = InputImage.fromFilePath(filePath);
        final recognisedText = await textDetector.processImage(inputImage);
        if (recognisedText.blocks.isEmpty) {
          return 0;
        }

        var specials = ocrKeywords!.map((e) => e.toLowerCase()).toList();
        var specialBlocks = recognisedText.blocks.where((b) {
          for (final special in specials) {
            if (b.text.toLowerCase().contains(special)) {
              return true;
            }
          }
          return false;
        });

        var negativeSpecials = ocrNegativeKeywords!.map((e) => e.toLowerCase()).toList();
        var negativeSpecialBlocks = recognisedText.blocks.where((b) {
          for (final special in negativeSpecials) {
            if (b.text.toLowerCase().contains(special)) {
              return true;
            }
          }
          return false;
        });

        var numberBlocks = recognisedText.blocks.where((tb) {
          var numbers = tb.text
              .replaceAll(",", "")
              .split(RegExp(r"[^\d.]"))
              .where((t) => t.isNotEmpty)
              .map((e) => double.tryParse(e));
          if (numbers.isEmpty) {
            return false;
          }
          return true;
        }).toList();

        List<TextBlock?> nearSpecialBlocks = specialBlocks
            .map((specialBlock) {
              var numbers = specialBlock.text
                  .replaceAll(",", "")
                  .split(RegExp(r"[^\d.]"))
                  .where((t) => t.isNotEmpty)
                  .map((e) => double.tryParse(e));
              if (numbers.isNotEmpty) {
                return specialBlock;
              }

              numberBlocks.sort((tb1, tb2) {
                var d1 = tb1.boundingBox.top - specialBlock.boundingBox.top;
                var d2 = tb2.boundingBox.top - specialBlock.boundingBox.top;
                var r = d1.abs().compareTo(d2.abs());
                return r;
              });
              var first = numberBlocks.first;
              var distance = (first.boundingBox.top - specialBlock.boundingBox.top).abs();
              if (distance > specialBlock.boundingBox.height && distance > first.boundingBox.height) {
                return null;
              }
              return first;
            })
            .whereNotNull()
            .toList();

        List<TextBlock?> nearNegativeSpecialBlocks = negativeSpecialBlocks
            .map((negativeSpecialBlock) {
              var numbers = negativeSpecialBlock.text
                  .replaceAll(",", "")
                  .split(RegExp(r"[^\d.]"))
                  .where((t) => t.isNotEmpty)
                  .map((e) => double.tryParse(e));
              if (numbers.isNotEmpty) {
                return negativeSpecialBlock;
              }

              numberBlocks.sort((tb1, tb2) {
                var d1 = tb1.boundingBox.top - negativeSpecialBlock.boundingBox.top;
                var d2 = tb2.boundingBox.top - negativeSpecialBlock.boundingBox.top;
                var r = d1.abs().compareTo(d2.abs());
                return r;
              });
              var first = numberBlocks.first;
              var distance = (first.boundingBox.top - negativeSpecialBlock.boundingBox.top).abs();
              if (distance > negativeSpecialBlock.boundingBox.height && distance > first.boundingBox.height) {
                return null;
              }
              return first;
            })
            .whereNotNull()
            .toList();

        if (specialBlocks.isEmpty && nearSpecialBlocks.isEmpty) {
          var sorted = recognisedText.blocks.where((tb) {
            return double.tryParse(tb.text) != null;
          }).toList();

          sorted.sort((tb1, tb2) {
            return tb1.boundingBox.top.compareTo(tb2.boundingBox.top);
          });

          return sorted.isNotEmpty ? double.parse(sorted.last.text) : 0;
        } else {
          try {
            var all = <TextBlock?>[];
            if (specialBlocks.isNotEmpty) all.addAll(specialBlocks);
            if (nearSpecialBlocks.isNotEmpty) all.addAll(nearSpecialBlocks);

            var numbers = all.map((tb) {
              var numbers = tb!.text
                  .replaceAll(",", "")
                  .split(RegExp(r"[^\d.]"))
                  .where((t) => t.isNotEmpty)
                  .map((e) => double.tryParse(e))
                  .whereNotNull();
              if (numbers.isEmpty) {
                return 0;
              }

              return numbers.reduce(max);
            }).where((element) => element != 0);

            var negativeBlocks = <TextBlock?>[];
            if (negativeSpecialBlocks.isNotEmpty) negativeBlocks.addAll(negativeSpecialBlocks);
            if (nearNegativeSpecialBlocks.isNotEmpty) negativeBlocks.addAll(nearNegativeSpecialBlocks);

            var negativeNumbers = negativeBlocks.map<num>((tb) {
              var numbers = tb!.text
                  .replaceAll(",", "")
                  .split(RegExp(r"[^\d.]"))
                  .where((t) => t.isNotEmpty)
                  .map((e) => double.tryParse(e))
                  .whereNotNull();
              if (numbers.isEmpty) {
                return 0;
              }

              return numbers.reduce(max);
            }).where((element) => element != 0);

            final maxNegativeNumber = negativeNumbers.isNotEmpty ? negativeNumbers.reduce(max) : 0;
            final maxNumber = numbers.reduce(max);
            final match = numbers.where((element) => (maxNumber - maxNegativeNumber) == element);
            if (match.isNotEmpty) {
              return match.first as FutureOr<double>;
            }
            return maxNumber as FutureOr<double>;
          } catch (ex) {
            return 0;
          }
        }
      },
    );
    if (result != null) {
      setState(() {
        _updateAmountDecimalField(result);
        widget.fieldInfo.attachment = attachment;
        widget.fieldInfo.fileDescriptor = attachment;
        widget.onUpdate();
      });
    } else {
      setState(() {
        _updateAmountDecimalField(null);
        widget.fieldInfo.attachment = attachment;
        widget.fieldInfo.fileDescriptor = attachment;
        widget.onUpdate();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var attachment = widget.fieldInfo.attachment ?? widget.fieldInfo.fileDescriptor;
    var exists = attachment != null;

    if (exists) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 8,
            child: Text(
              attachment!.name!,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Spacer(flex: 1),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: widget.summary
                  ? null
                  : () => showConfirmationBottomSheet(
                        context: context,
                        desc: context.appStrings!.pleaseConfirmToDeleteThisFile,
                        isDismissible: false,
                        onConfirm: () async {
                          setState(() {
                            _updateAmountDecimalField(null);
                            widget.fieldInfo.attachment = null;
                            widget.fieldInfo.fileDescriptor = null;
                            widget.onUpdate();
                          });
                          Navigator.of(context).pop();
                        },
                      ),
              child: widget.summary ? SizedBox.shrink() : SvgPicture.asset(VPayIcons.delete),
            ),
          ),
        ],
      );
    }

    return CameraUploadWidget(
      description: context.appStrings!.jPGPNGOrPDFSmallerThanTenMB,
      uploadFile: () async {
        threeOptionBottomSheet(
          context: context,
          desc: context.appStrings!.chooseImageFromGalleryOrScanByCamera,
          textOption1: context.appStrings!.camera,
          textOption3: context.appStrings!.gallery,
          textOption2: "Files",
          funOption3: () async {
            var file = await ImagePicker().pickImage(
              source: ImageSource.gallery,
            );
            if (file == null) return;

            final pickedFile = Attachment(
              name: file.path.split("/").last,
              extension: p.extension(file.path).substring(1),
              content: base64Encode(await file.readAsBytes()),
            );

            if (imageExtensions.contains(p.extension(file.path).substring(1))) {
              await processImage(file.path, pickedFile);
            }

            Navigator.of(context).pop();
          },
          funOption2: () async {
            var pickedFile = await pickFile(context, allowedExtensions: allowExtensions);
            if (pickedFile == null) return;

            if (!imageExtensions.contains(pickedFile.extension)) {
              setState(() {
                widget.fieldInfo.attachment = pickedFile;
                widget.fieldInfo.fileDescriptor = pickedFile;
                widget.onUpdate();
              });
            } else {
              final encodedStr = pickedFile.content!;
              Uint8List bytes = base64Decode(encodedStr);
              String dir = (await getApplicationDocumentsDirectory()).path;
              File fileDecoded = File(
                "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".${pickedFile.extension}",
              );
              await fileDecoded.writeAsBytes(bytes);

              await processImage(fileDecoded.path, pickedFile);
            }
            Navigator.of(context).pop();
          },
          funOption1: () async {
            var file = await ImagePicker().pickImage(source: ImageSource.camera);
            if (file == null) return;

            final pickedFile = Attachment(
              name: file.path.split("/").last,
              extension: p.extension(file.path).substring(1),
              content: base64Encode(await file.readAsBytes()),
            );

            if (imageExtensions.contains(p.extension(file.path).substring(1))) {
              await processImage(file.path, pickedFile);
            }

            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  _updateAmountDecimalField(double? newValue) {
    final amountField = widget.fields!.firstWhereOrNull(
      (element) => element.requestDefinitionStateAttribute!.code == "AMOUNT",
    );
    if (amountField == null) {
      return;
    }

    amountField.bigDecimalValue = newValue;
    widget.onUpdate();
  }
}
