import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsAndConditionsPage extends StatefulWidget {
  @override
  TermsAndConditionsPageState createState() => TermsAndConditionsPageState();
}

class TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  // ignore: unused_field
  late WebViewController _webViewController;
  bool isLoading = false;
  bool showPrivacyPolicy = false;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController();
    _webViewController.setNavigationDelegate(NavigationDelegate(
      onPageStarted: (started) => setState(() => isLoading = true),
      onPageFinished: (finished) => setState(() => isLoading = false),
    ));
    _webViewController
        .loadRequest(Uri.parse(Urls.baseUrl + Urls.termsAndConditions));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(leading: CustomBackButton()),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: TitleStacked(context.appStrings!.termsAndConditions,
                  DefaultThemeColors.prussianBlue),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                child: Stack(
                  children: [
                    ColoredBox(
                      color: Colors.white,
                      child: WebViewWidget(
                        gestureRecognizers: Set()
                          ..add(Factory<VerticalDragGestureRecognizer>(
                              () => VerticalDragGestureRecognizer())),
                        controller: _webViewController,
                      ),
                    ),
                    if (isLoading)
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.secondary),
                            const SizedBox(height: 12),
                            Text(
                              context.appStrings!.loading,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
