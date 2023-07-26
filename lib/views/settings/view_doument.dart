import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:vayroll/models/api_responses/base_response.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/custom_elevated_button.dart';
import 'package:vayroll/widgets/future_builder.dart';
import 'package:vayroll/widgets/splash_art.dart';
import 'package:vayroll/widgets/widgets.dart';

class ViewDecoument extends StatefulWidget {
  final Attachment? documentFile;

  const ViewDecoument({Key? key, this.documentFile}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ViewDecoumentState();
}

class ViewDecoumentState extends State<ViewDecoument> {
  final controller = PdfViewerController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomFutureBuilder<BaseResponse<List<int>>>(
                initFuture: () => ApiRepo().getHelpDocumentAttachment(widget.documentFile?.id),
                onLoading: (context) {
                  return Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8.0),
                    child: const SplashArt(message: 'Loading...'),
                  );
                },
                onSuccess: (context, snapshot) {
                  final List<int> bytes = snapshot.data!.result!;
                  var picBase64 = Uint8List.fromList(bytes);
                  return widget.documentFile?.extension == "pdf"
                      ? PdfViewer.openData(
                          picBase64,
                          viewerController: controller,
                          onError: (err) => print(err),
                        )
                      : Image.memory(picBase64);
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: CustomElevatedButton(
              text: context.appStrings!.close,
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
