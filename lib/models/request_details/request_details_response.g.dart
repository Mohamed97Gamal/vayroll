// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestDetailsResponse<T> _$RequestDetailsResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    RequestDetailsResponse<T>()
      ..request = json['request'] == null
          ? null
          : RequestDetailsDTOResponse.fromJson(
              json['request'] as Map<String, dynamic>)
      ..submitter = json['submitter'] == null
          ? null
          : Employee.fromJson(json['submitter'] as Map<String, dynamic>)
      ..attributes = (json['attributes'] as List<dynamic>?)
          ?.map(
              (e) => AttributesResponseDTO.fromJson(e as Map<String, dynamic>))
          .toList()
      ..requestInfo = json['requestInfo'] == null
          ? null
          : MyRequestsResponseDTO.fromJson(
              json['requestInfo'] as Map<String, dynamic>)
      ..newValue = _$nullableGenericFromJson(json['newValue'], fromJsonT)
      ..oldValue = _$nullableGenericFromJson(json['oldValue'], fromJsonT)
      ..error = json['error'] as String?;

Map<String, dynamic> _$RequestDetailsResponseToJson<T>(
  RequestDetailsResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'request': instance.request,
      'submitter': instance.submitter,
      'attributes': instance.attributes,
      'requestInfo': instance.requestInfo,
      'newValue': _$nullableGenericToJson(instance.newValue, toJsonT),
      'oldValue': _$nullableGenericToJson(instance.oldValue, toJsonT),
      'error': instance.error,
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);

RequestDetailsDTOResponse _$RequestDetailsDTOResponseFromJson(
        Map<String, dynamic> json) =>
    RequestDetailsDTOResponse()
      ..name = json['name'] as String?
      ..details = (json['details'] as List<dynamic>?)
          ?.map((e) =>
              RequestStateDTOResponse.fromJson(e as Map<String, dynamic>))
          .toList()
      ..nodeType = json['nodeType'] as String?;

Map<String, dynamic> _$RequestDetailsDTOResponseToJson(
        RequestDetailsDTOResponse instance) =>
    <String, dynamic>{
      'name': instance.name,
      'details': instance.details,
      'nodeType': instance.nodeType,
    };

RequestStateDTOResponse _$RequestStateDTOResponseFromJson(
        Map<String, dynamic> json) =>
    RequestStateDTOResponse()
      ..name = json['name'] as String?
      ..details = (json['details'] as List<dynamic>?)
          ?.map(
              (e) => RequestStepDTOResponse.fromJson(e as Map<String, dynamic>))
          .toList()
      ..state = json['state'] == null
          ? null
          : StateDTOResponse.fromJson(json['state'] as Map<String, dynamic>)
      ..nodeType = json['nodeType'] as String?;

Map<String, dynamic> _$RequestStateDTOResponseToJson(
        RequestStateDTOResponse instance) =>
    <String, dynamic>{
      'name': instance.name,
      'details': instance.details,
      'state': instance.state,
      'nodeType': instance.nodeType,
    };

RequestStepDTOResponse _$RequestStepDTOResponseFromJson(
        Map<String, dynamic> json) =>
    RequestStepDTOResponse()
      ..name = json['name'] as String?
      ..details = (json['details'] as List<dynamic>?)
          ?.map(
              (e) => RequestNodeDTOResponse.fromJson(e as Map<String, dynamic>))
          .toList()
      ..step = json['step'] as Map<String, dynamic>?
      ..nodeType = json['nodeType'] as String?;

Map<String, dynamic> _$RequestStepDTOResponseToJson(
        RequestStepDTOResponse instance) =>
    <String, dynamic>{
      'name': instance.name,
      'details': instance.details,
      'step': instance.step,
      'nodeType': instance.nodeType,
    };

RequestNodeDTOResponse _$RequestNodeDTOResponseFromJson(
        Map<String, dynamic> json) =>
    RequestNodeDTOResponse()
      ..name = json['name'] as String?
      ..details = (json['details'] as List<dynamic>?)
          ?.map((e) =>
              RequestApproverDTOResponse.fromJson(e as Map<String, dynamic>))
          .toList()
      ..node = json['node'] == null
          ? null
          : NodeDetailsDTOResponse.fromJson(
              json['node'] as Map<String, dynamic>)
      ..nodeType = json['nodeType'] as String?;

Map<String, dynamic> _$RequestNodeDTOResponseToJson(
        RequestNodeDTOResponse instance) =>
    <String, dynamic>{
      'name': instance.name,
      'details': instance.details,
      'node': instance.node,
      'nodeType': instance.nodeType,
    };

RequestApproverDTOResponse _$RequestApproverDTOResponseFromJson(
        Map<String, dynamic> json) =>
    RequestApproverDTOResponse()
      ..name = json['name'] as String?
      ..details = json['details'] as List<dynamic>?
      ..approver = json['approver'] as Map<String, dynamic>?
      ..nodeType = json['nodeType'] as String?;

Map<String, dynamic> _$RequestApproverDTOResponseToJson(
        RequestApproverDTOResponse instance) =>
    <String, dynamic>{
      'name': instance.name,
      'details': instance.details,
      'approver': instance.approver,
      'nodeType': instance.nodeType,
    };

StateDTOResponse _$StateDTOResponseFromJson(Map<String, dynamic> json) =>
    StateDTOResponse()
      ..isActiveState = json['isActiveState'] as bool?
      ..isLastState = json['isLastState'] as bool?;

Map<String, dynamic> _$StateDTOResponseToJson(StateDTOResponse instance) =>
    <String, dynamic>{
      'isActiveState': instance.isActiveState,
      'isLastState': instance.isLastState,
    };

NodeDetailsDTOResponse _$NodeDetailsDTOResponseFromJson(
        Map<String, dynamic> json) =>
    NodeDetailsDTOResponse()
      ..position = json['position'] == null
          ? null
          : PositionDetailsDTOResponse.fromJson(
              json['position'] as Map<String, dynamic>);

Map<String, dynamic> _$NodeDetailsDTOResponseToJson(
        NodeDetailsDTOResponse instance) =>
    <String, dynamic>{
      'position': instance.position,
    };

PositionDetailsDTOResponse _$PositionDetailsDTOResponseFromJson(
        Map<String, dynamic> json) =>
    PositionDetailsDTOResponse()..name = json['name'] as String?;

Map<String, dynamic> _$PositionDetailsDTOResponseToJson(
        PositionDetailsDTOResponse instance) =>
    <String, dynamic>{
      'name': instance.name,
    };
