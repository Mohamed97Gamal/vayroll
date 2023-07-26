import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/assets/images.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/title_stack.dart';

class ProfileSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double maxHeight = 250;
  final double minHeight = 164;
  final double animationExtent = 0.8;
  final int animationDurationMilliSeconds = 400;

  final double avatarBigRadius = 44.0;
  final double avatarSmallRadius = 28.0;

  final Uint8List? employeePicUInt8List;
  final String? employeeName;
  final String? employeeId;

  ProfileSliverAppBarDelegate({
    this.employeePicUInt8List,
    this.employeeName,
    this.employeeId,
  });

  double scrollAnimationValue(double shrinkOffset) {
    double maxScrollAllowed = maxExtent - minExtent;
    return ((maxScrollAllowed - shrinkOffset) / maxScrollAllowed).clamp(0, 1).toDouble();
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double animationVal = scrollAnimationValue(shrinkOffset);
    return AppBar(
      primary: true,
      flexibleSpace: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: DefaultThemeColors.whiteSmoke2),
          _buildTitle(context),
          _buildAvatar(employeePicUInt8List, animationVal, context),
          if ((employeeName ?? "").isNotEmpty) _buildEmpName(employeeName!, animationVal, context),
          if ((employeeId ?? "").isNotEmpty) _buildEmpId(employeeId, animationVal, context),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) => Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              TitleStacked(context.appStrings!.profile, DefaultThemeColors.prussianBlue),
              Spacer(),
              InkWell(
                onTap: () => Navigation.navToProfileRequestsPage(context),
                child: Row(
                  children: [
                    Text(
                      context.appStrings!.requests,
                      style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 12),
                    ),
                    SizedBox(width: 12),
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: SvgPicture.asset(VPayIcons.document),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );

  Widget _buildAvatar(Uint8List? photoUInt8List, double animationVal, BuildContext context) {
    return AnimatedContainer(
      padding: EdgeInsets.only(
        top: animationVal < animationExtent ? 80 : 0,
        left: animationVal < animationExtent ? 15 : 0,
      ),
      duration: Duration(milliseconds: animationDurationMilliSeconds),
      curve: Curves.linear,
      alignment: animationVal > animationExtent ? Alignment.center : Alignment.topLeft,
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: animationVal > animationExtent ? avatarBigRadius : avatarSmallRadius,
        backgroundImage: (photoUInt8List != null ? MemoryImage(photoUInt8List) : AssetImage(VPayImages.avatar)) as ImageProvider<Object>?,
      ),
    );
  }

  Widget _buildEmpName(String empName, double animationVal, BuildContext context) {
    return AnimatedContainer(
      padding: EdgeInsets.only(
        top: animationVal < animationExtent ? 30 : 130,
        left: animationVal < animationExtent ? 85 : 0,
      ),
      duration: Duration(milliseconds: animationDurationMilliSeconds),
      curve: Curves.linear,
      alignment: animationVal > animationExtent ? Alignment.center : Alignment.centerLeft,
      child: Text(
        empName,
        style: Theme.of(context).textTheme.headline6,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildEmpId(String? empId, double animationVal, BuildContext context) {
    final fullEmpID = 'Employee ID - $empId';
    return AnimatedContainer(
      padding: EdgeInsets.only(
        top: animationVal < animationExtent ? 90 : 185,
        left: animationVal < animationExtent ? 85 : 0,
      ),
      duration: Duration(milliseconds: animationDurationMilliSeconds),
      curve: Curves.linear,
      alignment: animationVal > animationExtent ? Alignment.center : Alignment.centerLeft,
      child: Text(
        fullEmpID,
        style: Theme.of(context).textTheme.bodyText2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(ProfileSliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxExtent ||
        minHeight != oldDelegate.minExtent ||
        employeeId != oldDelegate.employeeId ||
        employeeName != oldDelegate.employeeName ||
        employeePicUInt8List != oldDelegate.employeePicUInt8List;
  }
}
