import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_weather/client/meta_weather_client.dart';
import 'package:very_good_weather/models/models.dart';
import 'package:very_good_weather/repository/weather_repository.dart';
import 'package:very_good_weather/weather_view/weather_view.dart';

import '../../../helpers/helpers.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

class MockLocation extends Mock implements Location {}

class FakeLocation extends Fake implements Location {}

class MockWeather extends Mock implements Weather {}

const woeid = 1;
const title = 'Minneapolis';
const weatherStateName = 'Snow';
const weatherStateAbbr = 'sn';
const windSpeed = 18.123;
const theTemp = 2.523;
const humidity = 76;

void main() {
  group('WeatherCubit', () {

    late DateTime applicableDate;
    late WeatherRepository weatherRepository;
    late Location location;
    late Weather weather;
    late List<Weather> forecast;

    setUpAll(() {
      registerFallbackValue(FakeLocation());
    });

    setUp(() {
      applicableDate = DateTime.parse('2021-01-17');
      weatherRepository = MockWeatherRepository();
      location = MockLocation();
      weather = MockWeather();
      forecast = <MockWeather>[];
      when(() => location.woeid).thenReturn(woeid);
      when(() => location.title).thenReturn(title);
      when(() => weather.applicableDate).thenReturn(applicableDate);
      when(() => weather.weatherStateName).thenReturn(weatherStateName);
      when(() => weather.weatherStateAbbr).thenReturn(weatherStateAbbr);
      when(() => weather.windSpeed).thenReturn(windSpeed);
      when(() => weather.theTemp).thenReturn(theTemp);
      when(() => weather.humidity).thenReturn(humidity);
      when(
        () => weatherRepository.getLocation(any()),
      ).thenAnswer((_) async => location);
      when(
        () => weatherRepository.getWeather(any()),
      ).thenAnswer((_) async => weather);
      when(
        () => weatherRepository.getForecast(any()),
      ).thenAnswer((_) async => forecast);
    });

    test('initial state', () {
      mockHydratedStorage(() {
        expect(
          WeatherCubit(weatherRepository).state,
          const WeatherState(),
        );
      });
    });

    test('toJson and fromJson', () {
      mockHydratedStorage(() {
        final cubit = WeatherCubit(weatherRepository);
        expect(
          cubit.fromJson(cubit.toJson(cubit.state)),
          cubit.state,
        );
      });
    });

    group('getLocation', () {

      blocTest<WeatherCubit, WeatherState>(
        'returns when query is null',
        build: () => mockHydratedStorage(() => WeatherCubit(weatherRepository)),
        act: (cubit) => cubit.getLocation(null),
        expect: () => <WeatherState>[],
      );

      blocTest<WeatherCubit, WeatherState>(
        'returns when query is empty',
        build: () => mockHydratedStorage(() => WeatherCubit(weatherRepository)),
        act: (cubit) => cubit.getLocation(''),
        expect: () => <WeatherState>[],
      );

      blocTest<WeatherCubit, WeatherState>(
        'calls getLocation with correct title',
        build: () => mockHydratedStorage(() => WeatherCubit(weatherRepository)),
        act: (cubit) => cubit.getLocation(title),
        verify: (_) {
          verify(() => weatherRepository.getLocation(title)).called(1);
        },
      );

      blocTest<WeatherCubit, WeatherState>(
        'emits WeatherStatus.failure when getLocation has Exception',
        setUp: () {
          when(() => weatherRepository.getLocation(any()))
            .thenThrow(Exception());
        },
        build: () => mockHydratedStorage(() => WeatherCubit(weatherRepository)),
        act: (cubit) => cubit.getLocation(title),
        expect: () => <WeatherState>[
          const WeatherState(isSearchingLocation: true),
          const WeatherState(status: WeatherStatus.failure),
        ],
      );

      blocTest<WeatherCubit, WeatherState>(
        'emits same state when getLocation has LocationNotFoundException',
        setUp: () {
          when(() => weatherRepository.getLocation(any()))
            .thenThrow(LocationNotFoundException());
        },
        build: () => mockHydratedStorage(() => WeatherCubit(weatherRepository)),
        act: (cubit) => cubit.getLocation(title),
        expect: () => <WeatherState>[
          const WeatherState(isSearchingLocation: true),
          const WeatherState(),
        ],
      );

      blocTest<WeatherCubit, WeatherState>(
        'returns when location.woeid == state.location.woeid',
        build: () => mockHydratedStorage(() => WeatherCubit(weatherRepository)),
        seed: () => const WeatherState(location: Location(
          woeid: woeid,
          title: title,
        ),),
        act: (cubit) => cubit.getLocation(title),
        expect: () => <WeatherState>[
          const WeatherState(
            isSearchingLocation: true,
            location: Location(
              woeid: woeid,
              title: title,
            ),
          ),
          const WeatherState(
            location: Location(
              woeid: woeid,
              title: title,
            ),
          ),
        ],
      );

      blocTest<WeatherCubit, WeatherState>(
        'emits searchLocation correctly',
        build: () => mockHydratedStorage(() => WeatherCubit(weatherRepository)),
        act: (cubit) => cubit.getLocation(title),
        expect: () => <dynamic>[
          const WeatherState(isSearchingLocation: true),
          isA<WeatherState>()
            .having((w) => 
              w.searchLocation,
              'searchLocation',
              isA<Location>()
                .having((l) => l.woeid, 'woeid', woeid)
                .having((l) => l.title, 'title', title),
            )
        ],
      );

    });
  
    group('getWeather', () {

      blocTest<WeatherCubit, WeatherState>(
        'returns when state.searchLocation is null',
        build: () => mockHydratedStorage(() => WeatherCubit(weatherRepository)),
        act: (cubit) => cubit.getWeather(),
        expect: () => <WeatherState>[],
      );

      blocTest<WeatherCubit, WeatherState>(
        'emits WeatherStatus.failure when getWeather has Exception',
        setUp: () {
          when(() => weatherRepository.getWeather(any()))
            .thenThrow(Exception());
        },
        build: () => mockHydratedStorage(() => WeatherCubit(weatherRepository)),
        seed: () => WeatherState(searchLocation: location),
        act: (cubit) => cubit.getWeather(),
        expect: () => <WeatherState>[
          WeatherState(
            status: WeatherStatus.loading,
            searchLocation: location,
          ),
          WeatherState(
            status: WeatherStatus.failure,
            searchLocation: location,
          )
        ],
      );

      blocTest<WeatherCubit, WeatherState>(
        'emits WeatherStatus.failure when getForecast has Exception',
        setUp: () {
          when(() => weatherRepository.getForecast(any()))
            .thenThrow(Exception());
        },
        build: () => mockHydratedStorage(() => WeatherCubit(weatherRepository)),
        seed: () => WeatherState(searchLocation: location),
        act: (cubit) => cubit.getWeather(),
        expect: () => <WeatherState>[
          WeatherState(
            status: WeatherStatus.loading,
            searchLocation: location,
          ),
          WeatherState(
            status: WeatherStatus.failure,
            searchLocation: location,
          )
        ],
      );

      blocTest<WeatherCubit, WeatherState>(
        'emits weather, location, and forecast correctly',
        setUp: () {
          when(
            () => weatherRepository.getWeather(any()),
          ).thenAnswer((_) async => Weather(
            applicableDate: applicableDate,
            weatherStateName: weatherStateName,
            weatherStateAbbr: weatherStateAbbr,
            windSpeed: windSpeed,
            theTemp: theTemp,
            humidity: humidity,
          ),);
          when(
            () => weatherRepository.getForecast(any()),
          ).thenAnswer((_) async => [
            Weather(
              applicableDate: applicableDate.add(const Duration(days: 1)),
              weatherStateName: weatherStateName,
              weatherStateAbbr: weatherStateAbbr,
              windSpeed: windSpeed,
              theTemp: theTemp,
              humidity: humidity,
            ),
          ],);
        },
        build: () => mockHydratedStorage(() => WeatherCubit(weatherRepository)),
        seed: () => const WeatherState(
          searchLocation: Location(woeid: woeid, title: title),
        ),
        act: (cubit) => cubit.getWeather(),
        expect: () => <dynamic>[
          const WeatherState(
            status: WeatherStatus.loading,
            searchLocation: Location(woeid: woeid, title: title),
          ),
          isA<WeatherState>()
            .having((ws) => ws.status, 'status', WeatherStatus.success)
            .having((ws) =>
              ws.weather,
              'weather',
              isA<Weather>()
                .having(
                  (w) => w.applicableDate, 'applicable_date', applicableDate,
                )
                .having(
                  (w) => 
                    w.weatherStateName, 'weather_state_name', weatherStateName,
                )
                .having(
                  (w) => 
                    w.weatherStateAbbr, 'weather_state_abbr', weatherStateAbbr,
                )
                .having((w) => w.windSpeed, 'wind_speed', windSpeed)
                .having((w) => w.theTemp, 'the_temp', theTemp)
                .having((w) => w.humidity, 'humidity', humidity),
            )
            .having((ws) =>
              ws.location,
              'location',
              isA<Location>()
                .having((l) => l.woeid, 'woeid', woeid)
                .having((l) => l.title, 'title', title),
            )
            .having((ws) => 
              ws.forecast,
              'forecast',
              isA<List<Weather>>()
                .having((lw) => 
                  lw.first, 
                  'weather',
                  isA<Weather>()
                    .having(
                      (w) => w.applicableDate, 'applicable_date', applicableDate
                        .add(const Duration(days: 1)),
                    )
                    .having(
                      (w) => 
                        w.weatherStateName, 'weather_state_name', 
                          weatherStateName,
                    )
                    .having(
                      (w) => 
                        w.weatherStateAbbr, 'weather_state_abbr', 
                          weatherStateAbbr,
                    )
                    .having((w) => w.windSpeed, 'wind_speed', windSpeed)
                    .having((w) => w.theTemp, 'the_temp', theTemp)
                    .having((w) => w.humidity, 'humidity', humidity),
                ),
            )
        ],
      );

    });

    group('refresh', () {

      blocTest<WeatherCubit, WeatherState>(
        'returns when state.status != WeatherStatus.success',
        build: () => mockHydratedStorage(() => WeatherCubit(weatherRepository)),
        act: (cubit) => cubit.refresh(),
        expect: () => <WeatherState>[],
      );

      blocTest<WeatherCubit, WeatherState>(
        'returns when state.location is null',
        build: () => mockHydratedStorage(() => WeatherCubit(weatherRepository)),
        act: (cubit) => cubit.refresh(),
        expect: () => <WeatherState>[],
      );

      blocTest<WeatherCubit, WeatherState>(
        'emits same state when getWeather has Exception',
        setUp: () {
          when(
            () => weatherRepository.getWeather(any()),
          ).thenThrow(Exception());
        },
        build: () => mockHydratedStorage(() => WeatherCubit(weatherRepository)),
        seed: () => const WeatherState(
          location: Location(title: 'Minneapolis', woeid: 1),
        ),
        act: (cubit) => cubit.refresh(),
        expect: () => <WeatherState>[],
      );

      blocTest<WeatherCubit, WeatherState>(
        'emits same state when getForecast has Exception',
        setUp: () {
          when(
            () => weatherRepository.getForecast(any()),
          ).thenThrow(Exception());
        },
        build: () => mockHydratedStorage(() => WeatherCubit(weatherRepository)),
        seed: () => const WeatherState(
          location: Location(title: 'Minneapolis', woeid: 1),
        ),
        act: (cubit) => cubit.refresh(),
        expect: () => <WeatherState>[],
      );

      blocTest<WeatherCubit, WeatherState>(
        'emits new weather, and forecast correctly',
        setUp: () {
          when(
            () => weatherRepository.getWeather(any()),
          ).thenAnswer((_) async => Weather(
            applicableDate: applicableDate,
            weatherStateName: weatherStateName,
            weatherStateAbbr: weatherStateAbbr,
            windSpeed: windSpeed,
            theTemp: theTemp,
            humidity: humidity,
          ),);
          when(
            () => weatherRepository.getForecast(any()),
          ).thenAnswer((_) async => [
            Weather(
              applicableDate: applicableDate.add(const Duration(days: 1)),
              weatherStateName: weatherStateName,
              weatherStateAbbr: weatherStateAbbr,
              windSpeed: windSpeed,
              theTemp: theTemp,
              humidity: humidity,
            ),
          ],);
        },
        build: () => mockHydratedStorage(() => WeatherCubit(weatherRepository)),
        seed: () => const WeatherState(
          status: WeatherStatus.success,
          location: Location(woeid: woeid, title: title),
        ),
        act: (cubit) => cubit.refresh(),
        expect: () => <dynamic>[
          isA<WeatherState>()
            .having((ws) =>
              ws.weather,
              'weather',
              isA<Weather>()
                .having(
                  (w) => w.applicableDate, 'applicable_date', applicableDate,
                )
                .having(
                  (w) => 
                    w.weatherStateName, 'weather_state_name', weatherStateName,
                )
                .having(
                  (w) => 
                    w.weatherStateAbbr, 'weather_state_abbr', weatherStateAbbr,
                )
                .having((w) => w.windSpeed, 'wind_speed', windSpeed)
                .having((w) => w.theTemp, 'the_temp', theTemp)
                .having((w) => w.humidity, 'humidity', humidity),
            )
            .having((ws) =>
              ws.location,
              'location',
              isA<Location>()
                .having((l) => l.woeid, 'woeid', woeid)
                .having((l) => l.title, 'title', title),
            )
            .having((ws) => 
              ws.forecast,
              'forecast',
              isA<List<Weather>>()
                .having((lw) => 
                  lw.first, 
                  'weather',
                  isA<Weather>()
                    .having(
                      (w) => w.applicableDate, 'applicable_date', applicableDate
                        .add(const Duration(days: 1)),
                    )
                    .having(
                      (w) => 
                        w.weatherStateName, 'weather_state_name', 
                          weatherStateName,
                    )
                    .having(
                      (w) => 
                        w.weatherStateAbbr, 'weather_state_abbr',
                          weatherStateAbbr,
                    )
                    .having((w) => w.windSpeed, 'wind_speed', windSpeed)
                    .having((w) => w.theTemp, 'the_temp', theTemp)
                    .having((w) => w.humidity, 'humidity', humidity),
                ),
            )
        ],
      );


    });

  });
}
