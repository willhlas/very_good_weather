import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_weather/temperature_units/temperature_units.dart';

import '../../helpers/helpers.dart';

class MockTemperatureUnitsCubit extends MockCubit<TemperatureUnitsState>
  implements TemperatureUnitsCubit {}

void main() {
  group('Temperature', () {

    const value = 5.0;
    const textStyle = TextStyle();

    late TemperatureUnitsCubit cubit;

    setUp(() {
      cubit = MockTemperatureUnitsCubit();
    });

    testWidgets('renders text', (tester) async {
      when(() => cubit.state).thenReturn(const TemperatureUnitsState());
      await tester.pumpApp(
        BlocProvider.value(
          value: cubit,
          child: const Temperature(
            value: value,
            textStyle: textStyle,
          ),
        ),
      );
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('renders value to fahrenheit', (tester) async {
      when(() => cubit.state).thenReturn(const TemperatureUnitsState());
      await tester.pumpApp(
        BlocProvider.value(
          value: cubit,
          child: const Temperature(
            value: value,
            textStyle: textStyle,
          ),
        ),
      );
      final formattedValue = value.formattedUnit(cubit.state.unitsType);
      expect(find.text(formattedValue), findsOneWidget);
    });

    testWidgets('renders value to celsius (weather default)', (tester) async {
      when(() => cubit.state).thenReturn(const TemperatureUnitsState(
        unitsType: TemperatureUnitsType.celsius,
      ),);
      await tester.pumpApp(
        BlocProvider.value(
          value: cubit,
          child: const Temperature(
            value: value,
            textStyle: textStyle,
          ),
        ),
      );
      final formattedValue = value.formattedUnit(cubit.state.unitsType);
      expect(find.text(formattedValue), findsOneWidget);
    });

  });
}

extension on double {
  String formattedUnit(TemperatureUnitsType unitsType) {
    if (unitsType == TemperatureUnitsType.fahrenheit) {
      final temp = (((this * 9 / 5) + 32).round()).toString();
      return '$temp°F';
    } else {
      return '${round()}°C';
    }
  }
}
