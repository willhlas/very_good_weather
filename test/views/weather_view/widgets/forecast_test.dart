import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_weather/models/weather.dart';
import 'package:very_good_weather/temperature_units/cubit/temperature_units_cubit.dart';
import 'package:very_good_weather/weather_view/weather_view.dart';

import '../../../helpers/helpers.dart';

class MockTemperatureUnitsCubit extends MockCubit<TemperatureUnitsState>
  implements TemperatureUnitsCubit {}

void main() {

  group('Forecast', () {
    
    final forecast = <Weather>[
      Weather(
        applicableDate: DateTime.parse('2021-02-17'),
        weatherStateName: 'Snow',
        weatherStateAbbr: 'sn',
        windSpeed: 17.123,
        theTemp: 0,
        humidity: 77,
      ),
      Weather(
        applicableDate: DateTime.parse('2021-03-17'),
        weatherStateName: 'Snow',
        weatherStateAbbr: 'sn',
        windSpeed: 16.123,
        theTemp: 1,
        humidity: 78,
      ),
    ];

    late TemperatureUnitsCubit temperatureUnitsCubit;

    setUp(() {
      temperatureUnitsCubit = MockTemperatureUnitsCubit();
      when(() => temperatureUnitsCubit.state)
        .thenReturn(const TemperatureUnitsState());
    });

    testWidgets('renders ListView.builder', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: temperatureUnitsCubit,
          child: Forecast(forecast: forecast),
        ),
      );
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('renders applicableDate', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: temperatureUnitsCubit,
          child: Forecast(forecast: forecast),
        ),
      );
      expect(
        find.text(DateFormat.MMMEd().format(forecast.first.applicableDate)),
        findsOneWidget,
      );
      expect(
        find.text(DateFormat.MMMEd().format(forecast[1].applicableDate)),
        findsOneWidget,
      );
    });

    testWidgets('renders multiple svgs', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: temperatureUnitsCubit,
          child: Forecast(forecast: forecast),
        ),
      );
      expect(find.byType(SvgPicture), findsWidgets);
    });

  });

}
