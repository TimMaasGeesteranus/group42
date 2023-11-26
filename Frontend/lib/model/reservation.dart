import 'package:json_annotation/json_annotation.dart';

import 'hopla_user.dart';

part 'reservation.g.dart';

@JsonSerializable()
class Reservation {
  int id;
  User? user;
  DateTime startTime;
  DateTime endTime;

  Reservation({
    required this.id,
    required this.user,
    required this.startTime,
    required this.endTime,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) =>
      _$ReservationFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationToJson(this);
}
