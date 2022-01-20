import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:very_good_weather/models/models.dart' show Weather;
import 'package:very_good_weather/temperature_units/temperature_units.dart';

class Forecast extends StatelessWidget {

  const Forecast({
    Key? key,
    required this.forecast,
  }): super(key: key);

  final List<Weather> forecast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.builder(
      padding: const EdgeInsets.only(left: 8, right: 8),
      scrollDirection: Axis.horizontal,
      itemCount: forecast.length,
      itemBuilder: (context, index) {
        final formattedDate = DateFormat.MMMEd()
          .format(forecast[index].applicableDate);
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 16),
                child: Text(
                  formattedDate,
                  style: theme.textTheme.subtitle2,
                ),
              ),
              Material(
                color: theme.primaryColor.withOpacity(0.36),
                borderRadius: BorderRadius.circular(24),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: SvgPicture.asset(
                          'assets/weather/${forecast[index].weatherStateAbbr}.svg',
                          color: theme.scaffoldBackgroundColor,
                          height: 50,
                          width: 50,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Temperature(
                        value: forecast[index].theTemp,
                        textStyle: theme.textTheme.headline5,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
}
