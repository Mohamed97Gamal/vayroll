import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/widgets/widgets.dart';

class SummaryRequestPage extends StatefulWidget {
  final List<RequestStateAttributesDTO>? allFields;
  final String? title;
  final String? requestKind;
  final Employee? employee;
  final String? requestStateId;
  final bool resubmit;

  const SummaryRequestPage({
    Key? key,
    this.title,
    this.requestKind,
    this.allFields,
    this.employee,
    this.requestStateId,
    this.resubmit = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => SummaryRequestPageState();
}

class SummaryRequestPageState extends State<SummaryRequestPage> {
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
          CustomFutureBuilder<SummaryRequestsResponse>(
            initFuture: () async {
              var summaryResponse = await ApiRepo().validateRequest(
                widget.employee?.id,
                widget.requestKind,
                widget.allFields,
              );

              if (!summaryResponse.status!) {
                return summaryResponse;
              }

              summaryResponse.result!.attributes!.requestStateAttributes ??= [];
              var codes = summaryResponse.result!.attributes!.requestStateAttributes!
                  .map((e) => e.requestDefinitionStateAttribute!.code);
              var notExistingFields =
                  widget.allFields!.where((element) => !codes.contains(element.requestDefinitionStateAttribute!.code));
              summaryResponse.result!.attributes!.requestStateAttributes!.addAll(notExistingFields);

              return summaryResponse;
            },
            onSuccess: (context, snapshot) {
              if (snapshot.data?.message != null) {
                if (snapshot.data?.errors != null && (snapshot.data?.errors?.isNotEmpty ?? false)) {
                  return Center(
                    child: Text(snapshot.data!.message! + "\n" + snapshot.data!.errors!.join("\n")),
                  );
                }
                return Center(
                  child: Text(snapshot.data!.message!),
                );
              }

              List<RequestStateAttributesDTO>? fields = snapshot.data?.result?.attributes?.requestStateAttributes;
              return ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: [
                  ListView.builder(
                    itemCount: snapshot.data?.result?.tree?.details?.length,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return TreeStatesCardWidget(activeState: snapshot.data?.result?.tree?.details![index]);
                    },
                  ),
                  widget.resubmit
                      ? SubmitRequestForm.summaryResubmit(
                          fields: fields,
                          employee: widget.employee,
                          requestKind: widget.requestKind,
                          requestStateId: widget.requestStateId,
                          resubmit: widget.resubmit,
                          leaveBalanceBrief: snapshot.data?.result?.leaveBalanceBrief,
                        )
                      : SubmitRequestForm.summary(
                          fields: fields,
                          employee: widget.employee,
                          requestKind: widget.requestKind,
                          requestStateId: widget.requestStateId,
                          resubmit: widget.resubmit,
                          leaveBalanceBrief: snapshot.data?.result?.leaveBalanceBrief,
                        ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return TitleStacked(widget.title, Theme.of(context).primaryColor);
  }
}
