import 'dart:convert';
import 'dart:io';

class Attachment {
  String? id;
  String? name;
  String? extension;
  int? size;
  String? content;

  Attachment({
    this.id,
    this.name,
    this.extension,
    this.size,
    this.content,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id'] as String?,
      name: json['name'] as String?,
      extension: json['extension'] as String?,
      size: json['size'] as int?,
      content: json['content'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'extension': extension,
      'size': size,
      'content': content == null ? null : base64Encode(gzip.encode(base64Decode(content!))),
    };
  }
}
