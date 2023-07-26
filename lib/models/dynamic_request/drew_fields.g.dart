// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drew_fields.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DrewFieldsRequestsResponse _$DrewFieldsRequestsResponseFromJson(
        Map<String, dynamic> json) =>
    DrewFieldsRequestsResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      code: json['code'] as int?,
      errors:
          (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList(),
      result: json['result'] == null
          ? null
          : DrewFieldsRequestsResponseDTO.fromJson(
              json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DrewFieldsRequestsResponseToJson(
        DrewFieldsRequestsResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'code': instance.code,
      'errors': instance.errors,
      'result': instance.result?.toJson(),
    };

DrewFieldsRequestsResponseDTO _$DrewFieldsRequestsResponseDTOFromJson(
        Map<String, dynamic> json) =>
    DrewFieldsRequestsResponseDTO()
      ..requestStateId = json['requestStateId'] as String?
      ..requestStateAttributes =
          (json['requestStateAttributes'] as List<dynamic>?)
              ?.map((e) =>
                  RequestStateAttributesDTO.fromJson(e as Map<String, dynamic>))
              .toList();

Map<String, dynamic> _$DrewFieldsRequestsResponseDTOToJson(
        DrewFieldsRequestsResponseDTO instance) =>
    <String, dynamic>{
      'requestStateId': instance.requestStateId,
      'requestStateAttributes': instance.requestStateAttributes,
    };

RequestStateAttributesDTO _$RequestStateAttributesDTOFromJson(
        Map<String, dynamic> json) =>
    RequestStateAttributesDTO()
      ..requestDefinitionStateAttribute =
          json['requestDefinitionStateAttribute'] == null
              ? null
              : RequestDefinitionStateAttributeDTO.fromJson(
                  json['requestDefinitionStateAttribute']
                      as Map<String, dynamic>)
      ..stringValue = json['stringValue'] as String?
      ..integerValue = json['integerValue'] as int?
      ..bigDecimalValue = (json['bigDecimalValue'] as num?)?.toDouble()
      ..booleanValue = json['booleanValue'] as bool?
      ..dateValue = json['dateValue'] as String?
      ..fileDescriptor = json['fileDescriptor'] == null
          ? null
          : Attachment.fromJson(json['fileDescriptor'] as Map<String, dynamic>)
      ..attachment = json['attachment'] == null
          ? null
          : Attachment.fromJson(json['attachment'] as Map<String, dynamic>)
      ..uuidValue = json['uuidValue'] as String?
      ..className = json['className'] as String?
      ..startDate = json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String)
      ..endDate = json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String);

Map<String, dynamic> _$RequestStateAttributesDTOToJson(
        RequestStateAttributesDTO instance) =>
    <String, dynamic>{
      'requestDefinitionStateAttribute':
          instance.requestDefinitionStateAttribute,
      'stringValue': instance.stringValue,
      'integerValue': instance.integerValue,
      'bigDecimalValue': instance.bigDecimalValue,
      'booleanValue': instance.booleanValue,
      'dateValue': instance.dateValue,
      'fileDescriptor': instance.fileDescriptor,
      'attachment': instance.attachment,
      'uuidValue': instance.uuidValue,
      'className': instance.className,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
    };

RequestDefinitionStateAttributeDTO _$RequestDefinitionStateAttributeDTOFromJson(
        Map<String, dynamic> json) =>
    RequestDefinitionStateAttributeDTO()
      ..code = json['code'] as String?
      ..type = json['type'] as String?
      ..defaultName = json['defaultName'] as String?
      ..defaultOrder = json['defaultOrder'] as int?
      ..isPreCalculated = json['isPreCalculated'] as bool?
      ..isPostCalculated = json['isPostCalculated'] as bool?
      ..isHidden = json['isHidden'] as bool?
      ..category = json['category'] as String?
      ..categoryOrder = json['categoryOrder'] as int?
      ..isRequired = json['isRequired'] as bool?
      ..requiredMessage = json['requiredMessage'] as String?
      ..defaultRegex = json['defaultRegex'] as String?
      ..defaultRegexErrorMessage = json['defaultRegexErrorMessage'] as String?
      ..listValues = (json['listValues'] as List<dynamic>?)
          ?.map((e) => LookupValueDTO.fromJson(e as Map<String, dynamic>))
          .toList()
      ..lookupValues = (json['lookupValues'] as List<dynamic>?)
          ?.map((e) => LookupValueDTO.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$RequestDefinitionStateAttributeDTOToJson(
        RequestDefinitionStateAttributeDTO instance) =>
    <String, dynamic>{
      'code': instance.code,
      'type': instance.type,
      'defaultName': instance.defaultName,
      'defaultOrder': instance.defaultOrder,
      'isPreCalculated': instance.isPreCalculated,
      'isPostCalculated': instance.isPostCalculated,
      'isHidden': instance.isHidden,
      'category': instance.category,
      'categoryOrder': instance.categoryOrder,
      'isRequired': instance.isRequired,
      'requiredMessage': instance.requiredMessage,
      'defaultRegex': instance.defaultRegex,
      'defaultRegexErrorMessage': instance.defaultRegexErrorMessage,
      'listValues': instance.listValues,
      'lookupValues': instance.lookupValues,
    };

LookupValueDTO _$LookupValueDTOFromJson(Map<String, dynamic> json) =>
    LookupValueDTO()
      ..name = json['name'] as String?
      ..id = json['id'] as String?
      ..code = json['code'] as String?;

Map<String, dynamic> _$LookupValueDTOToJson(LookupValueDTO instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'code': instance.code,
    };
