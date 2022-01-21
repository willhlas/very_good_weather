import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_weather/client/meta_weather_client.dart';
import 'package:very_good_weather/models/models.dart';
import 'package:very_good_weather/repository/weather_repository.dart';

class MockMetaWeatherClient extends Mock implements MetaWeatherClient {}

class MockLocation extends Mock implements Location {}

class MockWeather extends Mock implements Weather {}


void main() {
  group('WeatherRepository', () {

    const woeid = 1;
    const title = 'Minneapolis';
    const datePath = '2021/01/17';
    const weatherStateName = 'Snow';
    const weatherStateAbbr = 'sn';
    const windSpeed = 18.123;
    const theTemp = 0.0;
    const humidity = 76;
    
    late MetaWeatherClient client;
    late Location location;
    late Weather weather;
    late WeatherRepository weatherRepository;

    setUp(() {
      client = MockMetaWeatherClient();
      location = MockLocation();
      weather = MockWeather();
      weatherRepository = WeatherRepository(client);
    });

    group('getLocation', () {

      test('calls locationSearch', () async {
        try {
          await weatherRepository.getLocation(title);
        } catch (_) {}
        verify(() => client.locationSearch(title)).called(1);
      });

      test('throws Exception when locationSearch throws', () async {
        when(() => client.locationSearch(any())).thenThrow(Exception());
        expect(
          () async => weatherRepository.getLocation(title),
          throwsException,
        );
      });

      test('returns Location', () async {
        when(() => location.woeid).thenReturn(woeid);
        when(() => location.title).thenReturn(title);
        when(() => client.locationSearch(any())).thenAnswer(
          (_) async => location,
        );
        final actual = await weatherRepository.getLocation(title);
        expect(
          actual,
          isA<Location>()
            .having((l) => l.woeid, 'woeid', woeid)
            .having((l) => l.title, 'title', title),
        );
      });

    });

    group('getWeather', () {

      late DateTime applicableDate;

      setUp(() {
        applicableDate = DateTime.parse('2021-01-17');
        when(() => location.woeid).thenReturn(woeid);
        when(() => location.title).thenReturn(title);
        when(() => weather.applicableDate).thenReturn(applicableDate);
        when(() => weather.weatherStateName).thenReturn(weatherStateName);
        when(() => weather.weatherStateAbbr).thenReturn(weatherStateAbbr);
        when(() => weather.windSpeed).thenReturn(windSpeed);
        when(() => weather.theTemp).thenReturn(theTemp);
        when(() => weather.humidity).thenReturn(humidity);
      });

      test('calls getWeatherByWoeid with correct Location', () async {
        try {
          await weatherRepository.getWeather(location);
        } catch (_) {}
        verify(() => client.getWeatherByWoeid(1)).called(1);
      });

      test(
        'calls getWeatherByWoeidAndDate with correct Location and datePath',
        () async {
          try {
            await weatherRepository.getWeather(location, datePath: datePath);
          } catch (_) {}
          verify(() => client.getWeatherByWoeidAndDate(1, '2021/01/17')).called(1);
        }
      );

      test('throws Exception when getWeatherByWoeid throws', () async {
        when(() => client.getWeatherByWoeid(any())).thenThrow(Exception());
        expect(
          () async => weatherRepository.getWeather(location),
          throwsException,
        );
      });

      test('throws Exception when getWeatherByWoeidAndDate throws', () async {
        when(() => client.getWeatherByWoeidAndDate(any(), any()))
          .thenThrow(Exception());
        expect(
          () async => weatherRepository
            .getWeather(location, datePath: datePath),
          throwsException,
        );
      });

      test(
        'getWeatherByWoeidAndDate retuns null when Weather is null',
        () async {
          when(() => client.getWeatherByWoeidAndDate(any(), any()))
            .thenAnswer((_) async {});
          final actual = await weatherRepository
            .getWeather(location, datePath: datePath);
          expect(actual, isNull);
        }
      );

      test('getWeatherByWoeid returns Weather', () async {
        when(() => client.getWeatherByWoeid(any())).thenAnswer(
          (_) async => weather,
        );
        final actual = await weatherRepository.getWeather(location);
        expect(
          actual,
          isA<Weather>()
            .having((w) => w.applicableDate, 
              'applicable_date', DateTime.parse('2021-01-17'),)
            .having((w) => w.weatherStateName, 'weather_state_name', 'Snow')
            .having((w) => w.weatherStateAbbr, 'weather_state_abbr', 'sn')
            .having((w) => w.windSpeed, 'wind_speed', 18.123)
            .having((w) => w.theTemp, 'the_temp', 0)
            .having((w) => w.humidity, 'humidity', 76),
        );
      });

      test('getWeatherByWoeidAndDate returns Weather', () async {
        when(() => client.getWeatherByWoeidAndDate(any(), any()))
          .thenAnswer((_) async => weather);
        final actual = await weatherRepository.getWeather(
          location, datePath: datePath,
        );
        expect(
          actual,
          isA<Weather>()
            .having((w) => w.applicableDate, 
              'applicable_date', DateTime.parse('2021-01-17'),)
            .having((w) => w.weatherStateName, 'weather_state_name', 'Snow')
            .having((w) => w.weatherStateAbbr, 'weather_state_abbr', 'sn')
            .having((w) => w.windSpeed, 'wind_speed', 18.123)
            .having((w) => w.theTemp, 'the_temp', 0)
            .having((w) => w.humidity, 'humidity', 76),
        );
      });

    });

    group('getForecast', () {

      late DateTime applicableDate;

      setUp(() {
        applicableDate = DateTime.parse('2021-01-17');
        when(() => location.woeid).thenReturn(woeid);
        when(() => location.title).thenReturn(title);
        when(() => weather.applicableDate).thenReturn(applicableDate);
        when(() => weather.weatherStateName).thenReturn(weatherStateName);
        when(() => weather.weatherStateAbbr).thenReturn(weatherStateAbbr);
        when(() => weather.windSpeed).thenReturn(windSpeed);
        when(() => weather.theTemp).thenReturn(theTemp);
        when(() => weather.humidity).thenReturn(humidity);
      });

      test('calls getWeatherByWoeidAndDate with correct Location', () async {
          try {
            await weatherRepository.getForecast(location);
          } catch (_) {}
          verify(() => client.getWeatherByWoeidAndDate(1, any())).called(1);
        }
      );

      test('throws Exception when getWeatherByWoeidAndDate throws', () async {
        when(() => client.getWeatherByWoeidAndDate(any(), any()))
          .thenThrow(Exception());
        expect(
          () async => weatherRepository.getForecast(location),
          throwsException,
        );
      });

      test(
        'getWeatherByWoeidAndDate retuns Empty List when Weather is null',
        () async {
          when(() => client.getWeatherByWoeidAndDate(any(), any()))
            .thenAnswer((_) async {});
          final actual = await weatherRepository.getForecast(location);
          expect(actual, isEmpty);
        }
      );

      test('getWeatherByWoeidAndDate returns List<Weather>', () async {
        when(() => client.getWeatherByWoeidAndDate(any(), any()))
          .thenAnswer((_) async => weather);
        final actual = await weatherRepository.getForecast(location);
        expect(
          actual,
          isA<List<Weather>>()
            .having((lw) => 
              lw.first,
              'Weather',
              isA<Weather>()
                .having((w) => 
                  w.applicableDate, 'applicable_date', applicableDate,)
                .having((w) => 
                  w.weatherStateName, 'weather_state_name', weatherStateName,)
                .having((w) => 
                  w.weatherStateAbbr, 'weather_state_abbr', weatherStateAbbr,)
                .having((w) => w.windSpeed, 'wind_speed', windSpeed)
                .having((w) => w.theTemp, 'the_temp', theTemp)
                .having((w) => w.humidity, 'humidity', humidity),
            ),
        );
      });

    });

  });
  
}
