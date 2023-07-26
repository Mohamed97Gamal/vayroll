import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/providers/employee_provider.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/widgets/widgets.dart';
import 'package:vayroll/utils/utils.dart';

class AnnouncementDetailsPage extends StatefulWidget {
  final String? announcementId;
  final bool isDeepLinking;

  const AnnouncementDetailsPage({Key? key, this.announcementId, this.isDeepLinking=false}) : super(key: key);

  @override
  _AnnouncementDetailsPageState createState() => _AnnouncementDetailsPageState();
}

class _AnnouncementDetailsPageState extends State<AnnouncementDetailsPage> {
  String? _employeeId;

  @override
  void initState() {
    super.initState();
    _employeeId = context.read<EmployeeProvider>().employee?.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(
          onPressed: widget.isDeepLinking
              ? () async {
                  context.read<KeyProvider>().announcementsListKey!.currentState!.refresh();
                  Navigator.pop(context);
                }
              : null,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_header(context), _body(context)],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 16),
      child: TitleStacked(context.appStrings!.announcement, DefaultThemeColors.prussianBlue),
    );
  }

  Widget _body(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: CustomFutureBuilder<BaseResponse<Announcement>>(
            initFuture: () => ApiRepo().getAnnouncementById(_employeeId, widget.announcementId),
            onSuccess: (context, snapshot) {
              var announcement = snapshot.data!.result;
              return announcement?.isRead ?? false
                  ? _announcementBody(context, announcement!)
                  : CustomFutureBuilder<BaseResponse<bool>>(
                      initFuture: () => ApiRepo().markAnnouncementAsRead(_employeeId, widget.announcementId),
                      onSuccess: (context, readSnapshot) {
                        Future.microtask(
                          () {
                            context.read<KeyProvider>().homeAnnouncementsNotifier.refresh();
                          },
                        );
                        return _announcementBody(context, announcement!);
                      },
                    );
            },
          ),
        ),
      ),
    );
  }

  Widget _announcementBody(BuildContext context, Announcement announcement) {
    late var bytes;
    if (announcement.attachment != null) {
      bytes = Uint8List.fromList(announcement.attachment!.content!);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (announcement.attachment != null) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.memory(
              bytes,
              fit: BoxFit.fitWidth,
            ),
          ),
          const SizedBox(height: 16),
        ],
        Text(
          announcement.title ?? "",
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(height: 8),
        Text(
          announcement.text ?? "",
          style: Theme.of(context).textTheme.bodyText2!.copyWith(color: DefaultThemeColors.nepal),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
