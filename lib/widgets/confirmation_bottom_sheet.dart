import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vayroll/widgets/custom_elevated_button.dart';
import 'package:vayroll/utils/utils.dart';

Future<bool?> showConfirmationBottomSheet({
  required BuildContext context,
  required String desc,
  String? icon,
  required Function onConfirm,
  Function? onCancel,
  String? confirmText,
  String? cancelText,
  bool isDismissible = true,
}) async {
  return await showModalBottomSheet<bool>(
    isScrollControlled: true,
    enableDrag: isDismissible,
    isDismissible: isDismissible,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
    ),
    builder: (BuildContext context) => WillPopScope(
      onWillPop: () async => isDismissible,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if ((icon ?? "").isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SvgPicture.asset(
                    icon!,
                    fit: BoxFit.none,
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    desc,
                    textAlign: (icon ?? "").isEmpty ? TextAlign.center : TextAlign.start,
                    style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    text: cancelText?.toUpperCase() ?? context.appStrings!.no.toUpperCase(),
                    textStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
                      ),
                      side: MaterialStateProperty.all(
                          BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1)),
                    ),
                    onPressed: () {
                      if (onCancel != null) onCancel();
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: CustomElevatedButton(
                    text: confirmText ?? context.appStrings!.yes,
                    onPressed: onConfirm as void Function()?,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
