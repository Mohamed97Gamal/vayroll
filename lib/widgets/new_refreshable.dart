import 'package:flutter/material.dart';
import 'package:vayroll/widgets/widgets.dart';

class NewRefreshable extends StatelessWidget {
  final RefreshNotifier? refreshNotifier;
  final Widget? child;

  NewRefreshable({
     this.refreshNotifier,
     this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: refreshNotifier!,
      builder: (context, dynamic value, __) {
        return Container(
          key: Key(value.toString()),
          child: child,
        );
      },
    );
  }
}