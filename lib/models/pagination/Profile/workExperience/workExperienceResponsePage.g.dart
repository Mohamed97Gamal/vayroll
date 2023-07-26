// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workExperienceResponsePage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkExperienceResponsePage _$WorkExperienceResponsePageFromJson(
        Map<String, dynamic> json) =>
    WorkExperienceResponsePage(
      records: (json['records'] as List<dynamic>?)
          ?.map(
              (e) => ExperiencesResponseDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      recordsTotalCount: json['recordsTotalCount'] as int?,
      pagesTotalCount: json['pagesTotalCount'] as int?,
      pageIndex: json['pageIndex'] as int?,
      pageSize: json['pageSize'] as int?,
      hasNext: json['hasNext'] as bool?,
      hasPrevious: json['hasPrevious'] as bool?,
    );

Map<String, dynamic> _$WorkExperienceResponsePageToJson(
        WorkExperienceResponsePage instance) =>
    <String, dynamic>{
      'records': instance.records,
      'recordsTotalCount': instance.recordsTotalCount,
      'pagesTotalCount': instance.pagesTotalCount,
      'pageIndex': instance.pageIndex,
      'pageSize': instance.pageSize,
      'hasNext': instance.hasNext,
      'hasPrevious': instance.hasPrevious,
    };
