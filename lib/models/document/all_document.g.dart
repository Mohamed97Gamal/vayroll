// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllDocument _$AllDocumentFromJson(Map<String, dynamic> json) => AllDocument(
      department: json['department'] as String?,
      documents: (json['documents'] as List<dynamic>?)
          ?.map((e) => Document.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AllDocumentToJson(AllDocument instance) =>
    <String, dynamic>{
      'department': instance.department,
      'documents': instance.documents,
    };
