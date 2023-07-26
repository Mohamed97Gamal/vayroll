import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/views/calender/add_note_sheet.dart';
import 'package:vayroll/widgets/confirmation_dialog.dart';
import 'package:vayroll/widgets/widgets.dart';

class NoteCard extends StatefulWidget {
  final List<CalenderNotes>? notes;
  final GlobalKey<RefreshableState>? refreshableKey;
  const NoteCard({Key? key, this.notes, this.refreshableKey}) : super(key: key);

  @override
  State<StatefulWidget> createState() => NoteCardState();
}

class NoteCardState extends State<NoteCard> {
  Future _deleteNote(CalenderNotes note, BuildContext context,
      GlobalKey<RefreshableState>? _refreshableKey) async {
    final deleteNoteResponse =
        (await showFutureProgressDialog<BaseResponse<String>>(
      context: context,
      initFuture: () => ApiRepo().deleteNote(note.id),
    ))!;
    if (deleteNoteResponse.status!) {
      await showCustomModalBottomSheet(
        context: context,
        desc: deleteNoteResponse.message ?? " ",
      );
      _refreshableKey!.currentState!.refresh();
    } else {
      await showCustomModalBottomSheet(
        context: context,
        desc: deleteNoteResponse.message ?? " ",
      );
      _refreshableKey!.currentState!.refresh();
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SvgPicture.asset(
          VPayIcons.notes,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      title: Text(
        context.appStrings!.note,
        style: Theme.of(context).textTheme.subtitle1!.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
      ),
      subtitle: ListView.builder(
        itemCount: widget.notes!.length,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        // ignore: missing_return
        itemBuilder: (context, index) {
          if (widget.notes![index].title?.isNotEmpty == true &&
              widget.notes![index].description?.isNotEmpty == true)
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.notes![index].title ?? "",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                    Spacer(),
                    Container(
                      height: 20,
                      child: PopupMenuButton(
                        color: Theme.of(context).primaryColor,
                        offset: Offset(-5, 10),
                        padding: EdgeInsets.zero,
                        shape: TooltipShape(),
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem(
                              child: Center(
                                child: Text(context.appStrings!.update,
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                              ),
                              value: "Update"),
                          PopupMenuItem(
                              child: Center(
                                child: Text(context.appStrings!.delete,
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                              ),
                              value: "Delete"),
                        ],
                        onSelected: (dynamic value) {
                          if (value == "Update")
                            addNoteModalBottomSheet(
                                context: context,
                                note: widget.notes![index],
                                refreshableKey: widget.refreshableKey);
                          else
                            showConfirmationDialog(
                              actionText:
                                  '${context.appStrings!.areYouSureYouWantToDelete} ${widget.notes![index].title} ${context.appStrings!.note}',
                              title: context.appStrings!.deleteNote,
                              context: context,
                              delete: () async {
                                Navigator.of(context).pop();
                                await _deleteNote(widget.notes![index], context,
                                    widget.refreshableKey);
                              },
                            );
                        },
                      ),
                    ),
                  ],
                ),
                Text(
                  widget.notes![index].description ?? "",
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                ),
                Text(
                  dateFormat.format(DateFormat("yyyy-MM-dd")
                      .parse((widget.notes![index].noteDate!.split("T")[0]))),
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: DefaultThemeColors.nepal,
                      ),
                ),
                if (index != widget.notes!.length - 1) Divider(),
              ],
            );
        },
      ),
      dense: true,
    );
  }
}
