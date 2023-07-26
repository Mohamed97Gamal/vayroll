import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/announcement/image.dart';

part 'notificationModel.g.dart';

@JsonSerializable()
class NotificationModel {
  String? id;
  String? title;
  String? data;
  Image? image;
  String? body;
  bool? isRead;
  String? imageUrl;

  NotificationModel({
    this.id,
    this.title,
    this.data,
    this.image,
    this.isRead,
    this.body,
    this.imageUrl,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}
