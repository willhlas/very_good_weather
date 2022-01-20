// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weather _$WeatherFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Weather',
      json,
      ($checkedConvert) {
        final val = Weather(
          applicableDate: $checkedConvert(
              'applicable_date', (v) => DateTime.parse(v as String)),
          weatherStateName:
              $checkedConvert('weather_state_name', (v) => v as String),
          weatherStateAbbr:
              $checkedConvert('weather_state_abbr', (v) => v as String),
          windSpeed:
              $checkedConvert('wind_speed', (v) => (v as num).toDouble()),
          theTemp: $checkedConvert('the_temp', (v) => (v as num).toDouble()),
          humidity: $checkedConvert('humidity', (v) => v as int),
        );
        return val;
      },
      fieldKeyMap: const {
        'applicableDate': 'applicable_date',
        'weatherStateName': 'weather_state_name',
        'weatherStateAbbr': 'weather_state_abbr',
        'windSpeed': 'wind_speed',
        'theTemp': 'the_temp'
      },
    );

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
      'applicable_date': instance.applicableDate.toIso8601String(),
      'weather_state_name': instance.weatherStateName,
      'weather_state_abbr': instance.weatherStateAbbr,
      'wind_speed': instance.windSpeed,
      'the_temp': instance.theTemp,
      'humidity': instance.humidity,
    };
