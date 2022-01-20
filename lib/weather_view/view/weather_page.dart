import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_weather/repository/weather_repository.dart';
import 'package:very_good_weather/temperature_units/temperature_units.dart';
import 'package:very_good_weather/weather_view/weather_view.dart';

class WeatherPage extends StatelessWidget {

  const WeatherPage({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => WeatherCubit(
          context.read<WeatherRepository>(),
        ),),
        BlocProvider(create: (_) => TemperatureUnitsCubit()),
      ],
      child: const WeatherView(),
    );
  }

}

class WeatherView extends StatelessWidget {

  const WeatherView({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) => Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: SearchBar(state: state),
        ),
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Builder(
            builder: (context) {
              switch (state.status) {
                case WeatherStatus.initial:
                  return const WeatherStateWidget(
                    message: 'Search a city for weather!',
                  );
                case WeatherStatus.loading:
                  return WeatherStateWidget(
                    message: 
                      'Loading Weather for ${state.searchLocation?.title}',
                    isLoading: true,
                  );
                case WeatherStatus.success:
                  if (state.weather == null) {
                    return const WeatherStateWidget(message: 'Try refreshing!');
                  }
                  return WeatherWidget(
                    weather: state.weather!,
                    forecast: state.forecast ?? [],
                    onRefresh: () => context.read<WeatherCubit>().refresh(),
                  );
                case WeatherStatus.failure:
                  return const WeatherStateWidget(
                    message: 'Something went wrong!',
                  );
              }
            },
          ),
        ),
      ),
    );
  }
  
}
