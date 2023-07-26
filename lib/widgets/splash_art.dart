import 'package:flutter/material.dart';
import 'package:vayroll/widgets/adaptive_progress_indicator.dart';

class SplashArt extends StatefulWidget {
  final bool dark;
  final String? message;

  const SplashArt({this.dark = false, this.message});

  @override
  _SplashArtState createState() => _SplashArtState();
}

class _SplashArtState extends State<SplashArt> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AdaptiveProgressIndicator(),
            if (widget.message != null) ...[
              const SizedBox(height: 12),
              Text(widget.message!),
            ],
          ],
        ),
      ),
    );
  }
}
