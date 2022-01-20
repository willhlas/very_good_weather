import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:very_good_weather/models/models.dart' show Weather;
import 'package:very_good_weather/temperature_units/temperature_units.dart';
import 'package:very_good_weather/weather_view/weather_view.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherWidget extends StatelessWidget {

  const WeatherWidget({
    Key? key,
    required this.weather,
    required this.forecast,
    required this.onRefresh,
  }) : super(key: key);

  final Weather weather;
  final List<Weather> forecast;
  final ValueGetter<Future<void>> onRefresh;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20, bottom: 100),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/weather/${weather.weatherStateAbbr}.svg',
              key: const Key('main-svg'),
              height: 125,
              width: 125,
            ),
            const SizedBox(height: 30),
            Text(
              weather.weatherStateName,
              style: textTheme.subtitle1,
            ),
            const SizedBox(height: 4),
            Temperature(
              key: const Key('main-temp'),
              value: weather.theTemp,
              textStyle: textTheme.headline2,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const BoxedIcon(
                      WeatherIcons.windy,
                    ),
                    Text('${weather.windSpeed.round()} mph'),
                  ],
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: BoxedIcon(
                        WeatherIcons.humidity,
                        size: 18,
                      ),
                    ),
                    Text('${weather.humidity}%'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),
            Visibility(
              visible: forecast.isNotEmpty,
              child: SizedBox(
                height: 200,
                child: Forecast(forecast: forecast),
              ),
            )
          ],
        ),
      ),
    );
  }
  
}
