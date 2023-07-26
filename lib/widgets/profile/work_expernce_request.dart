import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiffy/jiffy.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

void showWorkExpernceRequestBottomSheet({
  required BuildContext context,
  Employee? employee,
  ExperiencesResponseDTO? experienceInfo,
  bool update = false,
  MyRequestsResponseDTO? profileRequestInfo,
  GlobalKey<RefreshableState>? refreshableKey,
  bool resubmit = false,
}) {
  String? _company;
  String? _title;
  String? _responsibilities;
  DateTime? _startDate;
  DateTime? _endDate;
  bool? iscurrent = false;
  var _rangeLimitStart = DateTimeRange(start: Jiffy.now().subtract(years: 80).dateTime, end: DateTime.now());
  var _rangeLimitEnd = DateTimeRange(start: Jiffy.now().subtract(years: 80).dateTime, end: DateTime.now());

  ExperiencesResponseDTO experience = ExperiencesResponseDTO();
  Attachment? attachment = experienceInfo?.experienceCertificate != null
      ? Attachment(
          id: experienceInfo?.experienceCertificate?.id,
          name: experienceInfo?.experienceCertificate?.name,
          extension: experienceInfo?.experienceCertificate?.extension,
        )
      : null;

  final formKey = GlobalKey<FormState>();

  iscurrent = experienceInfo?.isCurrent?.toString().isNotEmpty == true ? experienceInfo?.isCurrent! : false;
  _startDate = _startDate ??
      (experienceInfo?.fromDate?.isNotEmpty == true ? dateFormat3.parse(experienceInfo!.fromDate!) : null);
  _endDate =
      _endDate ?? (experienceInfo?.toDate?.isNotEmpty == true ? dateFormat3.parse(experienceInfo!.toDate!) : null);
  _rangeLimitEnd = _startDate?.toString().isNotEmpty == true
      ? DateTimeRange(start: _startDate!, end: DateTime.now())
      : _rangeLimitEnd;

  Future _addOrUpdateExperience(StateSetter setState, {bool update = false, bool resubmit = false}) async {
    final FormState form = formKey.currentState!;
    if (form.validate()) {
      form.save();

      experience.action = resubmit ? experienceInfo?.action : (update ? RequestAction.update : RequestAction.add);
      experience.id = resubmit ? experienceInfo?.id : (update ? experienceInfo?.id : null);
      experience.companyName = _company;
      experience.title = _title;
      experience.description = _responsibilities;
      experience.fromDate = dateFormat3.format(DateTime(_startDate!.year, _startDate!.month, _startDate!.day));
      experience.toDate = _endDate?.toString().isNotEmpty == true
          ? dateFormat3.format(DateTime(_endDate!.year, _endDate!.month, _endDate!.day))
          : null;
      experience.isCurrent = iscurrent;

      final addOrUpdateExperienceResponse = (await showFutureProgressDialog<BaseResponse<String>>(
        context: context,
        initFuture: () => resubmit
            ? ApiRepo().resubmitExperiences(employee!.id, experience, profileRequestInfo?.requestStateId,
                attachment: attachment)
            : ApiRepo().addUpdateDeleteExperience(employee!.id, experience, attachment: attachment),
      ))!;

      Navigator.pop(context);
      if (addOrUpdateExperienceResponse.status!) {
        await showCustomModalBottomSheet(
          context: context,
          isDismissible: false,
          desc: addOrUpdateExperienceResponse?.message ?? " ",
        );
        if (resubmit) refreshableKey!.currentState!.refresh();
      } else {
        await showCustomModalBottomSheet(
          context: context,
          desc: addOrUpdateExperienceResponse.errors != null
              ? addOrUpdateExperienceResponse.message! + " " + (addOrUpdateExperienceResponse.errors?.join('\n') ?? "")
              : addOrUpdateExperienceResponse.message,
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
                  Text(context.appStrings!.startDate,
                      style: Theme.of(context).textTheme.caption!.copyWith(color: DefaultThemeColors.nepal)),
                  DatePickerWidget(
                    date: _startDate,
                    textStyle: _startDate?.toString().isNotEmpty == true && update
                        ? Theme.of(context).textTheme.bodyText2!.copyWith(color: DefaultThemeColors.nobel)
                        : Theme.of(context).textTheme.bodyText2,
                    hint: context.appStrings!.startDate,
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
                        _rangeLimitEnd = DateTimeRange(start: _startDate!, end: DateTime.now());
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
          if (iscurrent!)
            Container()
          else ...[
            SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.appStrings!.endDate,
                      style: Theme.of(context).textTheme.caption!.copyWith(color: DefaultThemeColors.nepal)),
                  DatePickerWidget(
                    date: _endDate,
                    hint: context.appStrings!.endDate,
                    onChange: iscurrent!
                        ? () {}
                        : () async {
                            final result = await showDatePicker(
                                context: context,
                                initialDate: _endDate ?? DateTime.now(),
                                firstDate: _rangeLimitEnd.start,
                                lastDate: _rangeLimitEnd.end,
                                initialEntryMode: DatePickerEntryMode.calendar,
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
          ],
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
                      experienceInfo?.companyName?.isNotEmpty == true
                          ? context.appStrings!.editWorkExperience
                          : context.appStrings!.addWorkExperience,
                      style: Theme.of(context).textTheme.headline5!.copyWith(color: Theme.of(context).primaryColor),
                    ),
                    const SizedBox(height: 24),
                    Text(context.appStrings!.company,
                        style: Theme.of(context).textTheme.caption!.copyWith(color: DefaultThemeColors.nepal)),
                    const SizedBox(height: 8),
                    InnerTextFormField(
                      hintText: context.appStrings!.typeHere,
                      readOnly: experienceInfo?.companyName?.isNotEmpty == true,
                      textStyle: experienceInfo?.companyName?.isNotEmpty == true
                          ? Theme.of(context).textTheme.bodyText2!.copyWith(color: DefaultThemeColors.nobel)
                          : Theme.of(context).textTheme.bodyText2,
                      initialValue:
                          experienceInfo?.companyName?.isNotEmpty == true ? experienceInfo?.companyName : null,
                      validator: (value) => value?.isEmpty ?? true
                          ? context.appStrings!.requiredField
                          : value!.trim().length > 200
                              ? context.appStrings!.companyValidation
                              : null,
                      onSaved: (String? value) => _company = value?.trim() ?? "",
                    ),
                    const SizedBox(height: 24),
                    Text(context.appStrings!.title,
                        style: Theme.of(context).textTheme.caption!.copyWith(color: DefaultThemeColors.nepal)),
                    const SizedBox(height: 8),
                    InnerTextFormField(
                      hintText: context.appStrings!.typeHere,
                      readOnly: experienceInfo?.title?.isNotEmpty == true,
                      textStyle: experienceInfo?.title?.isNotEmpty == true
                          ? Theme.of(context).textTheme.bodyText2!.copyWith(color: DefaultThemeColors.nobel)
                          : Theme.of(context).textTheme.bodyText2,
                      initialValue: experienceInfo?.title?.isNotEmpty == true ? experienceInfo?.title : null,
                      validator: (value) => value?.isEmpty ?? true
                          ? context.appStrings!.requiredField
                          : value!.trim().length > 200
                              ? context.appStrings!.titleValidationTwoHundred
                              : null,
                      onSaved: (String? value) => _title = value?.trim() ?? "",
                    ),
                    const SizedBox(height: 24),
                    Text(context.appStrings!.responsibilities,
                        style: Theme.of(context).textTheme.caption!.copyWith(color: DefaultThemeColors.nepal)),
                    const SizedBox(height: 8),
                    InnerTextFormField(
                      hintText: context.appStrings!.typeHere,
                      maxLines: 3,
                      initialValue:
                          experienceInfo?.description?.isNotEmpty == true ? experienceInfo?.description : null,
                      validator: (value) => value?.isEmpty ?? true
                          ? context.appStrings!.requiredField
                          : value!.trim().length > 500
                              ? context.appStrings!.responsibilitiesValidation
                              : null,
                      onSaved: (String? value) => _responsibilities = value?.trim() ?? "",
                    ),
                    const SizedBox(height: 24),
                    fromToDatePicker(setState),
                    const SizedBox(height: 8),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        context.appStrings!.currentCompany,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: Theme.of(context).colorScheme.secondary),
                      ),
                      activeColor: Theme.of(context).colorScheme.secondary,
                      value: iscurrent,
                      onChanged: (newValue) {
                        setState(() {
                          iscurrent = newValue;
                          if (newValue!) _endDate = DateTime.now();
                          if (!newValue) _endDate = null;
                          if (_startDate?.toString().isNotEmpty == true && _endDate?.toString().isNotEmpty == true) {
                            if (_startDate!.isAfter(_endDate!)) _endDate = null;
                          }
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
                          onPressed: () async => await _addOrUpdateExperience(
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
