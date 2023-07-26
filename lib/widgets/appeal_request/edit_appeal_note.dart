import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/future_dialog.dart';
import 'package:vayroll/widgets/widgets.dart';

void editAppealNote(BuildContext context, AppealNote note, String? appealRequestId, String? employeeId,
    {Function? postEditCallBack}) async {
  final _editNoteFormKey = GlobalKey<FormState>();
  Attachment? attachment;

  if (note.attachment != null) {
    attachment = note.attachment;
  }

  void _onUpdate() async {
    if (!_editNoteFormKey.currentState!.validate()) return;
    _editNoteFormKey.currentState!.save();

    var noteRequestInfo = AppealNoteRequest(
      appealRequestId: appealRequestId,
      employeeId: employeeId,
      noteId: note.id,
      note: note.note,
      attachment: attachment,
    );

    final response = (await showFutureProgressDialog<BaseResponse<String>>(
      context: context,
      initFuture: () => ApiRepo().sendAppealNote(noteRequestInfo),
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

    Navigator.of(context).pop();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await showCustomModalBottomSheet(
          context: context,
          isDismissible: false,
          desc: response.message ?? "Note Updated successfully",
        );
        if (postEditCallBack != null) postEditCallBack();
      },
    );
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Form(
            key: _editNoteFormKey,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.fromLTRB(30, 30, 30, MediaQuery.of(context).viewInsets.bottom + 30),
              children: [
                InnerTextFormField(
                  label: context.appStrings!.note,
                  hintText: context.appStrings!.typeHere,
                  maxLines: 5,
                  initialValue: note.note,
                  validator: (value) {
                    if (value?.trim().isEmpty ?? true) return context.appStrings!.requiredField;
                    if (value!.trim().length > 200) return context.appStrings!.noteMustBeOneToTwoHundredCharacters;
                    return null;
                  },
                  onSaved: (value) => note.note = value?.trim() ?? "",
                ),
                const SizedBox(height: 24),
                (attachment != null)
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
                      ),
                const SizedBox(height: 24),
                CustomElevatedButton(
                  text: context.appStrings!.update,
                  onPressed: _onUpdate,
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
