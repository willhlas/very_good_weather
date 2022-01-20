import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_weather/models/weather.dart';

void main() {
  group('Weather', () {

    const weatherStateName = 'Snow';
    const weatherStateAbbr = 'sn';
    const windSpeed = 18.123;
    const theTemp = 0.0;
    const humidity = 76;
    late DateTime applicableDate;
    late Weather weather;
    late Map<String, dynamic> json;

    setUp(() {
      applicableDate = DateTime.parse('2021-01-17');
      weather = Weather(
        applicableDate: applicableDate,
        weatherStateName: weatherStateName,
        weatherStateAbbr: weatherStateAbbr,
        windSpeed: windSpeed,
        theTemp: theTemp,
        humidity: humidity,
      );
      json = <String, dynamic>{
        'applicable_date': applicableDate.toIso8601String(),
        'weather_state_name': weatherStateName,
        'weather_state_abbr': weatherStateAbbr,
        'wind_speed': windSpeed,
        'the_temp': theTemp,
        'humidity': humidity,
      };
    });

    test('toJson', () {
      expect(weather.toJson(), json);
    });
    
    test('fromJson', () {
      expect(Weather.fromJson(json), weather);
    });

  });
}
