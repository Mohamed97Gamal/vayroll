import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';

part 'drew_fields.g.dart';

@JsonSerializable(explicitToJson: true)
class DrewFieldsRequestsResponse {
  final bool? status;
  final String? message;
  final int? code;
  final List<String>? errors;
  final DrewFieldsRequestsResponseDTO? result;

  DrewFieldsRequestsResponse({this.status, this.message, this.code, this.errors, this.result});

  factory DrewFieldsRequestsResponse.fromJson(Map<String, dynamic> json) => _$DrewFieldsRequestsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DrewFieldsRequestsResponseToJson(this);
}

@JsonSerializable()
class DrewFieldsRequestsResponseDTO {
  String? requestStateId;
  List<RequestStateAttributesDTO>? requestStateAttributes;

  factory DrewFieldsRequestsResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$DrewFieldsRequestsResponseDTOFromJson(json);

  Map<String, dynamic> toJson() => _$DrewFieldsRequestsResponseDTOToJson(this);

  DrewFieldsRequestsResponseDTO();
}

@JsonSerializable()
class RequestStateAttributesDTO {
  RequestDefinitionStateAttributeDTO? requestDefinitionStateAttribute;
  String? stringValue;
  int? integerValue;
  double? bigDecimalValue;
  bool? booleanValue;
  String? dateValue;
  //returned from backend
  Attachment? fileDescriptor;
  //post to backend
  Attachment? attachment;
  String? uuidValue;
  String? className;
  DateTime? startDate;
  DateTime? endDate;

  factory RequestStateAttributesDTO.fromJson(Map<String, dynamic> json) => _$RequestStateAttributesDTOFromJson(json);

  Map<String, dynamic> toJson() => _$RequestStateAttributesDTOToJson(this);

  RequestStateAttributesDTO();
}

@JsonSerializable()
class RequestDefinitionStateAttributeDTO {
  String? code;
  String? type;
  String? defaultName;
  int? defaultOrder;
  bool? isPreCalculated;
  bool? isPostCalculated;
  bool? isHidden;
  String? category;
  int? categoryOrder;
  bool? isRequired;
  String? requiredMessage;
  String? defaultRegex;
  String? defaultRegexErrorMessage;
  List<LookupValueDTO>? listValues;
  List<LookupValueDTO>? lookupValues;

  factory RequestDefinitionStateAttributeDTO.fromJson(Map<String, dynamic> json) =>
      _$RequestDefinitionStateAttributeDTOFromJson(json);

  Map<String, dynamic> toJson() => _$RequestDefinitionStateAttributeDTOToJson(this);

  RequestDefinitionStateAttributeDTO();
}

@JsonSerializable()
class LookupValueDTO {
  String? name;
  String? id;
  String? code;

  factory LookupValueDTO.fromJson(Map<String, dynamic> json) => _$LookupValueDTOFromJson(json);

  Map<String, dynamic> toJson() => _$LookupValueDTOToJson(this);

  LookupValueDTO();
}
