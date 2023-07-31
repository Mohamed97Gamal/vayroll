import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/widgets/widgets.dart';

class SubmitRequestPage extends StatefulWidget {
  final String? title;
  final String? requestKind;
  final String? requestStateId;
  final bool resubmit;

  const SubmitRequestPage({
    Key? key,
    this.title,
    this.requestKind,
    this.resubmit = false,
    this.requestStateId,
  }) : super(key: key);

  const SubmitRequestPage.resubmit({
    Key? key,
    this.title,
    this.requestKind,
    this.resubmit = true,
    this.requestStateId,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => SubmitRequestPageState();
}

class SubmitRequestPageState extends State<SubmitRequestPage> {
  final _refreshableKey = GlobalKey<RefreshableState>();

  Employee? employee;
  Employee? _selectedEmp;
  bool _switchValue = false;
  BaseResponse<String>? attachResubmitRequestResponse;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    employee = context.watch<EmployeeProvider>().employee;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: CustomBackButton(),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        physics: ClampingScrollPhysics(),
        children: [
          _header(),
          SizedBox(height: 8),
          if (widget.resubmit) ...[
            CustomFutureBuilder<List>(
              initFuture: () async {
                var drewFieldsResult = await ApiRepo().getRequestDrewFieldsResubmit(
                  _selectedEmp?.id ?? employee?.id,
                  widget.requestKind,
                  widget.requestStateId,
                );

                drewFieldsResult.result!.requestStateAttributes ??= [];

                var fields = drewFieldsResult.result!.requestStateAttributes!;
                final attachmentFields = fields.where(
                  (element) {
                    return element.requestDefinitionStateAttribute?.code == "ATTACHMENT" &&
                        element.fileDescriptor != null &&
                        element.fileDescriptor!.id!.isNotEmpty;
                  },
                );
                for (final attachmentField in attachmentFields) {
                  final fileResponse = await ApiRepo().getFile(attachmentField.fileDescriptor!.id);
                  attachmentField.fileDescriptor!.content = fileResponse.result;
                  attachmentField.attachment = attachmentField.fileDescriptor;
                }

                return [
                  drewFieldsResult,
                  await ApiRepo().getLeaveBalance(_selectedEmp?.id ?? employee!.id),
                ];
              },
              onSuccess: (context, snapshot) {
                List<RequestStateAttributesDTO>? fields = snapshot.data![0]?.result?.requestStateAttributes;
                if (fields == null) fields = [];
                final List<LeaveBalanceResponseDTO>? leaveBalancesValues = snapshot.data![1].result;
                return SubmitRequestForm.resubmit(
                  fields: fields,
                  requestStateId: widget.requestStateId,
                  requestKind: widget.requestKind,
                  title: widget.title,
                  employee: _selectedEmp ?? employee,
                  leaveBalancesValues: leaveBalancesValues,
                );
              },
            ),
          ] else ...[
            ApplyForOthersWidget(
              employee: employee,
              kindDisplayName: widget.title,
              requestKind: widget.requestKind,
              selectEmp: _selectedEmp,
              onChanged: _switchValue
                  ? (emp) => setState(() {
                        _selectedEmp = emp;
                        _refreshableKey.currentState!.refresh();
                      })
                  : null,
              switchValue: _switchValue,
              onSwitchChanged: (value) => setState(() {
                _switchValue = value;
                if (!value) {
                  _selectedEmp = null;
                  _refreshableKey.currentState!.refresh();
                }
              }),
            ),
            SizedBox(height: 8),
            Refreshable(
              key: _refreshableKey,
              child: CustomFutureBuilder<List>(
                initFuture: () async {
                  return [
                    await ApiRepo().getRequestDrewFields(_selectedEmp?.id ?? employee?.id, widget.requestKind),
                    await ApiRepo().getLeaveBalance(_selectedEmp?.id ?? employee!.id),
                  ];
                },
                onSuccess: (context, snapshot) {
                  List<RequestStateAttributesDTO>? fields = snapshot.data![0]?.result?.requestStateAttributes;
                  final String? requestStateId = snapshot.data![0]?.result?.requestStateId;
                  if (fields == null) fields = [];
                  final List<LeaveBalanceResponseDTO>? leaveBalancesValues = snapshot.data![1].result;
                  return SubmitRequestForm(
                    fields: fields,
                    requestStateId: requestStateId,
                    requestKind: widget.requestKind,
                    title: widget.title,
                    employee: _selectedEmp ?? employee,
                    leaveBalancesValues: leaveBalancesValues,
                  );
                },
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _header() {
    return TitleStacked(widget.title, Theme.of(context).primaryColor);
  }
}
