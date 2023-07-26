// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_requests_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyRequestsResponse _$MyRequestsResponseFromJson(Map<String, dynamic> json) =>
    MyRequestsResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      code: json['code'] as int?,
      errors:
          (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList(),
      result: (json['result'] as List<dynamic>?)
          ?.map(
              (e) => MyRequestsResponseDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MyRequestsResponseToJson(MyRequestsResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'code': instance.code,
      'errors': instance.errors,
      'result': instance.result?.map((e) => e.toJson()).toList(),
    };

AllRequestsResponse _$AllRequestsResponseFromJson(Map<String, dynamic> json) =>
    AllRequestsResponse(
      records: (json['records'] as List<dynamic>?)
          ?.map(
              (e) => MyRequestsResponseDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      recordsTotalCount: json['recordsTotalCount'] as int?,
      pagesTotalCount: json['pagesTotalCount'] as int?,
      pageIndex: json['pageIndex'] as int?,
      pageSize: json['pageSize'] as int?,
      hasNext: json['hasNext'] as bool?,
      hasPrevious: json['hasPrevious'] as bool?,
    );

Map<String, dynamic> _$AllRequestsResponseToJson(
        AllRequestsResponse instance) =>
    <String, dynamic>{
      'records': instance.records,
      'recordsTotalCount': instance.recordsTotalCount,
      'pagesTotalCount': instance.pagesTotalCount,
      'pageIndex': instance.pageIndex,
      'pageSize': instance.pageSize,
      'hasNext': instance.hasNext,
      'hasPrevious': instance.hasPrevious,
    };

MyRequestsResponseDTO _$MyRequestsResponseDTOFromJson(
        Map<String, dynamic> json) =>
    MyRequestsResponseDTO(
      id: json['id'] as String?,
      requestNumber: json['requestNumber'] as String?,
      requestKind: json['requestKind'] as String?,
      subjectId: json['subjectId'] as String?,
      subjectDisplayName: json['subjectDisplayName'] as String?,
      subjectCode: json['subjectCode'] as String?,
      subjectName: json['subjectName'] as String?,
      submissionDate: json['submissionDate'] == null
          ? null
          : DateTime.parse(json['submissionDate'] as String),
      status: json['status'] as String?,
      requestStatusDescription: json['requestStatusDescription'] as String?,
      transactionClassName: json['transactionClassName'] as String?,
      transactionClassDisplayName:
          json['transactionClassDisplayName'] as String?,
      requestId: json['requestId'] as String?,
      requestStateId: json['requestStateId'] as String?,
      transactionUUID: json['transactionUUID'] as String?,
      isActiveRequest: json['isActiveRequest'] as bool?,
      isAppealed: json['isAppealed'] as bool?,
      attributes: (json['attributes'] as List<dynamic>?)
          ?.map(
              (e) => AttributesResponseDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      requestStepId: json['requestStepId'] as String?,
    );

Map<String, dynamic> _$MyRequestsResponseDTOToJson(
        MyRequestsResponseDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requestNumber': instance.requestNumber,
      'requestKind': instance.requestKind,
      'subjectId': instance.subjectId,
      'subjectDisplayName': instance.subjectDisplayName,
      'subjectCode': instance.subjectCode,
      'subjectName': instance.subjectName,
      'submissionDate': instance.submissionDate?.toIso8601String(),
      'status': instance.status,
      'requestStatusDescription': instance.requestStatusDescription,
      'transactionClassName': instance.transactionClassName,
      'transactionClassDisplayName': instance.transactionClassDisplayName,
      'requestId': instance.requestId,
      'requestStateId': instance.requestStateId,
      'transactionUUID': instance.transactionUUID,
      'isActiveRequest': instance.isActiveRequest,
      'isAppealed': instance.isAppealed,
      'attributes': instance.attributes,
      'requestStepId': instance.requestStepId,
    };
