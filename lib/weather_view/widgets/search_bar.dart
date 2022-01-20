import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_weather/temperature_units/temperature_units.dart';
import 'package:very_good_weather/weather_view/weather_view.dart';
import 'package:weather_icons/weather_icons.dart';

class SearchBar extends StatelessWidget {

  const SearchBar({
    Key? key,
    required this.state,
  }): super(key: key);

  final WeatherState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Visibility(
      visible: state.status != WeatherStatus.loading,
      child: AppBar(
        title: Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: state.location?.title,
                style: theme.textTheme.headline6,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'Search City',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (input) => EasyDebounce.debounce(
                  'search-debounce',
                  const Duration(milliseconds: 600),
                  () => context.read<WeatherCubit>().getLocation(input),
                ),
              ),
            ),
            Visibility(
              visible: state.isSearchingLocation,
              child: const SizedBox(
                height: 28,
                width: 28,
                child: CircularProgressIndicator(),
              ),
            ),
            Visibility(
              visible: !state.isSearchingLocation && 
                state.searchLocation != null &&
                state.searchLocation?.title != state.location?.title,
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: TextButton.icon(
                  key: const Key('searchButtonKey'),
                  onPressed: () {
                    context.read<WeatherCubit>().getWeather();
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: theme.primaryColorLight,
                  ),
                  icon: const Icon(Icons.search, size: 18),
                  label: Text('${state.searchLocation?.title}'),
                ),
              ),
            )
          ],
        ),
        actions: [
          IconButton(
            splashRadius: 16,
            onPressed: () => 
              context.read<TemperatureUnitsCubit>().changeUnits(),
            icon: BlocBuilder<TemperatureUnitsCubit, TemperatureUnitsState>(
              builder: (context, state) {
                return BoxedIcon(
                  state.unitsType != TemperatureUnitsType.celsius 
                    ? WeatherIcons.celsius
                    : WeatherIcons.fahrenheit,
                  color: theme.primaryColorDark,
                  size: 30,
                );
              },
            ),
          )
        ],
      ),
    );
  }
  
}
