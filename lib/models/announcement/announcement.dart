import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/announcement/image.dart';

part 'announcement.g.dart';

@JsonSerializable()
class Announcement {
  String? id;
  String? title;
  String? text;
  Image? attachment;
  String? body;
  bool? isRead;

  Announcement({
    this.id,
    this.title,
    this.text,
    this.attachment,
    this.isRead,
    this.body,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) => _$AnnouncementFromJson(json);

  Map<String, dynamic> toJson() => _$AnnouncementToJson(this);
}
