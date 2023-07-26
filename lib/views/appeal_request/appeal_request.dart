import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/src/provider.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/providers/key_provider.dart';
import 'package:vayroll/providers/requests_key_provider.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class AppealRequestPage extends StatefulWidget {
  final String? id;
  final String? category;

  const AppealRequestPage({Key? key, required this.id, required this.category}) : super(key: key);

  @override
  _AppealRequestPageState createState() => _AppealRequestPageState();
}

class _AppealRequestPageState extends State<AppealRequestPage> {
  final _formKey = GlobalKey<FormState>();

  bool submitToHrManager = true;
  bool submitToLineManager = true;
  String? note;
  Attachment? attachment;

  void _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    FocusScope.of(context).unfocus();

    var appealRequestInfo = AppealRequest(
      payrollId: (widget.category == AppealCategory.payroll) ? widget.id : null,
      requestId: (widget.category != AppealCategory.payroll) ? widget.id : null,
      category: widget.category,
      submittedToHrManager: submitToHrManager,
      submittedToLineManager: submitToLineManager,
      submitterNote: note,
      attachment: attachment,
      submissionDate: dateFormat3.format(DateTime.now()),
    );

    final response = (await showFutureProgressDialog<BaseResponse<String>>(
      context: context,
      initFuture: () => ApiRepo().sendAppealRequest(appealRequestInfo),
    ))!;

    if (!response.status!) {
      await showCustomModalBottomSheet(
        context: context,
        desc:
            response.errors != null ? response.message! + " " + (response.errors?.join('\n') ?? "") : response.message,
        icon: VPayIcons.blockUser,
      );
      return;
    }

    await showCustomModalBottomSheet(
      context: context,
      isDismissible: false,
      desc: response.message ?? context.appStrings!.appealRequestSubmittedSuccessfully,
    );
    switch (widget.category) {
      case AppealCategory.leave:
        context.read<RequestsKeyProvider>().mykey!.currentState!.refresh();
        Navigator.of(context).popUntil((route) => route.isFirst);
        break;
      case AppealCategory.payroll:
        context.read<KeyProvider>().payslipsKey!.currentState!.refresh();
        Navigator.of(context).popUntil(ModalRoute.withName(AppRoute.payslips));
        break;
      case AppealCategory.expenseClaim:
        context.read<RequestsKeyProvider>().mykey!.currentState!.refresh();
        Navigator.of(context).popUntil((route) => route.isFirst);
        break;
      default:
        Navigator.of(context).pop();
    }
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      child: TitleStacked(context.appStrings!.raiseAppealRequest, DefaultThemeColors.prussianBlue),
    );
  }

  Widget _list() {
    return Expanded(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(30.0),
          children: [
            Row(
              children: [
                Text(context.appStrings!.submitToHRManager, style: Theme.of(context).textTheme.headline6),
                Spacer(),
                CupertinoSwitch(
                  value: submitToHrManager,
                  onChanged: (value) {
                    setState(() {
                      if (!value && !submitToLineManager) submitToLineManager = true;
                      submitToHrManager = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(context.appStrings!.submitToLineManager, style: Theme.of(context).textTheme.headline6),
                Spacer(),
                CupertinoSwitch(
                  value: submitToLineManager,
                  onChanged: (value) {
                    setState(() {
                      if (!value && !submitToHrManager) submitToHrManager = true;
                      submitToLineManager = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            InnerTextFormField(
              label: context.appStrings!.note,
              hintText: context.appStrings!.typeHere,
              maxLines: 5,
              validator: (value2) {
                final value = value2!;
                if (value.trim().isEmpty) return context.appStrings!.requiredField;
                if (value.trim().length > 200) return context.appStrings!.noteMustBeOneToTwoHundredCharacters;
                return null;
              },
              onSaved: (value) => note = value?.trim() ?? "",
            ),
            const SizedBox(height: 24),
            _attachmentWidget(),
            const SizedBox(height: 24),
            CustomElevatedButton(
              text: context.appStrings!.submit,
              onPressed: _onSubmit,
            ),
          ],
        ),
      ),
    );
  }

  Widget _attachmentWidget() {
    return (attachment != null)
        ? Row(
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
                  onTap: () => showConfirmationBottomSheet(
                    context: context,
                    desc: context.appStrings!.pleaseConfirmToDeleteThisFile,
                    isDismissible: false,
                    onConfirm: () async {
                      setState(() => attachment = null);
                      Navigator.of(context).pop();
                    },
                  ),
                  child: SvgPicture.asset(VPayIcons.delete),
                ),
              ),
            ],
          )
        : CameraUploadWidget(
            uploadFile: () async {
              var pickedFile = await pickFile(context, allowedExtensions: allowExtensions);
              if (pickedFile == null) return;
              setState(() => attachment = pickedFile);
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_header(), _list()],
      ),
    );
  }
}
