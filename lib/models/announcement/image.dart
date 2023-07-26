import 'package:json_annotation/json_annotation.dart';

part 'image.g.dart';

@JsonSerializable()
class Image {
  String? id;
  String? attachmentId;
  String? extension;
  List<int>? content;

  Image({
    this.id,
    this.attachmentId,
    this.extension,
    this.content,
  });

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);

  Map<String, dynamic> toJson() => _$ImageToJson(this);
}
