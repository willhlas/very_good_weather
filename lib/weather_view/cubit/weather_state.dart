part of 'weather_cubit.dart';

enum WeatherStatus { initial, loading, success, failure }

@JsonSerializable()
class WeatherState extends Equatable {

  const WeatherState({
    this.status = WeatherStatus.initial,
    this.weather,
    this.isSearchingLocation = false,
    this.searchLocation,
    this.location,
    this.forecast,
  });
  
  factory WeatherState.fromJson(Map<String, dynamic> json) 
    => _$WeatherStateFromJson(json);

  final WeatherStatus status;
  final Weather? weather;
  @JsonKey(ignore: true)
  final bool isSearchingLocation;
  @JsonKey(ignore: true)
  final Location? searchLocation;
  final Location? location;
  final List<Weather>? forecast;

  WeatherState copyWith({
    WeatherStatus? status,
    Weather? weather,
    bool? isSearchingLocation,
    Location? searchLocation,
    Location? location,
    List<Weather>? forecast,
  }) => WeatherState(
    status: status ?? this.status,
    weather: weather ?? this.weather,
    isSearchingLocation: isSearchingLocation ?? this.isSearchingLocation,
    searchLocation: searchLocation ?? this.searchLocation,
    location: location ?? this.location,
    forecast: forecast ?? this.forecast,
  );

  Map<String, dynamic> toJson() => _$WeatherStateToJson(this);

  @override
  List<Object?> get props => [
    status, weather, isSearchingLocation, searchLocation,
    location, forecast
  ];
  
}
