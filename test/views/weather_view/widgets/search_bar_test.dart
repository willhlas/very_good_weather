import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_weather/models/location.dart';
import 'package:very_good_weather/temperature_units/cubit/temperature_units_cubit.dart';
import 'package:very_good_weather/weather_view/weather_view.dart';

import '../../../helpers/helpers.dart';

class MockWeatherCubit extends MockCubit<WeatherState> 
  implements WeatherCubit {}

class MockTemperatureUnitsCubit extends MockCubit<TemperatureUnitsState>
  implements TemperatureUnitsCubit {}

void main() {
  
  group('SearchBar', () {

    const location = Location(
      woeid: 1,
      title: 'Minneapolis',
    );

    late WeatherCubit weatherCubit;
    late TemperatureUnitsCubit temperatureUnitsCubit;

    setUp(() {
      weatherCubit = MockWeatherCubit();
      temperatureUnitsCubit = MockTemperatureUnitsCubit();
      when(() => temperatureUnitsCubit.state)
        .thenReturn(const TemperatureUnitsState());
    });

    testWidgets(
      'hides AppBar when state.status == WeatherStatus.loading',
      (tester) async {
        when(() => weatherCubit.state).thenReturn(
          const WeatherState(
            status: WeatherStatus.loading,
          ),
        );
        await tester.pumpApp(
          SearchBar(state: weatherCubit.state),
        );
        expect(find.byType(AppBar), findsNothing);
      }
    );

    testWidgets(
      'shows AppBar when state.status != WeatherStatus.loading',
      (tester) async {
        when(() => weatherCubit.state).thenReturn(const WeatherState());
        await tester.pumpApp(
          BlocProvider.value(
            value: temperatureUnitsCubit,
            child: SearchBar(state: weatherCubit.state),
          ),
        );
        expect(find.byType(AppBar), findsOneWidget);
      }
    );

    testWidgets('shows initialValue when location is not null', (tester) async {
      when(() => weatherCubit.state).thenReturn(const WeatherState(
        location: location,
      ),);
      await tester.pumpApp(
        BlocProvider.value(
          value: temperatureUnitsCubit,
          child: SearchBar(state: weatherCubit.state),
        ),
      );
      expect(
        find.widgetWithText(TextFormField, location.title),
        findsOneWidget,
      );
    });

    testWidgets('shows loading when state.isSearchingLocation', (tester) async {
      when(() => weatherCubit.state).thenReturn(const WeatherState(
        isSearchingLocation: true,
      ),);
      await tester.pumpApp(
        BlocProvider.value(
          value: temperatureUnitsCubit,
          child: SearchBar(state: weatherCubit.state),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
      '''
        shows TextButton when: 
          state.isSearchingLocation = false &&
          state.searchLocation != null &&
          state.searchLocation.title != state.location.title
      ''',
      (tester) async {
        when(() => weatherCubit.state).thenReturn(const WeatherState(
          location: location,
          searchLocation: Location(
            woeid: 2,
            title: 'New York',
          ),
        ),);
        await tester.pumpApp(
          BlocProvider.value(
            value: temperatureUnitsCubit,
            child: SearchBar(state: weatherCubit.state),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('searchButtonKey')), findsOneWidget);
      }
    );

    testWidgets(
      'hides TextButton when searchLocation.title = location.title',
      (tester) async {
        when(() => weatherCubit.state).thenReturn(const WeatherState(
          location: location,
          searchLocation: location,
        ),);
        await tester.pumpApp(
          BlocProvider.value(
            value: temperatureUnitsCubit,
            child: SearchBar(state: weatherCubit.state),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('searchButtonKey')), findsNothing);
      }
    );

    testWidgets('calls getWeather when TextButton is pressed', (tester) async {
      when(() => weatherCubit.state).thenReturn(const WeatherState(
        searchLocation: location,
      ),);
      when(() => weatherCubit.getWeather()).thenAnswer((_) async {});
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: temperatureUnitsCubit),
            BlocProvider.value(value: weatherCubit),
          ],
          child: SearchBar(state: weatherCubit.state),
        ),
      );
      await tester.tap(find.byKey(const Key('searchButtonKey')));
      await tester.pumpAndSettle();
      verify(() => weatherCubit.getWeather()).called(1);
    });

    testWidgets('calls changeUnits when IconButton pressed', (tester) async {
      when(() => weatherCubit.state).thenReturn(const WeatherState());
      when(() => temperatureUnitsCubit.changeUnits()).thenAnswer((_) async {});
      await tester.pumpApp(
        BlocProvider.value(
          value: temperatureUnitsCubit,
          child: SearchBar(state: weatherCubit.state),
        ),
      );
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();
      verify(() => temperatureUnitsCubit.changeUnits()).called(1);
    });
    
  });

}
