// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Location',
      json,
      ($checkedConvert) {
        final val = Location(
          woeid: $checkedConvert('woeid', (v) => v as int),
          title: $checkedConvert('title', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'woeid': instance.woeid,
      'title': instance.title,
    };
