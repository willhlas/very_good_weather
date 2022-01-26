import 'package:intl/intl.dart';
import 'package:very_good_weather/client/meta_weather_client.dart';
import 'package:very_good_weather/models/models.dart';

class WeatherRepository {

  WeatherRepository({
    MetaWeatherClient? metaWeatherClient,
  }) : _metaWeatherClient = metaWeatherClient 
        ?? MetaWeatherClient();

  late final MetaWeatherClient _metaWeatherClient;

  Future<Location> getLocation(String query) async =>
    _metaWeatherClient.locationSearch(query);
  
  Future<Weather?> getWeather(Location location, {String? datePath}) async {
    final weather = datePath == null
      ? await _metaWeatherClient.getWeatherByWoeid(location.woeid)
      : await _metaWeatherClient.getWeatherByWoeidAndDate(
          location.woeid, datePath,
        );
    return weather;
  }
  
  Future<List<Weather>> getForecast(Location location) async {
    final listOfWeather = <Weather>[];
    final currentDate = DateTime.now();
    for (var i = 1; i < 6; i++) {
      final date = currentDate.add(Duration(days: i));
      final year = DateFormat.y().format(date);
      final month = DateFormat.M().format(date);
      final day = DateFormat.d().format(date);
      final datePath = '$year/$month/$day';
      final weather = await getWeather(location, datePath: datePath);
      if (weather != null) listOfWeather.add(weather);
    }
    return listOfWeather;
  }
  
}
