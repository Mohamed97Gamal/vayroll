// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_documents_response_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllDocumentsResponsePage _$AllDocumentsResponsePageFromJson(
        Map<String, dynamic> json) =>
    AllDocumentsResponsePage(
      records: (json['records'] as List<dynamic>?)
          ?.map((e) => Document.fromJson(e as Map<String, dynamic>))
          .toList(),
      recordsTotalCount: json['recordsTotalCount'] as int?,
      pagesTotalCount: json['pagesTotalCount'] as int?,
      pageIndex: json['pageIndex'] as int?,
      pageSize: json['pageSize'] as int?,
      hasNext: json['hasNext'] as bool?,
      hasPrevious: json['hasPrevious'] as bool?,
    );

Map<String, dynamic> _$AllDocumentsResponsePageToJson(
        AllDocumentsResponsePage instance) =>
    <String, dynamic>{
      'records': instance.records,
      'recordsTotalCount': instance.recordsTotalCount,
      'pagesTotalCount': instance.pagesTotalCount,
      'pageIndex': instance.pageIndex,
      'pageSize': instance.pageSize,
      'hasNext': instance.hasNext,
      'hasPrevious': instance.hasPrevious,
    };
