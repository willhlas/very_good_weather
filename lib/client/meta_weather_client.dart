import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:very_good_weather/models/models.dart';

class LocationNotFoundException implements Exception {}

class MetaWeatherClient {

  MetaWeatherClient(this.client);

  final http.Client client;
  static const baseUrl = 'www.metaweather.com';

  Future<Location> locationSearch(String query) async {
    final request = Uri.https(baseUrl, '/api/location/search', <String, dynamic>{
      'query': query,
    });
    final response = await client.get(request);
    if (response.statusCode != 200) throw Exception('Location Request Failed!');
    final jsonBody = jsonDecode(response.body) as List;
    if (jsonBody.isEmpty) throw LocationNotFoundException();
    return Location.fromJson(jsonBody.first as Map<String, dynamic>);
  }

  Future<Weather> getWeatherByWoeid(int woeid) async {
    final request = Uri.https(baseUrl, '/api/location/$woeid');
    final response = await client.get(request);
    if (response.statusCode != 200) throw Exception('Weather Request Failed');
    final jsonBody = jsonDecode(response.body) as Map<String, dynamic>;
    if (jsonBody.isEmpty) throw Exception('Weather Data Failure');
    final consolidatedWeather = jsonBody['consolidated_weather'] as List;
    if (consolidatedWeather.isEmpty) throw Exception('Weather Data Failure');
    return Weather.fromJson(consolidatedWeather.first as Map<String, dynamic>);
  }

  Future<Weather?> getWeatherByWoeidAndDate(
    int woeid, String datePath,
  ) async {
    final request = Uri.https(baseUrl, '/api/location/$woeid/$datePath');
    final response = await client.get(request);
    if (response.statusCode != 200) {
      throw Exception('Weather Request By Date Failed');
    }
    final jsonBody = jsonDecode(response.body) as List;
    if (jsonBody.isEmpty) return null;
    return Weather.fromJson(jsonBody.first as Map<String, dynamic>);
  }

}
