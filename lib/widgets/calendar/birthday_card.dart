import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';

class BirthdayCard extends StatelessWidget {
  final List<BirthdaysResponse>? birthdays;

  const BirthdayCard({Key? key, this.birthdays}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SvgPicture.asset(
          VPayIcons.birthday,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      title: Text(
        "Birthday",
        style: Theme.of(context).textTheme.subtitle1!.copyWith(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.secondary,
            ),
      ),
      subtitle: ListView.builder(
        itemCount: birthdays!.length,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: ClampingScrollPhysics(),
        // ignore: missing_return
        itemBuilder: (context, index) {
          if (birthdays![index].fullName?.isNotEmpty == true && birthdays![index].birthDate?.isNotEmpty == true)
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  birthdays![index].fullName!,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 15),
                ),
                if (index != birthdays!.length - 1) Divider(),
              ],
            );
        },
      ),
    );
  }
}
