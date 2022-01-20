import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_weather/models/weather.dart';
import 'package:very_good_weather/temperature_units/temperature_units.dart';
import 'package:very_good_weather/weather_view/weather_view.dart';

import '../../../helpers/helpers.dart';

class MockTemperatureUnitsCubit extends MockCubit<TemperatureUnitsState>
  implements TemperatureUnitsCubit {}

void main() {
   
   group('WeatherWidget', () {

    const weatherStateName = 'Snow';
    const weatherStateAbbr = 'sn';
    const windSpeed = 18.123;
    const theTemp = 0.0;
    const humidity = 76;

    late Future<void> Function() onRefresh;
    late DateTime applicableDate;
    late Weather weather;
    late List<Weather> forecast;
    late TemperatureUnitsCubit temperatureUnitsCubit;

    setUp(() {
      onRefresh = () => Future<void>.delayed(const Duration(microseconds: 1));
      applicableDate = DateTime.parse('2021-01-17');
      weather = Weather(
        applicableDate: applicableDate,
        weatherStateName: weatherStateName,
        weatherStateAbbr: weatherStateAbbr,
        windSpeed: windSpeed,
        theTemp: theTemp,
        humidity: humidity,
      );
      forecast = <Weather>[weather];
      temperatureUnitsCubit = MockTemperatureUnitsCubit();
      when(() => temperatureUnitsCubit.state)
        .thenReturn(const TemperatureUnitsState());
    });

    testWidgets('renders main svg', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: temperatureUnitsCubit,
          child: WeatherWidget(
            weather: weather,
            forecast: forecast,
            onRefresh: onRefresh,
          ),
        ),
      );
      expect(find.byKey(const Key('main-svg')), findsOneWidget);
    });

    testWidgets('renders weatherStateName', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: temperatureUnitsCubit,
          child: WeatherWidget(
            weather: weather,
            forecast: forecast,
            onRefresh: onRefresh,
          ),
        ),
      );
      expect(find.text(weather.weatherStateName), findsOneWidget);
    });

    testWidgets('renders theTemp', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: temperatureUnitsCubit,
          child: WeatherWidget(
            weather: weather,
            forecast: forecast,
            onRefresh: onRefresh,
          ),
        ),
      );
      expect(find.byKey(const Key('main-temp')), findsOneWidget);
    });

    testWidgets('renders windSpeed with mph', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: temperatureUnitsCubit,
          child: WeatherWidget(
            weather: weather,
            forecast: forecast,
            onRefresh: onRefresh,
          ),
        ),
      );
      expect(find.text('${weather.windSpeed.round()} mph'), findsOneWidget);
    });

    testWidgets('renders humidity with %', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: temperatureUnitsCubit,
          child: WeatherWidget(
            weather: weather,
            forecast: forecast,
            onRefresh: onRefresh,
          ),
        ),
      );
      expect(find.text('${weather.humidity}%'), findsOneWidget);
    });

    testWidgets('renders forecast', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: temperatureUnitsCubit,
          child: WeatherWidget(
            weather: weather,
            forecast: forecast,
            onRefresh: onRefresh,
          ),
        ),
      );
      expect(find.byType(Forecast), findsOneWidget);
    });

  });

}
