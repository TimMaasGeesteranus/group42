import 'package:json_annotation/json_annotation.dart';

import 'hopla_user.dart';
import 'item.dart';

part 'reservation.g.dart';

@JsonSerializable()
class Reservation {
  int id;
  @JsonKey(
    toJson: _toJson,
    fromJson: _fromJson,
  )
  User user;
  Item item;
  DateTime startTime;
  DateTime endTime;

  Reservation({
    required this.id,
    required this.user,
    required this.item,
    required this.startTime,
    required this.endTime,
  });

  static Map<String, dynamic> _toJson(User u) => u.toJson();

  static User _fromJson(Map<String, dynamic> value) => User.fromJson(value);

  factory Reservation.fromJson(Map<String, dynamic> json) =>
      _$ReservationFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationToJson(this);
}
