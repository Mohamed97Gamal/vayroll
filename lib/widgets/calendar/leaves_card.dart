import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';

class LeavesCard extends StatelessWidget {
  final List<LeaveResponse>? leaves;

  const LeavesCard({Key? key, this.leaves}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SvgPicture.asset(
          VPayIcons.sunbed,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      title: Text(
        "Leaves",
        style: Theme.of(context).textTheme.subtitle1!.copyWith(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.secondary,
            ),
      ),
      subtitle: ListView.builder(
        itemCount: leaves!.length,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        // ignore: missing_return
        itemBuilder: (context, int) {
          if (leaves![int].type?.isNotEmpty == true && leaves![int].dates?.isNotEmpty == true)
            return Text(
              leaves![int].type!,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 15),
            );
          // ListView.builder(
          //   itemCount: leaves[int].dates.length,
          //   shrinkWrap: true,
          //   physics: ClampingScrollPhysics(),
          //   // ignore: missing_return
          //   itemBuilder: (context, index) {
          //     return Column(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [

          //         if (index != leaves.length - 1) Divider(),
          //       ],
          //     );
          //   },
          // );
        },
      ),
    );
  }
}
