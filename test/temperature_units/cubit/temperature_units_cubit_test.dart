import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_weather/temperature_units/temperature_units.dart';

import '../../helpers/helpers.dart';

class MockTemperatureUnitsState extends Mock implements TemperatureUnitsState {}

void main() {

  group('TemperatureUnitsCubit', () {

    test('initial state', () {
      mockHydratedStorage(() {
        expect(
          TemperatureUnitsCubit().state,
          const TemperatureUnitsState(),
        );
      });
    });

    test('toJson and fromJson', () {
      mockHydratedStorage(() {
        final cubit = TemperatureUnitsCubit();
        expect(
          cubit.fromJson(cubit.toJson(cubit.state)),
          cubit.state,
        );
      });
    });

    group('changeUnits', () {

      blocTest<TemperatureUnitsCubit, TemperatureUnitsState>(
        '''
          emits unitsType to TemperatureUnitsType.fahrenheit when state.unitsType == TemperatureUnitsType.celsius
        ''',
        build: () => mockHydratedStorage(() => TemperatureUnitsCubit()),
        seed: () => const TemperatureUnitsState(
          unitsType: TemperatureUnitsType.celsius,
        ),
        act: (cubit) => cubit.changeUnits(),
        expect: () => <TemperatureUnitsState>[
          const TemperatureUnitsState()
        ],
      );

      blocTest<TemperatureUnitsCubit, TemperatureUnitsState>(
        '''
          emits unitsType to TemperatureUnitsType.celsius when state.unitsType == TemperatureUnitsType.fahrenheit
        ''',
        build: () => mockHydratedStorage(() => TemperatureUnitsCubit()),
        act: (cubit) => cubit.changeUnits(),
        expect: () => <TemperatureUnitsState>[
          const TemperatureUnitsState(
            unitsType: TemperatureUnitsType.celsius,
          )
        ],
      );

    });
    
  });

}
