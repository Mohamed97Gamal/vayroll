import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/widgets/future_builder.dart';
import 'package:vayroll/widgets/widgets.dart';

class NotificationHomeIcon extends StatelessWidget {
  final String? employeeId;
  NotificationHomeIcon({Key? key, required this.employeeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(VPayIcons.notification, fit: BoxFit.none),
          CustomFutureBuilder<BaseResponse<int>>(
            initFuture: () => ApiRepo().getUnreadNotificationCount(employeeId),
            onSuccess: (_, snapshot) {
              var count = snapshot?.data?.result;
              if (count == null || count == 0) return Container(width: 0.0, height: 0.0);
              return Positioned(
                top: 3,
                child: CircleAvatar(backgroundColor: Theme.of(context).colorScheme.secondary, radius: 4),
              );
            },
            onLoading: (context) {
              return Positioned(
                top: 3,
                child: SizedBox(
                  height: 7,
                  width: 7,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 0.5,
                  ),
                ),
              );
            },
            onError: (context, snapshot) => Container(width: 0.0, height: 0.0),
          ),
        ],
      ),
      onPressed: () => Navigation.navToNotification(context),
    );
  }
}
