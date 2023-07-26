import 'package:flutter/widgets.dart';
import 'package:vayroll/utils/utils.dart';

class Refreshable extends StatefulWidget {
  final Widget? child;
  final VoidCallback? onRefresh;

  Refreshable({Key? key, this.child, this.onRefresh}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RefreshableState();

  static RefreshableState? of(BuildContext context, {bool nullOk = false}) {
    assert(nullOk != null);
    assert(context != null);
    final result = context.findAncestorStateOfType<RefreshableState>();
    if (nullOk || result != null) return result;
    throw Exception(context.appStrings!.refreshableException);
  }
}

class RefreshableState extends State<Refreshable> {
  var _key = UniqueKey();

  @override
  Widget build(BuildContext context) => Container(key: _key, child: widget.child);

  void refresh() {
    setState(() {
      widget.onRefresh?.call();
      _key = UniqueKey();
    });
  }
}
