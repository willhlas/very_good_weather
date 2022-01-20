import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable()
class Location extends Equatable {

  const Location({
    required this.woeid,
    required this.title,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  final int woeid;
  final String title;

  Map<String, dynamic> toJson() => _$LocationToJson(this);

  @override
  List<Object?> get props => [woeid, title];
  
}
