import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';

class HolidayCard extends StatelessWidget {
  final List<PublicHolidaysResponse>? holidays;

  const HolidayCard({Key? key, this.holidays}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SvgPicture.asset(
          VPayIcons.calEdit,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      title: Text(
        "Holiday",
        style: Theme.of(context).textTheme.subtitle1!.copyWith(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.secondary,
            ),
      ),
      subtitle: ListView.builder(
        itemCount: holidays!.length,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        // ignore: missing_return
        itemBuilder: (context, index) {
          if (holidays![index].name?.isNotEmpty == true && holidays![index].date?.isNotEmpty == true)
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  holidays![index].name!,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 15),
                ),
                if (index != holidays!.length - 1) Divider(),
              ],
            );
        },
      ),
    );
  }
}
