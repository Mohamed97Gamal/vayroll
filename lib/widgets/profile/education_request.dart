import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

FutureOr<void> showEducationRequestBottomSheet({
  required BuildContext context,
  Employee? employee,
  EducationResponseDTO? educationInfo,
  MyRequestsResponseDTO? profileRequestInfo,
  GlobalKey<RefreshableState>? refreshableKey,
  bool resubmit = false,
}) {
  String? _college;
  String? _degree;
  String? _grade;
  String? _startDate;
  String? _endDate;
  String validationError = context.appStrings!.pleaseSelectYourSkillProficiency;
  bool _startEndDateFlag = false;
  List<String> startYears = [];
  List<String> endYears = [];

  EducationResponseDTO education = EducationResponseDTO();
  Attachment? attachment = educationInfo?.certificateFile != null
      ? Attachment(
          id: educationInfo?.certificateFile?.id,
          name: educationInfo?.certificateFile?.name,
          extension: educationInfo?.certificateFile?.extension,
        )
      : null;

  final formKey = GlobalKey<FormState>();

  for (int i = 0; i < 51; i++) {
    startYears.add((DateTime.now().year - i).toString());
    endYears.add((DateTime.now().year - i).toString());
  }

  startYears.sort((a, b) => a.compareTo(b));
  endYears.sort((a, b) => a.compareTo(b));

  _startDate = _startDate ??
      (educationInfo?.fromDate?.isNotEmpty == true
          ? educationInfo!.fromDate!.split("-")[0]
          : null);
  _endDate = _endDate ??
      (educationInfo?.toDate?.isNotEmpty == true
          ? educationInfo!.toDate!.split("-")[0]
          : null);

  Future _addOrUpdateEducation(StateSetter setState,
      {bool update = false, bool resubmit = false}) async {
    if (_endDate?.isNotEmpty == true && _startDate?.isNotEmpty == true) {
      if (int.tryParse(_startDate!)! > int.tryParse(_endDate!)!) {
        setState(() {
          validationError = context.appStrings!.startYearIsBiggerThanEndYear;
        });
      }
    }

    if (_startDate == null || _endDate == null) {
      setState(() {
        _startEndDateFlag = true;
        validationError = context.appStrings!.pleaseSelectYourYearRange;
      });
    } else {
      setState(() {
        _startEndDateFlag = false;
      });
    }

    final FormState form = formKey.currentState!;
    if (form.validate()) {
      form.save();
      if (_startDate == null || _endDate == null) return;
      education.action = resubmit
          ? educationInfo?.action
          : (update ? RequestAction.update : RequestAction.add);
      education.id = update ? educationInfo?.id : null;
      education.college = _college;
      education.degree = _degree;
      education.hasDeleteRequest = educationInfo?.hasDeleteRequest;
      education.grade = _grade?.isNotEmpty == true ? _grade : null;
      education.fromDate =
          dateFormat3.format(DateTime(int.tryParse(_startDate!)!, 1, 1));
      education.toDate =
          dateFormat3.format(DateTime(int.tryParse(_endDate!)!, 1, 1));

      final addOrUpdateEducationResponse =
          (await showFutureProgressDialog<BaseResponse<String>>(
        context: context,
        initFuture: () => resubmit
            ? ApiRepo().resubmitEducation(
                employee!.id, education, profileRequestInfo?.requestStateId,
                attachment: attachment)
            : ApiRepo().addUpdateDeleteEducation(employee!.id, education,
                attachment: attachment),
      ))!;
      Navigator.pop(context);
      if (addOrUpdateEducationResponse.status!) {
        await showCustomModalBottomSheet(
          context: context,
          isDismissible: false,
          desc: addOrUpdateEducationResponse.message ?? " ",
        );
      } else {
        await showCustomModalBottomSheet(
          context: context,
          desc: addOrUpdateEducationResponse.errors != null
              ? addOrUpdateEducationResponse.message! +
                  " " +
                  addOrUpdateEducationResponse.errors!.join('\n')
              : addOrUpdateEducationResponse.message,
        );
        if (resubmit) refreshableKey!.currentState!.refresh();

        return;
      }
    }
  }

  showModalBottomSheet<dynamic>(
    isScrollControlled: true,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25), topRight: Radius.circular(25)),
    ),
    builder: (BuildContext context) => StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.76),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    30, 30, 30, MediaQuery.of(context).viewInsets.bottom + 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      educationInfo?.college?.isNotEmpty == true
                          ? context.appStrings!.editEducation
                          : context.appStrings!.addEducation,
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(color: Theme.of(context).primaryColor),
                    ),
                    const SizedBox(height: 24),
                    Text(context.appStrings!.college,
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(color: DefaultThemeColors.nepal)),
                    const SizedBox(height: 8),
                    InnerTextFormField(
                      hintText: context.appStrings!.typeHere,
                      readOnly: educationInfo?.college?.isNotEmpty == true,
                      textStyle: educationInfo?.college?.isNotEmpty == true
                          ? Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: DefaultThemeColors.nobel)
                          : Theme.of(context).textTheme.bodyText2,
                      initialValue: educationInfo?.college?.isNotEmpty == true
                          ? educationInfo?.college
                          : null,
                      validator: (value) {
                        return value?.isEmpty ?? true
                          ? context.appStrings!.requiredField
                          : value!.trim().length > 200
                              ? context.appStrings!
                                  .collegeMaxLengthIsTwoHundredCharacter
                              : null;
                      },
                      onSaved: (String? value) => _college = value?.trim() ?? "",
                    ),
                    const SizedBox(height: 24),
                    Text(context.appStrings!.degree,
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(color: DefaultThemeColors.nepal)),
                    const SizedBox(height: 8),
                    InnerTextFormField(
                      hintText: context.appStrings!.typeHere,
                      readOnly: educationInfo?.degree?.isNotEmpty == true,
                      textStyle: educationInfo?.degree?.isNotEmpty == true
                          ? Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: DefaultThemeColors.nobel)
                          : Theme.of(context).textTheme.bodyText2,
                      initialValue: educationInfo?.degree?.isNotEmpty == true
                          ? educationInfo?.degree
                          : null,
                      validator: (value) {
                        return value?.isEmpty ?? true
                          ? context.appStrings!.requiredField
                          : value!.trim().length > 200
                              ? context.appStrings!
                                  .degreeMaxLengthIsTwoHundredCharacter
                              : null;
                      },
                      onSaved: (String? value) => _degree = value?.trim() ?? "",
                    ),
                    const SizedBox(height: 24),
                    Text(context.appStrings!.grade,
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(color: DefaultThemeColors.nepal)),
                    const SizedBox(height: 8),
                    InnerTextFormField(
                      hintText: context.appStrings!.typeHere,
                      initialValue: educationInfo?.grade?.isNotEmpty == true
                          ? educationInfo?.grade
                          : null,
                      validator: (value) {
                        value ??= "";
                        return value.length > 200
                          ? context
                              .appStrings!.gradeMaxLengthIsTwoHundredCharacter
                          : null;
                      },
                      onSaved: (String? value) => _grade = value?.trim() ?? "",
                    ),
                    const SizedBox(height: 24),
                    FromToDateWidget(
                      startDate: _startDate,
                      endDate: _endDate,
                      startYears: startYears,
                      endYears: endYears,
                      onchangeStartYear: (year) {
                        if(year == null)
                          return;
                        setState(() {
                          _startDate = year;
                          if (_endDate?.isNotEmpty == true) if (int.tryParse(
                                  _startDate!)! >
                              int.tryParse(_endDate!)!) _endDate = null;
                          int index = startYears.indexOf(year);
                          endYears = startYears
                              .getRange(index, startYears.length)
                              .toList();
                        });
                      },
                      onchangeEndYear: (year) {
                        setState(() {
                          _endDate = year;
                          if (_startDate?.isNotEmpty == true) if (int.tryParse(
                                  _startDate!)! >
                              int.tryParse(_endDate!)!) _startDate = null;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    Visibility(
                      visible: _startEndDateFlag,
                      child: Text(
                        validationError,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(height: 1.20),
                      ),
                    ),
                    const SizedBox(height: 24),
                    (attachment != null)
                        ? Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                flex: 8,
                                child: Text(
                                  attachment?.name ?? "",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Spacer(flex: 1),
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                    onTap: () => showConfirmationBottomSheet(
                                          context: context,
                                          desc: context.appStrings!
                                              .areYouSureYouWantToDeleteThisFile,
                                          isDismissible: false,
                                          onConfirm: () {
                                            setState(() => attachment = null);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                    child: SvgPicture.asset(VPayIcons.delete)),
                              ),
                            ],
                          )
                        : CameraUploadWidget(
                            uploadFile: () async {
                              var pickedFile = await pickFile(context,
                                  allowedExtensions: allowExtensions);
                              if (pickedFile == null) return;
                              setState(() => attachment = pickedFile);
                            },
                          ),
                    const SizedBox(height: 24),
                    Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 300),
                        child: CustomElevatedButton(
                          text: resubmit
                              ? context.appStrings!.resubmit.toUpperCase()
                              : context.appStrings!.submit.toUpperCase(),
                          onPressed: () async => await _addOrUpdateEducation(
                              setState,
                              resubmit: resubmit,
                              update: educationInfo?.college?.isNotEmpty == true
                                  ? true
                                  : false),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}
