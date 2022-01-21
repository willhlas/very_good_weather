import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'temperature_units_cubit.g.dart';
part 'temperature_units_state.dart';

class TemperatureUnitsCubit extends HydratedCubit<TemperatureUnitsState> {

  TemperatureUnitsCubit(): super(const TemperatureUnitsState());

  void changeUnits() {
    if (state.unitsType == TemperatureUnitsType.celsius) {
      emit(state.copyWith(TemperatureUnitsType.fahrenheit));
    } else {
      emit(state.copyWith(TemperatureUnitsType.celsius));
    }
  }

  @override
  TemperatureUnitsState fromJson(Map<String, dynamic> json) =>
    TemperatureUnitsState.fromJson(json);

  @override
  Map<String, dynamic> toJson(TemperatureUnitsState state) =>
    state.toJson();
    
}
