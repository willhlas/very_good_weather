import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_weather/temperature_units/temperature_units.dart';

class Temperature extends StatelessWidget {

  const Temperature({
    Key? key,
    required this.value,
    required this.textStyle,
  }): super(key: key);

  final double value;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TemperatureUnitsCubit, TemperatureUnitsState>(
      builder: (context, state) {
        return Text(
          value.formattedUnit(state.unitsType),
          style: textStyle,
        );
      },
    );
  }
  
}

extension on double {
  String formattedUnit(TemperatureUnitsType unitsType) {
    if (unitsType == TemperatureUnitsType.fahrenheit) {
      final temp = (((this * 9 / 5) + 32).round()).toString();
      return '$temp°F';
    } else {
      return '${round()}°C';
    }
  }
}
