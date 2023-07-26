import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiffy/jiffy.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

void showCertificateRequestBottomSheet({
  required BuildContext context,
  Employee? employee,
  CertificateResponseDTO? certificateInfo,
  update = false,
  MyRequestsResponseDTO? profileRequestInfo,
  GlobalKey<RefreshableState>? refreshableKey,
  bool resubmit = false,
}) {
  String? _subject;
  String? _degree;
  DateTime? _startDate;
  DateTime? _endDate;
  bool? isExpire = false;
  var _rangeLimitStart = DateTimeRange(start: Jiffy.now().subtract(years: 80).dateTime, end: DateTime.now());
  var _rangeLimitEnd = DateTimeRange(
      start: Jiffy.now().subtract(years: 80).dateTime, end: Jiffy.now().add(years: 50).dateTime);

  CertificateResponseDTO certificate = CertificateResponseDTO();
  Attachment? attachment = certificateInfo?.attachment != null
      ? Attachment(
          id: certificateInfo?.attachment?.id,
          name: certificateInfo?.attachment?.name,
          extension: certificateInfo?.attachment?.extension,
        )
      : null;

  final formKey = GlobalKey<FormState>();

  isExpire = certificateInfo?.hasExpiry?.toString().isNotEmpty == true ? certificateInfo?.hasExpiry! : false;
  _startDate = _startDate ??
      (certificateInfo?.issueDate?.isNotEmpty == true ? dateFormat3.parse(certificateInfo!.issueDate!) : null);
  _endDate = _endDate ??
      (certificateInfo?.expiryDate?.isNotEmpty == true ? dateFormat3.parse(certificateInfo!.expiryDate!) : null);
  _rangeLimitEnd = _startDate?.toString().isNotEmpty == true
      ? DateTimeRange(start: _startDate!, end: Jiffy.now().add(years: 50).dateTime)
      : _rangeLimitEnd;

  Future _addOrUpdateCertificate(StateSetter setState, {bool update = false, bool resubmit = false}) async {
    final FormState form = formKey.currentState!;

    if (form.validate()) {
      form.save();
      certificate.action = resubmit ? certificateInfo?.action : (update ? RequestAction.update : RequestAction.add);
      certificate.id = resubmit ? certificateInfo?.id : (update ? certificateInfo?.id : null);
      certificate.name = _subject;
      certificate.issuingOrganization = _degree;
      certificate.issueDate = dateFormat3.format(DateTime(_startDate!.year, _startDate!.month, _startDate!.day));
      certificate.expiryDate = _endDate?.toString().isNotEmpty == true
          ? dateFormat3.format(DateTime(_endDate!.year, _endDate!.month, _endDate!.day))
          : null;
      certificate.hasExpiry = isExpire;

      final addOrUpdateCertificateResponse = (await showFutureProgressDialog<BaseResponse<String>>(
        context: context,
        initFuture: () => resubmit
            ? ApiRepo().resubmitCertificates(employee!.id, certificate, profileRequestInfo?.requestStateId,
                attachment: attachment)
            : ApiRepo().addUpdateDeleteCertificate(employee!.id, certificate, attachment: attachment),
      ))!;
      Navigator.pop(context);
      if (addOrUpdateCertificateResponse.status!) {
        await showCustomModalBottomSheet(
          context: context,
          desc: addOrUpdateCertificateResponse.message ?? " ",
          isDismissible: false,
        );
        if (resubmit) refreshableKey!.currentState!.refresh();
      } else {
        await showCustomModalBottomSheet(
          context: context,
          desc: addOrUpdateCertificateResponse.errors != null
              ? addOrUpdateCertificateResponse.message! + " " + addOrUpdateCertificateResponse.errors!.join('\n')
              : addOrUpdateCertificateResponse.message,
          isDismissible: false,
        );
        if (resubmit) refreshableKey!.currentState!.refresh();

        return;
      }
    }
  }

  Widget fromToDatePicker(StateSetter setState) {
    return Container(
      height: 100,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: AbsorbPointer(
              absorbing: _startDate?.toString().isNotEmpty == true && update,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.appStrings!.issueDate,
                      style: Theme.of(context).textTheme.caption!.copyWith(color: DefaultThemeColors.nepal)),
                  DatePickerWidget(
                    date: _startDate,
                    hint: context.appStrings!.selectDate,
                    textStyle: _startDate?.toString().isNotEmpty == true && update
                        ? Theme.of(context).textTheme.bodyText2!.copyWith(color: DefaultThemeColors.nobel)
                        : Theme.of(context).textTheme.bodyText2,
                    onChange: () async {
                      final result = await showDatePicker(
                          context: context,
                          initialDate: _startDate ?? DateTime.now(),
                          firstDate: _rangeLimitStart.start,
                          lastDate: _rangeLimitStart.end,
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
                        _startDate = result;
                        _rangeLimitEnd =
                            DateTimeRange(start: _startDate!, end: Jiffy.now().add(years: 50).dateTime);
                        if (_startDate?.toString().isNotEmpty == true && _endDate?.toString().isNotEmpty == true) {
                          if (_endDate!.isBefore(_startDate!)) {
                            _endDate = null;
                          }
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          if (isExpire!) ...[
            SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.appStrings!.expireDate,
                      style: Theme.of(context).textTheme.caption!.copyWith(color: DefaultThemeColors.nepal)),
                  DatePickerWidget(
                    date: _endDate,
                    hint: context.appStrings!.selectDate,
                    onChange: () async {
                      final result = await showDatePicker(
                          context: context,
                          initialDate: _endDate ?? DateTime.now(),
                          firstDate: _rangeLimitEnd.start,
                          lastDate: _rangeLimitEnd.end,
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
                        _endDate = result;
                      });
                    },
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }

  showModalBottomSheet<dynamic>(
    isScrollControlled: true,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
    ),
    builder: (BuildContext context) => StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.76),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(30, 30, 30, MediaQuery.of(context).viewInsets.bottom + 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      certificateInfo?.name?.isNotEmpty == true
                          ? context.appStrings!.editCertificate
                          : context.appStrings!.addCertificate,
                      style: Theme.of(context).textTheme.headline5!.copyWith(color: Theme.of(context).primaryColor),
                    ),
                    const SizedBox(height: 24),
                    Text(context.appStrings!.name,
                        style: Theme.of(context).textTheme.caption!.copyWith(color: DefaultThemeColors.nepal)),
                    const SizedBox(height: 8),
                    InnerTextFormField(
                      hintText: context.appStrings!.typeHere,
                      readOnly: certificateInfo?.name?.isNotEmpty == true,
                      textStyle: certificateInfo?.name?.isNotEmpty == true
                          ? Theme.of(context).textTheme.bodyText2!.copyWith(color: DefaultThemeColors.nobel)
                          : Theme.of(context).textTheme.bodyText2,
                      initialValue: certificateInfo?.name?.isNotEmpty == true ? certificateInfo?.name : null,
                      validator: (value) {
                        return value?.isEmpty??true
                            ? context.appStrings!.requiredField
                            : value!.trim().length > 200
                                ? context.appStrings!.nameMaxLengthIsTwoHundredCharacter
                                : null;
                      },
                      onSaved: (String? value) => _subject = value?.trim() ?? "",
                    ),
                    const SizedBox(height: 24),
                    Text(context.appStrings!.degree,
                        style: Theme.of(context).textTheme.caption!.copyWith(color: DefaultThemeColors.nepal)),
                    const SizedBox(height: 8),
                    InnerTextFormField(
                      hintText: context.appStrings!.typeHere,
                      initialValue: certificateInfo?.issuingOrganization?.isNotEmpty == true
                          ? certificateInfo?.issuingOrganization
                          : null,
                      validator: (value) {
                        return value?.isEmpty ?? true
                          ? context.appStrings!.requiredField
                          : value!.trim().length > 200
                              ? context.appStrings!.degreeMaxLengthIsTwoHundredCharacter
                              : null;
                      },
                      onSaved: (String? value) => _degree = value?.trim() ?? "",
                    ),
                    const SizedBox(height: 24),
                    fromToDatePicker(setState),
                    const SizedBox(height: 8),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        context.appStrings!.hasExpirationDate,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: Theme.of(context).colorScheme.secondary),
                      ),
                      activeColor: Theme.of(context).colorScheme.secondary,
                      value: isExpire,
                      onChanged: (newValue) {
                        setState(() {
                          isExpire = newValue;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
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
                                          desc: context.appStrings!.areYouSureYouWantToDeleteThisFile,
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
                              var pickedFile = await pickFile(context, allowedExtensions: allowExtensions);
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
                          onPressed: () async => await _addOrUpdateCertificate(
                            setState,
                            update: update,
                            resubmit: resubmit,
                          ),
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
