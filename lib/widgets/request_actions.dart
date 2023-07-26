import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/toolip_shape.dart';

class RequestActions extends StatelessWidget {
  final String? status;
  final Function(dynamic value)? onSelected;

  const RequestActions({Key? key, this.status, this.onSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 20,
      child: PopupMenuButton(
        iconSize: 30,
        color: Theme.of(context).primaryColor,
        offset: Offset(-4, 50),
        shape: TooltipShape(),
        icon: Icon(
          Icons.more_vert,
          color: Theme.of(context).primaryColor,
        ),
        itemBuilder: (BuildContext context) => [
          if (status == "NEW") ...[
            PopupMenuItem(
                child: Text(context.appStrings!.resubmit,
                    style: Theme.of(context).textTheme.caption!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w500)),
                value: "Resubmit"),
            PopupMenuItem(
                child: Text(
                  context.appStrings!.delete,
                  style: Theme.of(context).textTheme.caption!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
                value: "Delete"),
          ],
          if (status == "SUBMITTED")
            PopupMenuItem(
              child: Text(context.appStrings!.revoke,
                  style: Theme.of(context).textTheme.caption!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w500)),
              value: "Revoke",
            ),
          if (status == "Details")
            PopupMenuItem(
              child: Text(context.appStrings!.details,
                  style: Theme.of(context).textTheme.caption!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w500)),
              value: "Details",
            ),
        ],
        onSelected: onSelected,
      ),
    );
  }
}
