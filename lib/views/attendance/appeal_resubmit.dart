import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/providers/employee_provider.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class AttendanceAppealResubmitPage extends StatefulWidget {
  final MyRequestsResponseDTO? attendanceInfo;
  final GlobalKey<RefreshableState>? refreshableKey;

  const AttendanceAppealResubmitPage({Key? key, this.attendanceInfo, this.refreshableKey}) : super(key: key);

  @override
  _AttendanceAppealResubmitPageState createState() => _AttendanceAppealResubmitPageState();
}

class _AttendanceAppealResubmitPageState extends State<AttendanceAppealResubmitPage> {
  final _formKey = GlobalKey<FormState>();

  String? id, requestStateId, employeeId;
  DateTime? appealDate;
  TimeOfDay? checkInTime, checkOutTime;
  String? note;
  Attachment? attachment;

  @override
  void initState() {
    super.initState();
    id = widget.attendanceInfo?.transactionUUID;
    requestStateId = widget.attendanceInfo?.requestStateId;
    employeeId = context.read<EmployeeProvider>().employee!.id;
    appealDate = DateTime.tryParse(widget.attendanceInfo?.attributes
        ?.firstWhereOrNull((attribute) => attribute.code!.toUpperCase() == 'APPEAL_DATE')
        ?.value);
    var checkInDateTime = DateTime.tryParse(widget.attendanceInfo?.attributes
        ?.firstWhereOrNull((attribute) => attribute.code!.toUpperCase() == 'CHECKIN_TIME')
        ?.value);
    var checkOutDateTime = DateTime.tryParse(widget.attendanceInfo?.attributes
        ?.firstWhereOrNull((attribute) => attribute.code!.toUpperCase() == 'CHECKOUT_TIME')
        ?.value);
    checkInTime = TimeOfDay.fromDateTime(checkInDateTime ?? DateTime.now());
    checkOutTime = TimeOfDay.fromDateTime(checkOutDateTime ?? checkInDateTime!.add(Duration(minutes: 1)));
    note = widget.attendanceInfo?.attributes
        ?.firstWhereOrNull((attribute) => attribute.code!.toUpperCase() == 'NOTE')
        ?.value;

    var attachmentsMap = widget.attendanceInfo!.attributes!
        .firstWhereOrNull(
          (element) => element.code == "ATTACHMENT",
        )
        ?.value;
    attachment = (attachmentsMap != null && attachmentsMap.isNotEmpty)
        ? Attachment(id: attachmentsMap['id'], name: attachmentsMap['name'], extension: attachmentsMap['extension'])
        : null;
  }

  void _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    FocusScope.of(context).unfocus();

    var checkIn = DateTime(appealDate!.year, appealDate!.month, appealDate!.day, checkInTime!.hour, checkInTime!.minute);
    var checkOut = DateTime(appealDate!.year, appealDate!.month, appealDate!.day, checkOutTime!.hour, checkOutTime!.minute);

    final response = (await showFutureProgressDialog<BaseResponse<String>>(
      context: context,
      initFuture: () => ApiRepo().resubmitAttendanceAppealRequest(
          id, requestStateId, employeeId, appealDate!, checkIn, checkOut, note, attachment),
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
      desc: response.message,
    );
    widget.refreshableKey!.currentState!.refresh();
    Navigator.of(context).popUntil(ModalRoute.withName(AppRoute.attendance));
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      child: TitleStacked(context.appStrings!.resubmitAppealRequest, DefaultThemeColors.prussianBlue),
    );
  }

  Widget _list() {
    return Expanded(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(30.0),
          children: [
            InnerTextFormField(
              textStyle: Theme.of(context).textTheme.bodyText2!.copyWith(color: DefaultThemeColors.nobel),
              readOnly: true,
              label: context.appStrings!.checkInDate,
              initialValue: dateFormat.format(appealDate!),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _checkInTimeWidget()),
                const SizedBox(width: 12),
                Expanded(child: _checkOutTimeWidget()),
              ],
            ),
            const SizedBox(height: 24),
            InnerTextFormField(
              label: context.appStrings!.note,
              maxLines: 5,
              initialValue: note,
              validator: (value) {
                if ((value?.trim().length??0) > 200) return context.appStrings!.noteMustBeOneToTwoHundredCharacters;
                return null;
              },
              onSaved: (value) => note = value?.trim() ?? "",
            ),
            const SizedBox(height: 24),
            _attachmentWidget(),
            const SizedBox(height: 24),
            CustomElevatedButton(
              text: context.appStrings!.resubmit,
              onPressed: _onSubmit,
            ),
          ],
        ),
      ),
    );
  }

  Widget _checkInTimeWidget() {
    return Container(
      height: 100,
      child: InnerTextFormField(
        label: context.appStrings!.checkInTime,
        textAlignVertical: TextAlignVertical.bottom,
        controller: TextEditingController(text: checkInTime != null ? checkInTime!.format(context) : ""),
        readOnly: true,
        suffixIcon: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).primaryColor),
        validator: (value) => value?.isEmpty??true ? context.appStrings!.requiredField : null,
        onTap: () async {
          final result = await showTimePicker(
            context: context,
            initialTime: checkInTime ?? TimeOfDay.now(),
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
            checkInTime = result;
            if (checkInTime!.compareTo(checkOutTime!) != -1) checkOutTime = null;
          });
        },
      ),
    );
  }

  Widget _checkOutTimeWidget() {
    return Container(
      height: 100,
      child: InnerTextFormField(
        label: context.appStrings!.checkOutTime,
        textAlignVertical: TextAlignVertical.bottom,
        controller: TextEditingController(text: checkOutTime != null ? checkOutTime!.format(context) : ""),
        readOnly: true,
        suffixIcon: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).primaryColor),
        validator: (value) => value?.isEmpty??true ? context.appStrings!.requiredField : null,
        onTap: () async {
          final result = await showTimePicker(
            context: context,
            initialTime: checkOutTime ?? TimeOfDay.now(),
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
            checkOutTime = result;
            if (checkOutTime!.compareTo(checkInTime!) != 1) checkInTime = null;
          });
        },
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
