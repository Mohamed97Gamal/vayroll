import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TitleStacked extends StatelessWidget {
  final String? title;
  final Color titleColor;
  TitleStacked(this.title, this.titleColor);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          title!,
          style: Theme.of(context).textTheme.headline4!.copyWith(color: titleColor),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: Container(
            height: 5,
            width: 22,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        )
      ],
    );
  }
}
