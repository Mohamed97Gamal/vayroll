import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intL;
import 'package:vayroll/models/models.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class DetailsCardWidget extends StatefulWidget {
  final RequestDetailsResponse? requestDetails;
  final MyRequestsResponseDTO? requestInfo;
  final String? title;

  const DetailsCardWidget({
    Key? key,
    this.requestDetails,
    this.title,
    this.requestInfo,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => DetailsCardWidgetState();
}

class DetailsCardWidgetState extends State<DetailsCardWidget> {
  List<AttributesResponseDTO> attributes = [];
  Attachment? certificateFile;
  List<String> listOfEmpCode = ["EMPLOYEE_NAME", "EMPLOYEE_NUMBER"];

  void switchCasesData(dynamic value) {
    switch (widget.requestInfo?.transactionClassName) {
      case RequestProfileType.employeeEducation:
        EducationResponseDTO? educationInfo = value;
        attributes = [];
        attributes.addAll([
          AttributesResponseDTO(displayName: "Request Action", value: educationInfo?.action),
          AttributesResponseDTO(displayName: "College", value: educationInfo?.college),
          AttributesResponseDTO(displayName: "Degree", value: educationInfo?.degree),
          AttributesResponseDTO(displayName: "Degree", value: educationInfo?.grade),
          AttributesResponseDTO(
              displayName: "From Date",
              value: intL.DateFormat('yyyy').format(dateFormat2.parse(educationInfo!.fromDate!))),
          AttributesResponseDTO(
              displayName: "To Date", value: intL.DateFormat('yyyy').format(dateFormat2.parse(educationInfo.toDate!))),
          if (educationInfo.certificateFile?.name?.isNotEmpty == true)
            AttributesResponseDTO(displayName: "Attachment", value: educationInfo.certificateFile?.name)
        ]);
        if (educationInfo.certificateFile?.name?.isNotEmpty == true) certificateFile = educationInfo.certificateFile;
        break;
      case RequestProfileType.employeeCertificate:
        CertificateResponseDTO? certificateInfo = value;
        attributes = [];
        attributes.addAll([
          AttributesResponseDTO(displayName: "Request Action", value: certificateInfo?.action),
          AttributesResponseDTO(displayName: "Name", value: certificateInfo?.name),
          AttributesResponseDTO(displayName: "Degree", value: certificateInfo?.issuingOrganization),
          AttributesResponseDTO(
              displayName: "Issue Date", value: dateFormat.format(dateFormat2.parse(certificateInfo!.issueDate!))),
          if (certificateInfo.expiryDate?.isNotEmpty == true)
            AttributesResponseDTO(
                displayName: "Expire Date", value: dateFormat.format(dateFormat2.parse(certificateInfo!.expiryDate!))),
          if (certificateInfo.attachment?.name?.isNotEmpty == true)
            AttributesResponseDTO(displayName: "Attachment", value: certificateInfo.attachment?.name)
        ]);
        if (certificateInfo.attachment?.name?.isNotEmpty == true) certificateFile = certificateInfo.attachment;
        break;
      case RequestProfileType.employeeSkill:
        SkillsResponseDTO? skillInfo = value;
        attributes = [];
        attributes.addAll([
          AttributesResponseDTO(displayName: "Request Action", value: skillInfo?.action),
          AttributesResponseDTO(displayName: "Name", value: skillInfo?.skillName),
          AttributesResponseDTO(displayName: "Proficiency", value: skillInfo?.proficiency),
        ]);
        break;
      case RequestProfileType.employeeWorkExperience:
        ExperiencesResponseDTO? experienceInfo = value;
        attributes = [];
        attributes.addAll([
          AttributesResponseDTO(displayName: "Request Action", value: experienceInfo?.action),
          AttributesResponseDTO(displayName: "Title", value: experienceInfo?.companyName),
          AttributesResponseDTO(displayName: "Company", value: experienceInfo?.companyName),
          if (experienceInfo?.description?.isNotEmpty == true)
            AttributesResponseDTO(displayName: "Responsibilities", value: experienceInfo?.description),
          AttributesResponseDTO(
              displayName: "From Date", value: dateFormat.format(dateFormat2.parse(experienceInfo!.fromDate!))),
          if (experienceInfo.toDate?.isNotEmpty == true)
            AttributesResponseDTO(
                displayName: "To Date", value: dateFormat.format(dateFormat2.parse(experienceInfo!.toDate!))),
          if (experienceInfo.experienceCertificate?.name?.isNotEmpty == true)
            AttributesResponseDTO(displayName: "Attachment", value: experienceInfo.experienceCertificate?.name)
        ]);
        if (experienceInfo.experienceCertificate?.name?.isNotEmpty == true)
          certificateFile = experienceInfo.experienceCertificate;
        break;
      case RequestProfileType.personalInformation:
        Employee? employeeInfo = value;
        attributes = [];
        attributes.addAll([
          AttributesResponseDTO(displayName: "Request Action", value: employeeInfo?.action ?? "Update"),
          AttributesResponseDTO(displayName: "Gender", value: employeeInfo?.gender),
          if (employeeInfo?.birthDate != null)
            AttributesResponseDTO(displayName: "Birthday", value: dateFormat.format(employeeInfo!.birthDate!)),
          if (employeeInfo?.religion?.isNotEmpty == true)
            AttributesResponseDTO(displayName: "Religion", value: employeeInfo?.religion),
          if (employeeInfo?.department?.name?.isNotEmpty == true)
            AttributesResponseDTO(displayName: "Department", value: employeeInfo?.department?.name),
          if (employeeInfo?.position?.name?.isNotEmpty == true)
            AttributesResponseDTO(displayName: "position", value: employeeInfo?.position?.name),
          if (employeeInfo?.hireDate?.toString().isNotEmpty == true)
            AttributesResponseDTO(displayName: "Hire Date", value: dateFormat.format(employeeInfo!.hireDate!)),
          if (employeeInfo?.currency?.code?.isNotEmpty == true)
            AttributesResponseDTO(displayName: "Currency", value: employeeInfo?.currency?.name),
          if (employeeInfo?.manager?.fullName?.isNotEmpty == true)
            AttributesResponseDTO(displayName: "Reporting Manager", value: employeeInfo?.manager?.fullName),
          if (employeeInfo?.contactNumber?.isNotEmpty == true)
            AttributesResponseDTO(displayName: "Contact Number", value: employeeInfo?.contactNumber),
          if (employeeInfo?.email?.isNotEmpty == true)
            AttributesResponseDTO(displayName: "Email", value: employeeInfo?.email),
          if (employeeInfo?.address?.isNotEmpty == true)
            AttributesResponseDTO(displayName: "Address", value: employeeInfo?.address),
        ]);
        if ((employeeInfo?.photo?.id?.isNotEmpty == true && employeeInfo?.parent?.photo == null) &&
            (employeeInfo?.hasPhotoChanged ?? false)) {
          attributes.add(AttributesResponseDTO(displayName: "Photo", value: employeeInfo?.photo?.name));
          certificateFile = employeeInfo?.photo;
        } else if (employeeInfo?.photo == null && employeeInfo?.parent?.photo?.id?.isNotEmpty == true) {
          attributes.add(AttributesResponseDTO(displayName: "Photo", value: "Deleted"));
        } else if ((employeeInfo?.photo == null && employeeInfo?.parent?.photo == null) &&
            (employeeInfo?.hasPhotoChanged ?? false)) {
          attributes.add(AttributesResponseDTO(displayName: "Photo", value: "Deleted"));
        } else if (employeeInfo?.hasPhotoChanged ?? false) {
          attributes.add(AttributesResponseDTO(displayName: "Photo", value: employeeInfo?.photo?.name));
          certificateFile = employeeInfo?.photo;
        }
        break;

      case RequestProfileType.employeeEmergencyContact:
        EmergencyContact? emergencyContactInfo = value;
        attributes = [];
        attributes.addAll([
          AttributesResponseDTO(displayName: "Request Action", value: emergencyContactInfo?.action),
          AttributesResponseDTO(displayName: "Name", value: emergencyContactInfo?.personName),
          AttributesResponseDTO(displayName: "Contact Number", value: emergencyContactInfo?.phoneNumber),
          AttributesResponseDTO(displayName: "Country", value: emergencyContactInfo?.country?.name),
          AttributesResponseDTO(displayName: "Address", value: emergencyContactInfo?.address),
        ]);
        break;

      default:
        return null;
    }
  }

  @override
  void initState() {
    super.initState();
    widget.requestDetails?.attributes?.forEach((element) {
      if (element.value?.toString().isNotEmpty == true && !listOfEmpCode.contains(element.code)) {
        attributes.add(element);
      }
    });

    if (widget.requestInfo != null && widget.title == "Request Details") {
      attributes = [];
      attributes.addAll([
        AttributesResponseDTO(displayName: "Request number", value: widget.requestInfo?.requestNumber),
        AttributesResponseDTO(displayName: "Request status", value: widget.requestInfo?.status),
        AttributesResponseDTO(displayName: "Request type", value: widget.requestInfo?.transactionClassDisplayName),
        AttributesResponseDTO(
            displayName: "Submitter name and id",
            value:
                "${widget.requestDetails?.submitter?.fullName} - ${widget.requestDetails?.submitter?.employeeNumber}"),
        if (widget.requestInfo?.subjectId != widget.requestDetails?.submitter?.id)
          AttributesResponseDTO(
              displayName: "Subject name and id", value: "${widget.requestInfo?.subjectDisplayName}"),
        AttributesResponseDTO(
            displayName: "Submission date", value: dateFormat.format(widget.requestInfo!.submissionDate!)),
        AttributesResponseDTO(displayName: "Status description", value: widget.requestInfo?.requestStatusDescription)
      ]);
    } else if (((widget.requestInfo != null && widget.requestDetails?.newValue != "") &&
        widget.title == "New Value")) {
      switchCasesData(widget.requestDetails?.newValue);
    }
    // else if (((widget?.requestInfo != null && widget?.requestDetails?.oldValue != "") &&
    //     widget?.title == "Old Value")) {
    //   switchCasesData(widget?.requestDetails?.oldValue);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return RequestDetialsCardWidget(
      title: widget.title ?? "",
      enable: attributes.isEmpty == true,
      childern: [
        Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListView.separated(
            separatorBuilder: (context, i) => ListDivider(),
            itemCount: attributes.length,
            padding: EdgeInsets.all(4),
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              Attachment? image;
              AttributesResponseDTO attributeInfo = attributes[index];
              if (attributeInfo.type == "DATE") {
                DateTime? date = DateTime.tryParse(attributeInfo.value);
                attributeInfo.value = date != null ? dateFormat.format(date) : attributeInfo.value;
              }

              if (attributeInfo.type == "TIME") {
                DateTime? date = DateTime.tryParse(attributeInfo.value);
                attributeInfo.value = date != null ? timeFormat.format(date) : attributeInfo.value;
              }

              if (attributeInfo.type == "FILE" || attributeInfo.type == "IMAGE") {
                image = Attachment.fromJson(attributeInfo.value);
              }

              if (attributeInfo.type == "DECIMAL" && attributeInfo.value != null) {
                var val = num.parse(attributeInfo.value);
                attributeInfo.value = val.isInt ? val.toStringAsFixed(0) : val.toStringAsFixed(2);
              }

              return LabelValueWidget(
                label: attributeInfo.displayName,
                value: attributeInfo.value?.toString(),
                attach: (attributeInfo.type == "FILE" || attributeInfo.type == "IMAGE") ||
                        (attributeInfo.displayName == "Photo" || attributeInfo.displayName == "Attachment")
                    ? (image ?? certificateFile)
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }
}
