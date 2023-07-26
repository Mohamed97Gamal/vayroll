import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/assets/images.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/providers/employee_provider.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class ProfileRequestCard extends StatelessWidget {
  final MyRequestsResponseDTO? profileRequestInfo;
  final GlobalKey<RefreshableState>? refreshableKey;
  final bool removeSubString;

  const ProfileRequestCard({
    Key? key,
    this.profileRequestInfo,
    this.refreshableKey,
    this.removeSubString = false,
  }) : super(key: key);

  Future _profileRequestAction(BuildContext context, String action) async {
    final profileRequestActionResponse = (await showFutureProgressDialog<BaseResponse<String>>(
      context: context,
      initFuture: () => ApiRepo().requestAction(profileRequestInfo?.requestStateId, action),
    ))!;

    if (profileRequestActionResponse.status!) {
      await showCustomModalBottomSheet(
        context: context,
        isDismissible: false,
        desc: profileRequestActionResponse.message ?? " ",
      );
      refreshableKey!.currentState!.refresh();
    } else {
      await showCustomModalBottomSheet(
        context: context,
        isDismissible: false,
        desc: profileRequestActionResponse.message ?? " ",
      );
      refreshableKey!.currentState!.refresh();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    Employee? employee = context.read<EmployeeProvider>().employee;
    return profileRequestCard(context, employee);
  }

  Widget profileRequestCard(BuildContext context, Employee? employee) {
    return InkWell(
      onTap: () => Navigation.navToRequestDetails(context, profileRequestInfo),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 7,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      border: new Border.all(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: (employee?.photoBase64 != null
                          ? MemoryImage(employee!.photoBytes!)
                          : AssetImage(VPayImages.avatar)) as ImageProvider<Object>?,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            removeSubString
                                ? profileRequestInfo?.transactionClassDisplayName ?? ""
                                : profileRequestInfo?.transactionClassDisplayName?.substring(9) ?? "",
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.subtitle1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          "(${profileRequestInfo?.requestNumber})",
                          style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                height: 1,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.normal,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          dateFormat.format(profileRequestInfo!.submissionDate!) ?? "",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(fontSize: 14, color: DefaultThemeColors.nepal),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                profileRequestInfo?.status ?? "",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(color: statusColor(profileRequestInfo?.status, context)),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 1,
              child: RequestActions(
                status: profileRequestInfo?.status,
                onSelected: (value) async {
                  if (value == "Revoke")
                    _profileRequestAction(context, "REVOKE");
                  else if (value == "Delete")
                    showConfirmationBottomSheet(
                      context: context,
                      desc: context.appStrings!.areYouSureYouWantToDeleteThisRequest,
                      isDismissible: false,
                      onConfirm: () async {
                        Navigator.of(context).pop();
                        await _profileRequestAction(context, "DELETE");
                      },
                    );
                  else if (value == "Resubmit") {
                    final requestDetailsResponse = (await showFutureProgressDialog<BaseResponse<RequestDetailsResponse>>(
                      context: context,
                      initFuture: () => ApiRepo().getRequestDetials(profileRequestInfo),
                    ))!;

                    if (!requestDetailsResponse.status!) {
                      await showCustomModalBottomSheet(
                        context: context,
                        desc: requestDetailsResponse.message ?? " ",
                      );
                    }

                    switch (profileRequestInfo?.transactionClassName) {
                      case RequestProfileType.employeeEducation:
                        EducationResponseDTO? educationInfo = requestDetailsResponse.result?.newValue;
                        return showEducationRequestBottomSheet(
                          context: context,
                          employee: employee,
                          educationInfo: educationInfo,
                          resubmit: true,
                          profileRequestInfo: profileRequestInfo,
                          refreshableKey: refreshableKey,
                        );
                      case RequestProfileType.employeeCertificate:
                        CertificateResponseDTO? certificateInfo = requestDetailsResponse.result?.newValue;
                        return showCertificateRequestBottomSheet(
                          context: context,
                          employee: employee,
                          certificateInfo: certificateInfo,
                          resubmit: true,
                          profileRequestInfo: profileRequestInfo,
                          refreshableKey: refreshableKey,
                        );
                      case RequestProfileType.employeeEmergencyContact:
                        EmergencyContact? emergencyContactInfo = requestDetailsResponse.result?.newValue;
                        return showContactsRequestBottomSheet(
                          context: context,
                          employee: employee,
                          emergencyContacts: [emergencyContactInfo],
                          resubmit: true,
                          profileRequestInfo: profileRequestInfo,
                          refreshableKey: refreshableKey,
                        );
                      case RequestProfileType.employeeSkill:
                        SkillsResponseDTO? skillInfo = requestDetailsResponse.result?.newValue;
                        return showSkillRequestBottomSheet(
                          context: context,
                          employee: employee,
                          skillInfo: skillInfo,
                          resubmit: true,
                          profileRequestInfo: profileRequestInfo,
                          refreshableKey: refreshableKey,
                        );
                      case RequestProfileType.employeeWorkExperience:
                        ExperiencesResponseDTO? experienceInfo = requestDetailsResponse.result?.newValue;
                        return showWorkExpernceRequestBottomSheet(
                          context: context,
                          employee: employee,
                          experienceInfo: experienceInfo,
                          resubmit: true,
                          profileRequestInfo: profileRequestInfo,
                          refreshableKey: refreshableKey,
                        );
                      case RequestProfileType.personalInformation:
                        Employee? employeeInfo = requestDetailsResponse.result?.newValue;
                        return showPersonalInfoRequestBottomSheet(
                          context: context,
                          employee: employeeInfo,
                          resubmit: true,
                          profileRequestInfo: profileRequestInfo,
                          refreshableKey: refreshableKey,
                        );
                    }

                    if (profileRequestInfo?.requestKind == RequestKind.ducoment) {
                      Navigation.navToReSubmitRequest(context, RequestKind.ducoment,
                          context.appStrings!.requestForDocument, profileRequestInfo?.requestStateId);
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
