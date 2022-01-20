import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

@JsonSerializable()
class Weather extends Equatable {

  const Weather({
    required this.applicableDate,
    required this.weatherStateName,
    required this.weatherStateAbbr,
    required this.windSpeed,
    required this.theTemp,
    required this.humidity,
  });

  factory Weather.fromJson(Map<String, dynamic> json) =>
    _$WeatherFromJson(json);

  final DateTime applicableDate;
  final String weatherStateName;
  final String weatherStateAbbr;
  final double windSpeed;
  final double theTemp;
  final int humidity;

  Map<String, dynamic> toJson() => _$WeatherToJson(this);

  @override
  List<Object?> get props => [
    applicableDate, weatherStateName, weatherStateAbbr,
    windSpeed, theTemp, humidity,
  ];
  
}
