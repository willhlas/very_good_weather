// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:very_good_weather/app/app.dart';
import 'package:very_good_weather/bootstrap.dart';

void main() {
  bootstrap((weatherRepository) => VeryGoodWeatherApp(
    weatherRepository: weatherRepository,
  ),);
}
