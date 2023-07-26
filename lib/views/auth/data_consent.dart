import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vayroll/models/api_responses/base_response.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DataConsentPage extends StatefulWidget {
  @override
  DataConsentPageState createState() => DataConsentPageState();
}

class DataConsentPageState extends State<DataConsentPage> {
  late WebViewController _webViewController;
  bool isLoading = false;
  bool showPrivacyPolicy = false;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController();
    _webViewController.loadRequest(Uri.parse( Urls.baseUrl + Urls.termsAndConditions));
    _webViewController.setNavigationDelegate(NavigationDelegate(
      onPageStarted: (started) => setState(() => isLoading = true),
      onPageFinished: (finished) => setState(() => isLoading = false),
    ));
  }

  Future _acceptDataConsent() async {
    final acceptDCResponse = (await showFutureProgressDialog<BaseResponse<String>>(
      context: context,
      initFuture: () => ApiRepo().acceptDataConsent(),
    ))!;

    if (!acceptDCResponse.status!) {
      await showCustomModalBottomSheet(
        context: context,
        desc: acceptDCResponse.message ?? context.appStrings!.dataConsentAcceptanceFailed,
      );
      return;
    }

    await showCustomModalBottomSheet(
      context: context,
      isDismissible: false,
      desc: acceptDCResponse.message ?? context.appStrings!.dataConsentAcceptedSuccessfully,
    );
    await Navigation.navToWalkthrough(context);
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: TitleStacked(context.appStrings!.dataConsent, DefaultThemeColors.prussianBlue),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: Stack(
                  children: [
                    WebViewWidget(
                      controller: _webViewController,
                      gestureRecognizers: Set()
                        ..add(Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer())),
                    ),
                    if (isLoading)
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: MediaQuery.of(context).orientation == Orientation.portrait
                  ? const EdgeInsets.symmetric(vertical: 20)
                  : const EdgeInsets.symmetric(vertical: 10),
              child: !showPrivacyPolicy
                  ? isPortrait
                      ? Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 139,
                              child: CustomElevatedButton(
                                text: context.appStrings!.next,
                                onPressed: () {
                                  _webViewController.loadRequest(Uri.parse(Urls.baseUrl + Urls.privacyPolicy));
                                  setState(() => showPrivacyPolicy = true);
                                },
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: SizedBox(
                            width: 139,
                            child: CustomElevatedButton(
                              text: context.appStrings!.next,
                              onPressed: () {
                                _webViewController.loadRequest(Uri.parse(Urls.baseUrl + Urls.privacyPolicy));
                                setState(() => showPrivacyPolicy = true);
                              },
                            ),
                          ),
                        )
                  : Padding(
                      padding: isPortrait ? const EdgeInsets.all(8.0) : const EdgeInsets.all(0),
                      child: Row(
                        mainAxisAlignment: isPortrait ? MainAxisAlignment.end : MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 120,
                            child: CustomElevatedButton(
                              text: context.appStrings!.reject.toUpperCase(),
                              textStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(0),
                                backgroundColor: MaterialStateProperty.all(Colors.white),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
                                ),
                                side: MaterialStateProperty.all(
                                    BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1)),
                              ),
                              onPressed: () => Navigation.navToLoginAndRemoveUntil(context),
                            ),
                          ),
                          SizedBox(width: 20),
                          SizedBox(
                            width: 120,
                            child: CustomElevatedButton(
                              text: context.appStrings!.accept,
                              onPressed: () => _acceptDataConsent(),
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
