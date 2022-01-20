// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_weather/app/theme/theme.dart';
import 'package:very_good_weather/repository/weather_repository.dart';
import 'package:very_good_weather/weather_view/weather_view.dart';

class VeryGoodWeatherApp extends StatelessWidget {

  const VeryGoodWeatherApp({
    Key? key,
    required this.weatherRepository,
  }) : super(key: key);

  final WeatherRepository weatherRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: weatherRepository,
      child: const VeryGoodWeatherAppView(),
    );
  }

}

class VeryGoodWeatherAppView extends StatelessWidget {

  const VeryGoodWeatherAppView({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppThemeData().materialTheme,
      home: const WeatherPage(),
    );
  }
  
}
