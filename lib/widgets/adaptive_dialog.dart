import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<T?> showAdaptiveDialog<T>({
  required BuildContext context,
  bool? barrierDismissible,
  required WidgetBuilder builder,
}) async {
  return showDialog<T>(
    context: context,
    builder: builder,
    barrierDismissible: barrierDismissible ?? true,
  );
}
