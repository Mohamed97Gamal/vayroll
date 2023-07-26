import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class DocumentsCardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext? context) {
    return CustomFutureBuilder<BaseResponse<AllDocumentsResponsePage>>(
      initFuture: () => ApiRepo().getCompanydocuments(
        employeesGroupId: context?.read<EmployeeProvider>().employee?.employeesGroup?.id,
        pageSize: 6,
        pageIndex: 0,
      ),
      onSuccess: (context, snapshot) {
        List<Document>? documents = snapshot.data!.result!.records;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: 200),
                    child: Text(
                      "Documents",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigation.navToDucoments(context),
                    child: Text(
                      context.appStrings!.viewAll,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: Theme.of(context).colorScheme.secondary),
                    ),
                  )
                ],
              ),
              SizedBox(height: 12),
              documents == null || documents.isEmpty
                  ? Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(11)),
                        color: Colors.white,
                      ),
                      child: Text(
                        context.appStrings!.thereIsNoDocumentsForYouNow,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      height: 90,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: documents.length > 6 ? 6 : documents.length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return DocumentCradWidget(document: documents[index]);
                        },
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
