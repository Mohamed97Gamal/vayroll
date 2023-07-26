import 'package:json_annotation/json_annotation.dart';

part 'base_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class BaseResponse<T> {
  bool? status;
  String? message;
  int? code;
  List<String>? errors;
  T? result;

  BaseResponse({this.status, this.message, this.code, this.errors, this.result});

  factory BaseResponse.fromMap(Map<String, dynamic> m) {
    return BaseResponse(
        status: m['status'] as bool?,
        message: m['message'] as String?,
        code: m['code'] as int?,
        errors: (m['errors'] as List?)?.map((e) => e as String).toList());
  }

  Map<String, dynamic> toMap() =>
      <String, dynamic>{'status': this.status, 'message': this.message, 'code': this.code, 'errors': this.errors};

  factory BaseResponse.fromJson(Map<String, dynamic> json, Function fromJsonT) =>
      _$BaseResponseFromJson(json, fromJsonT as T Function(Object?));

  Map<String, dynamic> toJson({
    required Function toJsonT,
  }) =>
      _$BaseResponseToJson(this, toJsonT as Object Function(dynamic));
}
