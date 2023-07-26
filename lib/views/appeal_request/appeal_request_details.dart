import 'dart:collection';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:synchronized/synchronized.dart';
import 'package:vayroll/assets/fonts.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/repo/disk/disk_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/views/more/appeal_manager/appeal_manager.dart';
import 'package:vayroll/widgets/widgets.dart';

class AppealRequestDetailsPage extends StatefulWidget {
  final Lock? lock;
  final HashMap<String?, EmployeeWithImage>? employeeCache;

  final String? id;
  final EmployeeInfo? employee;

  const AppealRequestDetailsPage({
    required this.lock,
    required this.employeeCache,
    this.id,
    this.employee,
    Key? key,
  }) : super(key: key);

  @override
  _AppealRequestDetailsPageState createState() => _AppealRequestDetailsPageState();
}

class _AppealRequestDetailsPageState extends State<AppealRequestDetailsPage> {
  var refreshableKey = GlobalKey<RefreshableState>();
  var formKey = GlobalKey<FormState>();
  var noteController = TextEditingController();
  var noteFocusNode = FocusNode();
  var scrollController = ScrollController();

  EmployeeInfo? _employee;
  Attachment? attachment;
  String? noteText;
  Appeal? appealDetails;
  double? scrollOffset;

  _onSendNote() async {
    if (!formKey.currentState!.validate()) return;

    noteFocusNode.unfocus();

    var noteRequestInfo = AppealNoteRequest(
      appealRequestId: appealDetails!.id,
      employeeId: _employee!.id,
      note: noteText,
      attachment: attachment,
    );

    final response = (await showFutureProgressDialog<BaseResponse<String>>(
      context: context,
      initFuture: () => ApiRepo().sendAppealNote(noteRequestInfo),
    ))!;

    if (!response.status!) {
      await showCustomModalBottomSheet(
        context: context,
        desc: response.errors != null ? response.message! + " " + (response.errors?.join('\n')??"") : response.message,
        icon: VPayIcons.blockUser,
      );
      return;
    }

    await showCustomModalBottomSheet(
      context: context,
      isDismissible: false,
      desc: response.message ?? context.appStrings!.noteAddedSuccessfully,
    );
    setState(() {
      attachment = null;
      noteController.text = "";
      noteText = "";
    });
    refreshableKey.currentState!.refresh();
  }

