import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_weather/models/models.dart';
import 'package:very_good_weather/repository/weather_repository.dart';
import 'package:very_good_weather/temperature_units/temperature_units.dart';
import 'package:very_good_weather/weather_view/weather_view.dart';

import '../../../helpers/helpers.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

class MockWeatherCubit extends MockCubit<WeatherState> 
  implements WeatherCubit {}

class MockTemperatureUnitsCubit extends MockCubit<TemperatureUnitsState>
  implements TemperatureUnitsCubit {}

void main() {
  
  group('WeatherPage', () {

    late WeatherRepository weatherRepository;

    setUp(() {
      weatherRepository = MockWeatherRepository();
    });

    testWidgets('renders WeatherView', (tester) async {
      await mockHydratedStorage(() async {
        await tester.pumpApp(
          RepositoryProvider.value(
            value: weatherRepository,
            child: const WeatherPage(),
          ),
        );
        expect(find.byType(WeatherView), findsOneWidget);
      });
    });

  });

  group('WeatherView', () {

    const location = Location(
      woeid: 1,
      title: 'Minneapolis',
    );

    const weatherStateName = 'Snow';
    const weatherStateAbbr = 'sn';
    const windSpeed = 18.123;
    const theTemp = 0.0;
    const humidity = 76;

    late DateTime applicableDate;
    late Weather weather;
    late WeatherCubit weatherCubit;
    late TemperatureUnitsCubit temperatureUnitsCubit;

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
      weatherCubit = MockWeatherCubit();
      temperatureUnitsCubit = MockTemperatureUnitsCubit();
    });

    testWidgets(
      'renders WeatherStateWidget for WeatherStatus.intial',
      (tester) async {
        when(() => weatherCubit.state).thenReturn(const WeatherState());
        when(() => temperatureUnitsCubit.state)
          .thenReturn(const TemperatureUnitsState());
        await tester.pumpApp(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: weatherCubit),
              BlocProvider.value(value: temperatureUnitsCubit),
            ],
            child: const WeatherView(),
          ),
        );
        expect(find.byType(WeatherStateWidget), findsOneWidget);
        expect(find.text('Search a city for weather!'), findsOneWidget);
      }
    );

    testWidgets(
      'renders WeatherStateWidget for WeatherStatus.loading',
      (tester) async {
        when(() => weatherCubit.state).thenReturn(const WeatherState(
          status: WeatherStatus.loading,
          searchLocation: location,
        ),);
        when(() => temperatureUnitsCubit.state)
          .thenReturn(const TemperatureUnitsState());
        await tester.pumpApp(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: weatherCubit),
              BlocProvider.value(value: temperatureUnitsCubit),
            ],
            child: const WeatherView(),
          ),
        );
        expect(find.byType(WeatherStateWidget), findsOneWidget);
        expect(
          find.text(
            'Loading Weather for ${weatherCubit.state.searchLocation?.title}',
          ),
          findsOneWidget,
        ); 
      }
    );

    testWidgets(
      'renders WeatherStateWidget for WeatherStatus.failure',
      (tester) async {
        when(() => weatherCubit.state).thenReturn(const WeatherState(
          status: WeatherStatus.failure,
        ),);
        when(() => temperatureUnitsCubit.state)
          .thenReturn(const TemperatureUnitsState());
        await tester.pumpApp(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: weatherCubit),
              BlocProvider.value(value: temperatureUnitsCubit),
            ],
            child: const WeatherView(),
          ),
        );
        expect(find.byType(WeatherStateWidget), findsOneWidget);
        expect(find.text('Something went wrong!'), findsOneWidget);
      }
    );

    testWidgets(
      '''renders WeatherStateWidget for WeatherStatus.success when state.weather == null''',
      (tester) async {
        when(() => weatherCubit.state).thenReturn(const WeatherState(
          status: WeatherStatus.success,
        ),);
        when(() => temperatureUnitsCubit.state)
          .thenReturn(const TemperatureUnitsState());
        await tester.pumpApp(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: weatherCubit),
              BlocProvider.value(value: temperatureUnitsCubit),
            ],
            child: const WeatherView(),
          ),
        );
        expect(find.byType(WeatherStateWidget), findsOneWidget);
        expect(find.text('Try refreshing!'), findsOneWidget);
      }
    );

    testWidgets(
      'renders WeatherWidget for WeatherStatus.success',
      (tester) async {
        when(() => weatherCubit.state).thenReturn(WeatherState(
          status: WeatherStatus.success,
          weather: weather,
        ),);
        when(() => temperatureUnitsCubit.state)
          .thenReturn(const TemperatureUnitsState());
        await tester.pumpApp(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: weatherCubit),
              BlocProvider.value(value: temperatureUnitsCubit),
            ],
            child: const WeatherView(),
          ),
        );
        expect(find.byType(WeatherWidget), findsOneWidget);
      }
    );

    testWidgets(
      'WeatherWidget triggers refresh from onRefresh',
      (tester) async {
        when(() => weatherCubit.state).thenReturn(
          WeatherState(
            status: WeatherStatus.success,
            weather: weather,
          ),
        );
        when(() => temperatureUnitsCubit.state)
            .thenReturn(const TemperatureUnitsState());
        when(() => weatherCubit.refresh()).thenAnswer((_) async {});
        await tester.pumpApp(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: weatherCubit),
              BlocProvider.value(value: temperatureUnitsCubit),
            ],
            child: const WeatherView(),
          ),
        );
        await tester.fling(
          find.text(weather.weatherStateName),
          const Offset(0, 500),
          1000,
        );
        await tester.pumpAndSettle();
        verify(() => weatherCubit.refresh()).called(1);
      }
    );
    
  });

}
