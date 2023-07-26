import 'package:flutter/material.dart';

class SingleTapTooltip extends StatelessWidget {
  final Widget child;
  final String? message;
  final double? verticalOffset;

  SingleTapTooltip({
    required this.message,
    required this.child,
    this.verticalOffset,
  });

  @override
  Widget build(BuildContext context) {
    if (message == null) {
      return child;
    }

    final key = GlobalKey<State<Tooltip>>();
    return Tooltip(
      key: key,
      message: message,
      verticalOffset: verticalOffset,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onTap(key),
        child: child,
      ),
    );
  }

  void _onTap(GlobalKey key) {
    final dynamic tooltip = key.currentState;
    tooltip?.ensureTooltipVisible();
  }
}
