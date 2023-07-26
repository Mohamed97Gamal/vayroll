import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:provider/provider.dart';

class AppealManagerHomeIcon extends StatelessWidget {
  final String? employeeId;
  AppealManagerHomeIcon({Key? key, required this.employeeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            VPayIcons.appealManager,
            fit: BoxFit.none,
            color: Colors.white,
          ),
          context.read<HomeTabIndexProvider>().appealManagerIcon!
              ? Positioned(
                  top: 3,
                  child: CircleAvatar(backgroundColor: Theme.of(context).colorScheme.secondary, radius: 4),
                )
              : Container()
        ],
      ),
      onPressed: () => Navigation.navToAppealManagerChat(context),
    );
  }
}
