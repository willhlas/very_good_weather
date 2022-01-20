import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_weather/app/view/app.dart';
import 'package:very_good_weather/repository/weather_repository.dart';
import 'package:very_good_weather/weather_view/weather_view.dart';

import '../helpers/helpers.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  group('VeryGoodWeatherApp', () {
    late WeatherRepository weatherRepository;

    setUp(() {
      weatherRepository = MockWeatherRepository();
    });

    testWidgets('renders VeryGoodWeatherAppView', (tester) async {
      await mockHydratedStorage(() async {
        await tester.pumpWidget(
          VeryGoodWeatherApp(weatherRepository: weatherRepository),
        );
      });
      expect(find.byType(VeryGoodWeatherAppView), findsOneWidget);
    });
  });

  group('VeryGoodWeatherAppView', () {
    late WeatherRepository weatherRepository;

    setUp(() {
      weatherRepository = MockWeatherRepository();
    });

    testWidgets('renders WeatherPage', (tester) async {
      await mockHydratedStorage(() async {
        await tester.pumpWidget(
          RepositoryProvider.value(
            value: weatherRepository,
            child: const VeryGoodWeatherAppView(),
          ),
        );
      });
      expect(find.byType(WeatherPage), findsOneWidget);
    });
  });

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
      });
      expect(find.byType(WeatherView), findsOneWidget);
    });
  });
}
