import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class PayslipDetailsPage extends StatefulWidget {
  final Payslip? payslip;

  const PayslipDetailsPage({this.payslip});

  @override
  _PayslipDetailsPageState createState() => _PayslipDetailsPageState();
}

class _PayslipDetailsPageState extends State<PayslipDetailsPage> {
  String? filePath;

  Future<String> _saveFile(String fileBase64, String fileName) async {
    var tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    final String path = '$tempPath/$fileName';
    final File file = File(path);
    file.writeAsBytesSync(base64Decode(fileBase64));
    printIfDebug(path);
    return Future.value(path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
        actions: [
          IconButton(
              onPressed: () {
                if (filePath != null) {
                  Share.shareFiles([filePath!]);
                }
              },
              icon: Icon(Icons.share_outlined, color: Theme.of(context).primaryColor))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_header(context), _body(context), if (!(widget.payslip?.isAppealed ?? false)) _footer(context)],
      ),
    );
  }

  Widget _header(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TitleStacked(context.appStrings!.myPayslip, DefaultThemeColors.prussianBlue),
            Spacer(),
            Text(
              monthYearFormat2.format(widget.payslip!.payrollEmployeeCalculation!.payroll!.payrollCalendar!.endDate!),
              style: Theme.of(context).textTheme.subtitle1,
            )
          ],
        ),
      );

  Widget _body(BuildContext context) => Expanded(
        child: Padding(
          padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: CustomFutureBuilder<BaseResponse<String>>(
            initFuture: () => ApiRepo().getFile(widget.payslip!.defaultPDFReport!.id),
            onSuccess: (context, snapshot) {
              final fileBase64 = snapshot.data?.result;
              final fName = widget.payslip!.reportName! +
                  "_" +
                  (widget.payslip!.payrollEmployeeCalculation!.payroll!.customPayrollType ?? "Salary") +
                  "_" +
                  monthYearFormat3.format(widget.payslip!.payrollEmployeeCalculation!.payroll!.payrollCalendar!.endDate!) +
                  "." +
                  widget.payslip!.defaultPDFReport!.extension!;
              return CustomFutureBuilder<String>(
                initFuture: () => _saveFile(fileBase64!, fName),
                onSuccess: (context, pathSnapshot) {
                  filePath = pathSnapshot.data;
                  return widget.payslip!.defaultPDFReport!.extension == "pdf"
                      ? PdfViewer.openData(
                          base64Decode(fileBase64!),
                          onError: (err) => print(err),
                        )
                      : InteractiveViewer(
                          child: Image.memory(base64Decode(fileBase64!)),
                        );
                },
              );
            },
          ),
        ),
      );

  Widget _footer(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        child: CustomElevatedButton(
          text: context.appStrings!.raiseAppealRequest,
          onPressed: () => Navigation.navToAppealRequest(
              context, widget.payslip!.payrollEmployeeCalculation!.payroll!.id, AppealCategory.payroll),
        ),
      );
}
