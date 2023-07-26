import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

void showEmailBottomSheet(
    {required BuildContext context,
    required List<String?> toRecipients,
    required String recipientType}) {
  final formKey = GlobalKey<FormState>();
  String? _subject;
  String? _details;
  Attachment? _attachment;

  void _sendEmailToHR(bool hr) async {
    var emailHR = HREmail(
      toRecipients: toRecipients,
      subject: _subject,
      param: EmailParameter(body: _details),
      attachment: _attachment,
      employeeId: context.read<EmployeeProvider>().employee!.id,
      employeesGroupId:
          context.read<EmployeeProvider>().employee!.employeesGroup!.id,
    );

    var email = Email(
      toRecipients: toRecipients,
      subject: _subject,
      param: EmailParameter(body: _details),
      attachment: _attachment,
      employeeId: context.read<EmployeeProvider>().employee!.id,
      employeesGroupId:
          context?.read<EmployeeProvider>().employee?.employeesGroup?.id,
      countryId: context?.read<EmployeeProvider>().employee?.nationality?.id,
    );

    var response = (await showFutureProgressDialog<BaseResponse<List>>(
      context: context,
      initFuture: () =>
          hr ? ApiRepo().sendEmailToHR(emailHR) : ApiRepo().sendEmail(email),
    ))!;

    if (response.status!) {
      await showCustomModalBottomSheet(
        context: context,
        isDismissible: false,
        desc: response.message,
      );
      if (hr) {
        Navigator.of(context).popUntil(ModalRoute.withName(AppRoute.contactHR));
      } else {
        Navigator.of(context).pop();
      }
    } else {
      await showCustomModalBottomSheet(
        context: context,
        desc: response.errors != null
            ? response.message! + " " + (response.errors?.join('\n')??"")
            : response.message ?? context.appStrings!.failedToSendEmail,
        icon: VPayIcons.blockUser,
      );
    }
  }

  void _onSend() {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();

    switch (recipientType) {
      case RecipientType.hr:
        _sendEmailToHR(true);
        break;
      case RecipientType.emp:
        _sendEmailToHR(false);
        break;
    }
  }

  Widget _attachmentWidget(StateSetter setState) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            _attachment!.name!,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(decoration: TextDecoration.underline),
          ),
        ),
        SizedBox(width: 12),
        InkWell(
          onTap: () => showConfirmationBottomSheet(
            context: context,
            desc: context.appStrings!.pleaseConfirmToRemoveThisFile,
            isDismissible: false,
            onConfirm: () async {
              setState(() {
                _attachment = null;
              });
              Navigator.of(context).pop();
            },
          ),
          child: SvgPicture.asset(VPayIcons.delete, height: 16),
        ),
        Spacer(),
      ],
    );
  }

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25), topRight: Radius.circular(25)),
    ),
    builder: (BuildContext context) => StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) => ConstrainedBox(
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
                    context.appStrings!.sendEmail,
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(color: Theme.of(context).primaryColor),
                  ),
                  const SizedBox(height: 24),
                  InnerTextFormField(
                    label: context.appStrings!.to,
                    readOnly: true,
                    textStyle: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: DefaultThemeColors.nobel),
                    initialValue: toRecipients.join(';'),
                    validator: (value) =>
                        value?.isEmpty??true ? context.appStrings!.requiredField : null,
                  ),
                  const SizedBox(height: 24),
                  InnerTextFormField(
                    label: context.appStrings!.subject,
                    maxLines: 5,
                    validator: (value) => value?.isEmpty??true
                        ? context.appStrings!.requiredField
                        : value!.trim().length > 1000
                            ? context.appStrings!
                                .subjectMaxLengthIsOneThousandCharacters
                            : null,
                    onSaved: (value) => _subject = value?.trim() ?? "",
                  ),
                  const SizedBox(height: 24),
                  InnerTextFormField(
                    label: context.appStrings!.details,
                    suffixIcon: IconButton(
                      onPressed: () async {
                        var pickedFile = await pickFile(context,
                            allowedExtensions: allowExtensions);
                        if (pickedFile == null) return;
                        setState(() => _attachment = pickedFile);
                      },
                      icon: Transform.rotate(
                        angle: -pi / 4,
                        child: Icon(
                          Icons.attachment,
                          size: 24,
                          color: DefaultThemeColors.prussianBlue,
                        ),
                      ),
                    ),
                    maxLines: 5,
                    //validator: (value) => value.isEmpty && _attachment == null ? context.appStrings.requiredField : null,
                    onSaved: (value) => _details = value?.trim() ?? "",
                  ),
                  if (_attachment != null) ...[
                    const SizedBox(height: 16),
                    _attachmentWidget(setState),
                  ],
                  const SizedBox(height: 24),
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 300),
                      child: CustomElevatedButton(
                        text: context.appStrings!.send,
                        onPressed: _onSend,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
