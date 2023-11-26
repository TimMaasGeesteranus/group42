// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reservation _$ReservationFromJson(Map<String, dynamic> json) => Reservation(
      id: json['id'] as int,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
    );

Map<String, dynamic> _$ReservationToJson(Reservation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
    };
