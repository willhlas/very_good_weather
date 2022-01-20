// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:very_good_weather/client/meta_weather_client.dart';
import 'package:very_good_weather/repository/weather_repository.dart';

class AppBlocObserver extends BlocObserver {

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
  
}

Future<void> bootstrap(
  FutureOr<Widget> Function(WeatherRepository weatherRepository) builder,
) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      final storage = await HydratedStorage.build(
        storageDirectory: await getTemporaryDirectory(),
      );
      await HydratedBlocOverrides.runZoned(() async 
        => runApp(
          await builder(
            WeatherRepository(
              MetaWeatherClient(http.Client()),
            ),
          ),
        ),
        blocObserver: AppBlocObserver(),
        storage: storage,
      );
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
