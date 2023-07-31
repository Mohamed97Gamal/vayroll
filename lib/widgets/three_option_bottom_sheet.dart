import 'package:flutter/material.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/custom_elevated_button.dart';

Future<bool?> threeOptionBottomSheet({
  required BuildContext context,
  required String desc,
  required Function funOption1,
  required Function funOption2,
  required Function funOption3,
  required String? textOption1,
  required String? textOption2,
  required String textOption3,
  bool isDismissible = true,
}) async {
  return await showModalBottomSheet<bool>(
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
          Text(
            desc,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontWeight: FontWeight.normal),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomElevatedButton(
                  text: textOption1?.toUpperCase() ??
                      context.appStrings!.no.toUpperCase(),
                  textStyle:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(23)),
                    ),
                    side: MaterialStateProperty.all(BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 1)),
                  ),
                  onPressed: funOption1 as void Function()?,
                ),
                SizedBox(height: 12),
                CustomElevatedButton(
                  text: textOption2?.toUpperCase() ?? "",
                  textStyle: TextStyle(color: Colors.white),
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.primary),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(23)),
                    ),
                    side: MaterialStateProperty.all(
                      BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 1,
                      ),
                    ),
                  ),
                  onPressed: funOption2 as void Function()?,
                ),
                SizedBox(height: 12),
                CustomElevatedButton(
                  text: textOption3,
                  onPressed: funOption3 as void Function()?,
                ),
                SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
