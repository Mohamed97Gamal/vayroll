import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';

part 'request_details_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class RequestDetailsResponse<T> {
  RequestDetailsDTOResponse? request;
  Employee? submitter;
  List<AttributesResponseDTO>? attributes;
  MyRequestsResponseDTO? requestInfo;
  T? newValue;
  T? oldValue;
  String? error;

  factory RequestDetailsResponse.fromJson(Map<String, dynamic> json, Function fromJsonT) =>
      _$RequestDetailsResponseFromJson(json, fromJsonT as T Function(Object?));

  Map<String, dynamic> toJson({required Function toJsonT}) =>
      _$RequestDetailsResponseToJson(this, toJsonT as Object Function(dynamic));

  RequestDetailsResponse();
}

@JsonSerializable()
class RequestDetailsDTOResponse {
  String? name;
  List<RequestStateDTOResponse>? details;
  String? nodeType;

  factory RequestDetailsDTOResponse.fromJson(Map<String, dynamic> json) => _$RequestDetailsDTOResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RequestDetailsDTOResponseToJson(this);

  RequestDetailsDTOResponse();
}

@JsonSerializable()
class RequestStateDTOResponse {
  String? name;
  List<RequestStepDTOResponse>? details;
  StateDTOResponse? state;
  String? nodeType;

  factory RequestStateDTOResponse.fromJson(Map<String, dynamic> json) => _$RequestStateDTOResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RequestStateDTOResponseToJson(this);

  RequestStateDTOResponse();
}

@JsonSerializable()
class RequestStepDTOResponse {
  String? name;
  List<RequestNodeDTOResponse>? details;
  Map<String, dynamic>? step;
  String? nodeType;

  factory RequestStepDTOResponse.fromJson(Map<String, dynamic> json) => _$RequestStepDTOResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RequestStepDTOResponseToJson(this);

  RequestStepDTOResponse();
}

@JsonSerializable()
class RequestNodeDTOResponse {
  String? name;
  List<RequestApproverDTOResponse>? details;
  NodeDetailsDTOResponse? node;
  String? nodeType;

  factory RequestNodeDTOResponse.fromJson(Map<String, dynamic> json) => _$RequestNodeDTOResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RequestNodeDTOResponseToJson(this);

  RequestNodeDTOResponse();
}

@JsonSerializable()
class RequestApproverDTOResponse {
  String? name;
  List? details;
  Map<String, dynamic>? approver;
  String? nodeType;

  factory RequestApproverDTOResponse.fromJson(Map<String, dynamic> json) => _$RequestApproverDTOResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RequestApproverDTOResponseToJson(this);

  RequestApproverDTOResponse();
}

@JsonSerializable()
class StateDTOResponse {
  bool? isActiveState;
  bool? isLastState;

  factory StateDTOResponse.fromJson(Map<String, dynamic> json) => _$StateDTOResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StateDTOResponseToJson(this);

  StateDTOResponse();
}

@JsonSerializable()
class NodeDetailsDTOResponse {
  PositionDetailsDTOResponse? position;

  factory NodeDetailsDTOResponse.fromJson(Map<String, dynamic> json) => _$NodeDetailsDTOResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NodeDetailsDTOResponseToJson(this);

  NodeDetailsDTOResponse();
}

@JsonSerializable()
class PositionDetailsDTOResponse {
  String? name;

  factory PositionDetailsDTOResponse.fromJson(Map<String, dynamic> json) => _$PositionDetailsDTOResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PositionDetailsDTOResponseToJson(this);

  PositionDetailsDTOResponse();
}
