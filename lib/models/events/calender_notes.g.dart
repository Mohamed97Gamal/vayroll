// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calender_notes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalenderNotes _$CalenderNotesFromJson(Map<String, dynamic> json) =>
    CalenderNotes()
      ..id = json['id'] as String?
      ..noteDate = json['noteDate'] as String?
      ..title = json['title'] as String?
      ..description = json['description'] as String?;

Map<String, dynamic> _$CalenderNotesToJson(CalenderNotes instance) =>
    <String, dynamic>{
      'id': instance.id,
      'noteDate': instance.noteDate,
      'title': instance.title,
      'description': instance.description,
    };
