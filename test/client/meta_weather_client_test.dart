import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:very_good_weather/client/meta_weather_client.dart';
import 'package:very_good_weather/models/location.dart';
import 'package:very_good_weather/models/weather.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeUri extends Fake implements Uri {}

void main() {
  group('MetaWeatherClient', () {

    late http.Client client;
    late http.Response response;
    late MetaWeatherClient metaWeatherClient;

    setUpAll(() {
      registerFallbackValue(FakeUri());
    });

    setUp(() {
      client = MockHttpClient();
      response = MockResponse();
      metaWeatherClient = MetaWeatherClient(client);
    });

    group('locationSearch', () {

      const query = 'Minneapolis';
      
      test('client gets correct Uri.https request', () async {
        when(() => client.get(any())).thenAnswer((_) async => response);
        try {
          await metaWeatherClient.locationSearch(query);
        } catch (_) {}
        verify(
          () => client.get(
            Uri.https(
              'www.metaweather.com',
              '/api/location/search',
              <String, dynamic>{'query': query},
            ),
          ),
        ).called(1);
      });

      test('throws Exception when response.status != 200', () async {
        when(() => response.statusCode).thenReturn(400);
        when(() => client.get(any())).thenAnswer((_) async => response);
        expect(
          () => metaWeatherClient.locationSearch(query),
          throwsException,
        );
      });

      test('throws LocationNotFoundException when jsonBody.isEmpty', () async {
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('[]');
        when(() => client.get(any())).thenAnswer((_) async => response);
        expect(
          () => metaWeatherClient.locationSearch(query),
          throwsA(isA<LocationNotFoundException>()),
        );
      });

      test('returns Location', () async {
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn(
          '''
            [{
              "woeid": 1,
              "title": "Minneapolis"
            }]
          ''',
        );
        when(() => client.get(any())).thenAnswer((_) async => response);
        final actual = await metaWeatherClient.locationSearch(query);
        expect(
          actual,
          isA<Location>()
            .having((l) => l.woeid, 'woeid', 1)
            .having((l) => l.title, 'title', 'Minneapolis'),
        );
      });
    });

    group('getWeatherByWoeid', () {

      const woeid = 1;

      test('client gets correct Uri.https request', () async {
        when(() => client.get(any())).thenAnswer((_) async => response);
        try {
          await metaWeatherClient.getWeatherByWoeid(woeid);
        } catch (_) {}
        verify(
          () => client.get(
            Uri.https(
              'www.metaweather.com',
              '/api/location/$woeid',
            ),
          ),
        ).called(1);
      });

      test('throws Exception when response.status != 200', () async {
        when(() => response.statusCode).thenReturn(400);
        when(() => client.get(any())).thenAnswer((_) async => response);
        expect(
          () async => metaWeatherClient.getWeatherByWoeid(woeid),
          throwsException,
        );
      });

      test('throws Exception when jsonBody.isEmpty', () async {
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('{}');
        when(() => client.get(any())).thenAnswer((_) async => response);
        expect(
          () async => metaWeatherClient.getWeatherByWoeid(woeid),
          throwsException,
        );
      });

      test('throws Exception when consolidatedWeather.isEmpty', () async {
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('{"consolidated_weather": []}');
        when(() => client.get(any())).thenAnswer((_) async => response);
        expect(
          () async => metaWeatherClient.getWeatherByWoeid(woeid),
          throwsException,
        );
      });

      test('returns Weather', () async {
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn(
          '''
            {
              "consolidated_weather": [{
                "applicable_date":"2021-01-17",
                "weather_state_name":"Snow",
                "weather_state_abbr":"sn",
                "wind_speed":18.123,
                "the_temp":0,
                "humidity":76
              }]
            }
          ''',
        );
        when(() => client.get(any())).thenAnswer((_) async => response);
        final actual = await metaWeatherClient.getWeatherByWoeid(woeid);
        expect(
          actual,
          isA<Weather>()
            .having((w) => 
              w.applicableDate, 'applicableDate', 
                DateTime.parse('2021-01-17'),)
            .having((w) => w.weatherStateName, 'weather_state_name', 'Snow')
            .having((w) => w.weatherStateAbbr, 'weather_state_abbr', 'sn')
            .having((w) => w.windSpeed, 'wind_speed', 18.123)
            .having((w) => w.theTemp, 'the_temp', 0)
            .having((w) => w.humidity, 'humidity', 76),
        );
      });

    });
  
    group('getWeatherByWoeidAndDate', () {

      const woeid = 1;
      const datePath = '2021/01/17';

      test('client gets correct Uri.https request', () async {
        when(() => client.get(any())).thenAnswer((_) async => response);
        try {
          await metaWeatherClient.getWeatherByWoeidAndDate(woeid, datePath);
        } catch (_) {}
        verify(
          () => client.get(
            Uri.https(
              'www.metaweather.com',
              '/api/location/$woeid/$datePath',
            ),
          ),
        ).called(1);
      });

      test('throws Exception when response.status != 200', () async {
        when(() => response.statusCode).thenReturn(400);
        when(() => client.get(any())).thenAnswer((_) async => response);
        expect(
          () async => 
            metaWeatherClient.getWeatherByWoeidAndDate(woeid, datePath),
          throwsException,
        );
      });

      test('returns null when jsonBody.isEmpty', () async {
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('[]');
        when(() => client.get(any())).thenAnswer((_) async => response);
        final actual = await metaWeatherClient
          .getWeatherByWoeidAndDate(woeid, datePath);
        expect(actual, isNull);
      });

      test('returns Weather', () async {
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn(
          '''
            [{
              "applicable_date":"2021-01-17",
              "weather_state_name":"Snow",
              "weather_state_abbr":"sn",
              "wind_speed":18.123,
              "the_temp":0,
              "humidity":76
            }]
          ''',
        );
        when(() => client.get(any())).thenAnswer((_) async => response);
        final actual = await metaWeatherClient
          .getWeatherByWoeidAndDate(woeid, datePath);
        expect(
          actual,
          isA<Weather>()
            .having((w) => 
              w.applicableDate, 'applicableDate', 
                DateTime.parse('2021-01-17'),)
            .having((w) => w.weatherStateName, 'weather_state_name', 'Snow')
            .having((w) => w.weatherStateAbbr, 'weather_state_abbr', 'sn')
            .having((w) => w.windSpeed, 'wind_speed', 18.123)
            .having((w) => w.theTemp, 'the_temp', 0)
            .having((w) => w.humidity, 'humidity', 76),
        );
      });

    });

  });
}
