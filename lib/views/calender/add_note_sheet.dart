import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/models/api_responses/base_response.dart';
import 'package:vayroll/models/events/calender_notes.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/common.dart';
import 'package:vayroll/widgets/widgets.dart';

void addNoteModalBottomSheet({
  required BuildContext context,
  required GlobalKey<RefreshableState>? refreshableKey,
  CalenderNotes? note,
  DateTime? selectedDate,
}) {
  final formKey = GlobalKey<FormState>();
  final _rangeLimit = DateTimeRange(end: DateTime(DateTime.now().year + 2, 1, 0), start: DateTime.now());
  DateTime? _date;
  String? _title;
  String? _desc;

  bool checkgStatus = note?.title?.isNotEmpty == true;

  Future _addNote() async {
    final FormState form = formKey.currentState!;
    if (form.validate()) {
      form.save();

      final addNoteResponse = await showFutureProgressDialog<BaseResponse<String>>(
        context: context,
        initFuture: () => ApiRepo().createNote(_title, _desc,
            (_date?.toString().isNotEmpty == true ? dateFormat2.format(_date!) : dateFormat2.format(selectedDate!))),
      );
      Navigator.pop(context);

      if (addNoteResponse?.status ?? false) {
        await showCustomModalBottomSheet(
          context: context,
          desc: addNoteResponse?.message ?? " ",
        );
        refreshableKey!.currentState!.refresh();
        context.read<KeyProvider>().homeCalendarNotifier.refresh();
      } else {
        await showCustomModalBottomSheet(
          context: context,
          desc: addNoteResponse?.message ?? " ",
        );
        refreshableKey!.currentState!.refresh();
        context.read<KeyProvider>().homeCalendarNotifier.refresh();
        return;
      }
    }
  }

  Future _updateNote() async {
    final FormState form = formKey.currentState!;
    if (form.validate()) {
      form.save();
      final updateNoteResponse = (await showFutureProgressDialog<BaseResponse<String>>(
        context: context,
        initFuture: () => ApiRepo().updateNote(note!.id, _title, _desc),
      ))!;

      Navigator.pop(context);

      if (updateNoteResponse.status!) {
        await showCustomModalBottomSheet(
          context: context,
          desc: updateNoteResponse?.message ?? " ",
        );
        refreshableKey!.currentState!.refresh();
      } else {
        await showCustomModalBottomSheet(
          context: context,
          desc: updateNoteResponse?.message ?? " ",
        );
        refreshableKey!.currentState!.refresh();
        return;
      }
    }
  }

  WidgetsBinding.instance.addPostFrameCallback(
    (_) {
      showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        builder: (BuildContext context) {
          _date = _date ?? (checkgStatus ? DateTime.parse(note!.noteDate!) : null);
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(30, 30, 30, MediaQuery.of(context).viewInsets.bottom + 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            context.appStrings!.addANoteOnCalendar,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(fontSize: 24, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 16),
                          Text(context.appStrings!.selectADate,
                              style: Theme.of(context).textTheme.caption!.copyWith(color: DefaultThemeColors.nepal)),
                          AbsorbPointer(
                            absorbing: checkgStatus,
                            child: Container(
                              constraints: BoxConstraints(minHeight: 30, maxHeight: 70),
                              child: DatePickerWidget(
                                date: _date ?? selectedDate,
                                hint: context.appStrings!.noteDate,
                                textStyle: _date?.toString().isNotEmpty == true && checkgStatus
                                    ? Theme.of(context).textTheme.bodyText2!.copyWith(color: DefaultThemeColors.nobel)
                                    : Theme.of(context).textTheme.bodyText2,
                                onChange: () async {
                                  final result = await showDatePicker(
                                      context: context,
                                      initialDate: _date ?? selectedDate ?? DateTime.now(),
                                      firstDate: _rangeLimit.start,
                                      lastDate: _rangeLimit.end,
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
                                    _date = result;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                          Text(context.appStrings!.titleWithStar,
                              style: Theme.of(context).textTheme.caption!.copyWith(color: DefaultThemeColors.nepal)),
                          SizedBox(height: 8),
                          CommonTextField(
                            hintText: context.appStrings!.noteTitle,
                            initialValue: note?.title?.isNotEmpty == true ? note?.title : null,
                            contentPadding: EdgeInsets.only(bottom: 8),
                            textStyle:
                                Theme.of(context).textTheme.caption!.copyWith(color: Theme.of(context).primaryColor),
                            labelStyle:
                                Theme.of(context).textTheme.caption!.copyWith(color: Theme.of(context).primaryColor),
                            hintStyle:
                                Theme.of(context).textTheme.bodyText2!.copyWith(color: DefaultThemeColors.gainsboro),
                            textInputAction: TextInputAction.next,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: DefaultThemeColors.nepal),
                            ),
                            fillColor: Colors.transparent,
                            onSaved: (String? value) => _title = value?.trim() ?? "",
                            validator: (value) => value?.isEmpty??true
                                ? context.appStrings!.requiredField
                                : value!.trim().length > 100
                                    ? context.appStrings!.titleValidation
                                    : null,
                          ),
                          SizedBox(height: 24),
                          Text(context.appStrings!.descriptionWithStar,
                              style: Theme.of(context).textTheme.caption!.copyWith(color: DefaultThemeColors.nepal)),
                          SizedBox(height: 8),
                          InnerTextFormField(
                            hintText: context.appStrings!.typeHere,
                            maxLines: 3,
                            minLines: 3,
                            initialValue: note?.description?.isNotEmpty == true ? note?.description : null,
                            validator: (value) => value?.isEmpty ?? true
                                ? context.appStrings!.requiredField
                                : value!.trim().length > 500
                                    ? context.appStrings!.descriptionValidation
                                    : null,
                            onSaved: (String? value) => _desc = value?.trim() ?? "",
                          ),
                          SizedBox(height: 24),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: CustomElevatedButton(
                              text: checkgStatus
                                  ? context.appStrings!.update.toUpperCase()
                                  : context.appStrings!.save.toUpperCase(),
                              onPressed: checkgStatus ? _updateNote : _addNote,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    },
  );
}
