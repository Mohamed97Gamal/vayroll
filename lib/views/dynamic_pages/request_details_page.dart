import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/back_button.dart';
import 'package:vayroll/widgets/widgets.dart';

class RequestDetailsPage extends StatefulWidget {
  final MyRequestsResponseDTO? requestInfo;

  const RequestDetailsPage({Key? key, this.requestInfo}) : super(key: key);
  @override
  State<StatefulWidget> createState() => RequestDetailsPageState();
}

class RequestDetailsPageState extends State<RequestDetailsPage> {
  String? title;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    switch (widget.requestInfo!.requestKind) {
      case RequestKind.leave:
        title = context.appStrings!.leaveDetails;
        break;
      case RequestKind.attendanceAppealRequest:
        title = context.appStrings!.attendanceDetails;
        break;
      case RequestKind.profileUpdate:
        title = context.appStrings!.profileDetails;
        break;
      case RequestKind.expenseClaim:
        title = context.appStrings!.expenseDetails;
        break;
      case RequestKind.ducoment:
        title = context.appStrings!.documentDetails;
        break;
      default:
        title = context.appStrings!.requestDetails;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DefaultThemeColors.whiteSmoke2,
      appBar: AppBar(
        leading: CustomBackButton(),
        backgroundColor: DefaultThemeColors.whiteSmoke2,
        elevation: 0,
      ),
      body: CustomFutureBuilder<BaseResponse<RequestDetailsResponse>>(
        initFuture: () => ApiRepo().getRequestDetials(widget.requestInfo),
        onError: (context, snapshot) {
          if (snapshot.data!.code == 404)
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    VPayIcons.notFound,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 16),
                  Text("The request does not exist, it may have been deleted"),
                ],
              ),
            );
          return null;
        },
        onSuccess: (context, snapshot) {
          RequestDetailsResponse requestDetails = snapshot.data!.result!;

          return ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: [
              _header(),
              RequestDetailsBody(
                requestDetails: requestDetails,
                requestInfo: requestDetails.requestInfo,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _header() {
    var _currentEmployee = context.read<EmployeeProvider>().employee!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleStacked(title, Theme.of(context).primaryColor),
          SizedBox(height: 8),
          (widget.requestInfo?.subjectId == _currentEmployee.id)
              ? EmployeeCardWidget(employeeInfo: _currentEmployee)
              : CustomFutureBuilder<BaseResponse<Employee>>(
                  initFuture: () => ApiRepo()
                      .getEmployee(employeeId: widget.requestInfo?.subjectId),
                  onSuccess: (context, employeeSnapshot) {
                    var otherEmployee = employeeSnapshot.data!.result;
                    return (otherEmployee?.photo?.id == null)
                        ? EmployeeCardWidget(employeeInfo: otherEmployee)
                        : AvatarFutureBuilder<BaseResponse<String>>(
                            initFuture: () =>
                                ApiRepo().getFile(otherEmployee!.photo!.id),
                            onSuccess: (context, photoSnapshot) {
                              otherEmployee = otherEmployee!.copyWith(
                                  photoBase64: photoSnapshot.data!.result);
                              return EmployeeCardWidget(
                                employeeInfo: otherEmployee,
                              );
                            },
                          );
                  },
                ),
        ],
      ),
    );
  }
}
