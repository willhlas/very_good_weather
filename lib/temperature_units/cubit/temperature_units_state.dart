part of 'temperature_units_cubit.dart';

enum TemperatureUnitsType { fahrenheit, celsius }

@JsonSerializable()
class TemperatureUnitsState extends Equatable {
  
  const TemperatureUnitsState({
    this.unitsType = TemperatureUnitsType.fahrenheit,
  });

  factory TemperatureUnitsState.fromJson(Map<String, dynamic> json) 
    => _$TemperatureUnitsStateFromJson(json);

  final TemperatureUnitsType unitsType;

  TemperatureUnitsState copyWith({
    TemperatureUnitsType? unitsType,
  }) => TemperatureUnitsState(
    unitsType: unitsType ?? this.unitsType,
  );

  Map<String, dynamic> toJson() => _$TemperatureUnitsStateToJson(this);

  @override
  List<Object?> get props => [unitsType];
   
}
