import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:very_good_weather/client/meta_weather_client.dart';
import 'package:very_good_weather/models/models.dart';
import 'package:very_good_weather/repository/weather_repository.dart';

part 'weather_cubit.g.dart';
part 'weather_state.dart';

class WeatherCubit extends HydratedCubit<WeatherState> {

  WeatherCubit(this.weatherRepository) : super(const WeatherState());

  final WeatherRepository weatherRepository;

  Future<void> getLocation(String? query) async {
    if (query == null || query.isEmpty) return;
    emit(state.copyWith(isSearchingLocation: true));
    try {
      final location = await weatherRepository.getLocation(query);
      if (location.woeid == state.location?.woeid) {
        emit(state.copyWith(isSearchingLocation: false));
        return;
      }
      emit(
        state.copyWith(
          isSearchingLocation: false,
          searchLocation: location,
        ),
      );
    } catch (e) {
      if (e is LocationNotFoundException) {
        emit(
          state.copyWith(
            isSearchingLocation: false,
          ),
        );
      } else {
        emit(
        state.copyWith(
          status: WeatherStatus.failure,
          isSearchingLocation: false,
        ),
      );
      }
    }
  }

  Future<void> getWeather() async {
    if (state.searchLocation == null) return;
    emit(state.copyWith(status: WeatherStatus.loading));
    try {
      final location = state.searchLocation!;
      final weather = await weatherRepository.getWeather(location);
      final forecast = await weatherRepository.getForecast(location);
      emit(
        state.copyWith(
          weather: weather,
          location: location,
          forecast: forecast,
          status: WeatherStatus.success,
        ),
      );
    } on Exception {
      emit(state.copyWith(status: WeatherStatus.failure));
    }
  }

  Future<void> refresh() async {
    if (state.status != WeatherStatus.success) return;
    if (state.location == null) return;
    try {
      final location = state.location!;
      final weather = await weatherRepository.getWeather(location);
      final forecast = await weatherRepository.getForecast(location);
      emit(
        state.copyWith(
          weather: weather,
          forecast: forecast,
        ),
      );
    } on Exception {
      emit(state);
    }
  }

  @override
  WeatherState fromJson(Map<String, dynamic> json) =>
      WeatherState.fromJson(json);

  @override
  Map<String, dynamic> toJson(WeatherState state) => state.toJson();

}
