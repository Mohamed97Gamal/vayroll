import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveProgressIndicator extends StatelessWidget {
  const AdaptiveProgressIndicator();

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(color: Theme.of(context).colorScheme.secondary);
  }
}
