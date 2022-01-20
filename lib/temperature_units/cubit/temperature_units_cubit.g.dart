// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temperature_units_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TemperatureUnitsState _$TemperatureUnitsStateFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'TemperatureUnitsState',
      json,
      ($checkedConvert) {
        final val = TemperatureUnitsState(
          unitsType: $checkedConvert(
              'units_type',
              (v) =>
                  $enumDecodeNullable(_$TemperatureUnitsTypeEnumMap, v) ??
                  TemperatureUnitsType.fahrenheit),
        );
        return val;
      },
      fieldKeyMap: const {'unitsType': 'units_type'},
    );

Map<String, dynamic> _$TemperatureUnitsStateToJson(
        TemperatureUnitsState instance) =>
    <String, dynamic>{
      'units_type': _$TemperatureUnitsTypeEnumMap[instance.unitsType],
    };

const _$TemperatureUnitsTypeEnumMap = {
  TemperatureUnitsType.fahrenheit: 'fahrenheit',
  TemperatureUnitsType.celsius: 'celsius',
};
