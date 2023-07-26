import 'package:vayroll/widgets/adaptive_alert_dialog.dart';
import 'package:vayroll/widgets/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vayroll/utils/utils.dart';

Future<bool> showConfirmationDialog({
  required BuildContext context,
  required String actionText,
  required Function delete,
  String? title,
  bool barrierDismissible = true,
}) async {
  final result = await showAdaptiveDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) {
      return AdaptiveAlertDialog(
        content: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: ListBody(
            children: <Widget>[
              Text(actionText),
            ],
          ),
        ),
        actions: <AdaptiveAlertDialogAction>[
          AdaptiveAlertDialogAction(
            title: context.appStrings!.cancel,
            onPressed: () => Navigator.of(context).pop(),
          ),
          AdaptiveAlertDialogAction(
            title: context.appStrings!.delete,
            isPrimary: true,
            onPressed: delete as void Function(),
          )
        ],
      );
    },
  );
  return result ?? false;
}