  _onUserNoteLongPress(AppealNote note) async {
    var result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      builder: (context) {
        return ListTile(
          contentPadding: EdgeInsets.all(16),
          title: Text(context.appStrings!.editNote),
          onTap: () {
            Navigator.of(context).pop('edit');
          },
          leading: Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                new BoxShadow(
                  blurRadius: 6,
                  color: DefaultThemeColors.gainsboro,
                  offset: new Offset(0, 3),
                )
              ],
            ),
            child: Icon(
              Icons.edit,
              color: Theme.of(context).primaryColor,
            ),
          ),
        );
      },
    );

    if (result == 'edit') {
      editAppealNote(context, note, appealDetails!.id, _employee!.id, postEditCallBack: _editCallBack);
    }
  }

  void _editCallBack() {
    refreshableKey.currentState!.refresh();
    scrollOffset = scrollController.offset;
  }

  @override
  void initState() {
    super.initState();

    if (widget.employee?.id == null) {
      _employee = EmployeeInfo(
        id: context.read<EmployeeProvider>().employee?.id,
        employeeNumber: context.read<EmployeeProvider>().employee?.employeeNumber,
        firstName: context.read<EmployeeProvider>().employee?.firstName,
        familyName: context.read<EmployeeProvider>().employee?.familyName,
        fullName: context.read<EmployeeProvider>().employee?.fullName,
        hireDate: context.read<EmployeeProvider>().employee?.hireDate,
        email: context.read<EmployeeProvider>().employee?.email,
        contactNumber: context.read<EmployeeProvider>().employee?.contactNumber,
        address: context.read<EmployeeProvider>().employee?.address,
        title: context.read<EmployeeProvider>().employee?.title,
        gender: context.read<EmployeeProvider>().employee?.gender,
        birthDate: context.read<EmployeeProvider>().employee?.birthDate,
        photo: context.read<EmployeeProvider>().employee?.photo,
      );
    } else {
      _employee = widget.employee;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: CustomBackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
        child: Column(
          children: [
            Expanded(
              child: CustomFutureBuilder<String?>(
                initFuture: () => DiskRepo().getUserId(),
                onSuccess: (context, snapshot) {
                  final userId = snapshot.data;
                  return Refreshable(
                    key: refreshableKey,
                    child: CustomFutureBuilder<BaseResponse<Appeal>>(
                      initFuture: () => ApiRepo().getAppealRequestDetails(widget.id),
                      onSuccess: (context, appealDetailsSnapshot) {
                        appealDetails = appealDetailsSnapshot.data!.result;
                        appealDetails!.notes!.sort((a, b) => a.createDate!.compareTo(b.createDate!));
                        WidgetsBinding.instance.addPostFrameCallback(
                          (_) {
                            if (scrollOffset != null) {
                              scrollController.animateTo(
                                scrollOffset!,
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                              );
                              scrollOffset = null;
                            }
                          },
                        );
                        return ListView(
                          controller: scrollController,
                          shrinkWrap: true,
                          reverse: true,
                          children: [
                            (userId == appealDetails!.notes![0].submitterId)
                                ? HeaderNoteUser(
                                    appealDetails: appealDetails,
                                    employeePhotoBytes: context.read<EmployeeProvider>().employee!.photoBytes,
                                  )
                                : HeaderNoteOther(
                                    appealDetails: appealDetails,
                                    employeePhotoId: appealDetails?.notes![0].submitterPhotoId,
                                  ), //
                            SizedBox(height: 16),
                            ListView.separated(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: appealDetails!.notes!.length,
                              separatorBuilder: (separatorContext, i) => SizedBox(height: 16),
                              itemBuilder: (notesContext, i) {
                                return (i != 0 &&
                                        !isSameDay(
                                          appealDetails!.notes![i - 1].createDate,
                                          appealDetails!.notes![i].createDate,
                                        ))
                                    ? Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(vertical: 1, horizontal: 8),
                                            decoration: BoxDecoration(
                                              color: DefaultThemeColors.whiteSmoke1,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              dateFormat4.format(appealDetails!.notes![i].createDate!),
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal,
                                                fontFamily: Fonts.brandon,
                                                color: DefaultThemeColors.dimGray,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          AppealNoteListTile(
                                            lock: widget.lock,
                                            employeeCache: widget.employeeCache,
                                            note: appealDetails!.notes![i],
                                            employee: _employee,
                                            currentUserId: userId,
                                            currentUserPhotoBytes: context.read<EmployeeProvider>().employee!.photoBytes,
                                            onUserNoteLongPress: () => _onUserNoteLongPress(
                                              appealDetails!.notes![i],
                                            ),
                                          )
                                        ],
                                      )
                                    : AppealNoteListTile(
                                        lock: widget.lock,
                                        employeeCache: widget.employeeCache,
                                        note: appealDetails!.notes![i],
                                        employee: _employee,
                                        currentUserId: userId,
                                        currentUserPhotoBytes: context.read<EmployeeProvider>().employee!.photoBytes,
                                        onUserNoteLongPress: () => _onUserNoteLongPress(appealDetails!.notes![i]),
                                      );
                              },
                            ),
                            SizedBox(height: 16),
                          ].reversed.toList(),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            _footer(),
          ],
        ),
      ),
    );
  }

  Widget _footer() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _attachmentWidget(),
        Form(
          key: formKey,
          child: InnerTextFormField(
            hintText: context.appStrings!.askYourQuery,
            controller: noteController,
            focusNode: noteFocusNode,
            validator: (value) {
              if (value == null || value.isEmpty || value.trim().isEmpty || value.trim().length > 200)
                return context.appStrings!.noteMustBeOneToTwoHundredCharacters;
              return null;
            },
            onChanged: (value) => noteText = value,
            prefixIcon: IconButton(
              onPressed: () async {
                var pickedFile = await pickFile(context, allowedExtensions: allowExtensions);
                if (pickedFile == null) return;
                setState(() => attachment = pickedFile);
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
            suffixIcon: IconButton(
              onPressed: _onSendNote,
              iconSize: 34,
              icon: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                child: SvgPicture.asset(
                  VPayIcons.send,
                  width: 22,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _attachmentWidget() {
    return (attachment != null)
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  attachment!.name!,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption!.copyWith(decoration: TextDecoration.underline),
                ),
              ),
              SizedBox(width: 12),
              InkWell(
                onTap: () => showConfirmationBottomSheet(
                  context: context,
                  desc: context.appStrings!.pleaseConfirmToDeleteThisFile,
                  isDismissible: false,
                  onConfirm: () async {
                    setState(() {
                      attachment = null;
                    });
                    Navigator.of(context).pop();
                  },
                ),
                child: SvgPicture.asset(VPayIcons.delete, height: 16),
              ),
              Spacer(),
            ],
          )
        : Container();
  }
}
