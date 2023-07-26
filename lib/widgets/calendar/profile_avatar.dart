import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vayroll/assets/fonts.dart';
import 'package:vayroll/assets/images.dart';
import 'package:vayroll/models/api_responses/base_response.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class ProfileAvatar extends StatelessWidget {
  final BirthdaysResponse? birthdayInfo;
  final Employee? employeeInfo;

  const ProfileAvatar({Key? key, this.birthdayInfo, this.employeeInfo}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final DateTime birthdate = DateFormat("yyyy-MM-ddThh:mm:ss.SSS").parse(birthdayInfo!.birthDate!);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              if (birthdayInfo?.photo?.id?.isNotEmpty == true)
                AvatarFutureBuilder<BaseResponse<String>>(
                  initFuture: () => ApiRepo().getFile(birthdayInfo?.photo?.id),
                  onLoading: (context) => CircleAvatar(
                    radius: 25,
                    backgroundColor: employeeInfo?.birthDate?.toString().isNotEmpty == true
                        ? isSameDayWithoutYear(DateTime.now(), birthdate)
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).primaryColor
                        : Theme.of(context).primaryColor,
                    child: CircleAvatar(radius: 24, backgroundImage: AssetImage(VPayImages.avatar)),
                  ),
                  onSuccess: (context, snapshot) {
                    final String? birthdayPicBase64 = snapshot.data!.result;
                    return CircleAvatar(
                      radius: 25,
                      backgroundColor: employeeInfo?.birthDate?.toString().isNotEmpty == true
                          ? isSameDayWithoutYear(DateTime.now(), birthdate)
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).primaryColor
                          : Theme.of(context).primaryColor,
                      child: CircleAvatar(radius: 24, backgroundImage: MemoryImage(base64Decode(birthdayPicBase64??""))),
                    );
                  },
                )
              else
                CircleAvatar(
                  radius: 25,
                  backgroundColor: employeeInfo?.birthDate?.toString().isNotEmpty == true
                      ? isSameDayWithoutYear(DateTime.now(), birthdate)
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).primaryColor
                      : Theme.of(context).primaryColor,
                  child: CircleAvatar(radius: 24, backgroundImage: AssetImage(VPayImages.avatar)),
                ),
              SizedBox(height: 8),
              Text(
                birthdayInfo!.fullName!.split(" ")[0] +
                    " " +
                    (birthdayInfo!.fullName!.split(" ")[1].length > 7
                        ? birthdayInfo!.fullName!.split(" ")[1].substring(0, 4)
                        : birthdayInfo!.fullName!.split(" ")[1]),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 9,
                    height: 1.20,
                    color: employeeInfo?.birthDate?.toString().isNotEmpty == true
                        ? isSameDayWithoutYear(DateTime.now(), birthdate)
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).primaryColor
                        : Theme.of(context).primaryColor),
              ),
            ],
          ),
          Positioned.fill(
            bottom: -7,
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Container(
                  width: 38,
                  height: 13,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      isSameDayWithoutYear(birthdate, DateTime.now()) ? context.appStrings!.today : DateFormat("d MMM").format(birthdate),
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: isSameDayWithoutYear(DateTime.now(), employeeInfo?.birthDate)
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).primaryColor,
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            fontFamily: Fonts.brandon,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
