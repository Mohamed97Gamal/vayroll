import 'package:flutter/material.dart';
import 'package:vayroll/views/walkthrough/walkthrough_01.dart';
import 'package:vayroll/views/walkthrough/walkthrough_02.dart';
import 'package:vayroll/widgets/curved_shape_walkthrough.dart';

class WalkThroughPage extends StatefulWidget {
  @override
  _WalkThroughPageState createState() => _WalkThroughPageState();
}

class _WalkThroughPageState extends State<WalkThroughPage> {
  final int pageCount = 2;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Stack(
          children: [
            Container(color: Theme.of(context).colorScheme.secondary),
            Container(
              height: double.maxFinite,
              width: double.maxFinite,
              child: CustomPaint(
                painter: CurvedShapeWalkthrough(),
              ),
            ),
            PageView(
              children: [
                WalkThrough01(pageCount: pageCount),
                WalkThrough02(pageCount: pageCount),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
