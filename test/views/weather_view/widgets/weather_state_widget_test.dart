import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_weather/weather_view/weather_view.dart';

import '../../../helpers/helpers.dart';

void main() {

  group('WeatherStateWidget', () {

    const message = 'test-message';

    testWidgets('renders message', (tester) async {
      await tester.pumpApp(const WeatherStateWidget(message: message));
      expect(find.text(message), findsOneWidget);
    });

    testWidgets(
      'Loading indicator is NOT visible when isLoading = false',
      (tester) async {
        await tester.pumpApp(
          const WeatherStateWidget(message: message),
        );
        expect(find.byType(CircularProgressIndicator), findsNothing);
      }
    );

    testWidgets(
      'Loading indicator is visible when isLoading = true',
      (tester) async {
        await tester.pumpApp(
          const WeatherStateWidget(
            message: message,
            isLoading: true,
          ),
        );
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      }
    );

  });

}
