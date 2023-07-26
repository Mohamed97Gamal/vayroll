import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/custom_elevated_button.dart';

Future showCustomModalBottomSheet({
  required BuildContext context,
  required String? desc,
  String? icon,
  bool isDismissible = true,
}) async {
  await showModalBottomSheet<dynamic>(
    isScrollControlled: true,
    enableDrag: isDismissible,
    isDismissible: isDismissible,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25), topRight: Radius.circular(25)),
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
                    desc ?? "",
                    textAlign: (icon ?? "").isEmpty
                        ? TextAlign.center
                        : TextAlign.start,
                    style: Theme.of(context).textTheme.subtitle1,
                    softWrap: true,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: 137,
              child: CustomElevatedButton(
                text: context.appStrings!.ok,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
