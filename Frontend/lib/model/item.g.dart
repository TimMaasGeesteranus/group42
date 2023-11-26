// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      id: json['id'] as int,
      name: json['name'] as String,
      reservations: (json['reservations'] as List<dynamic>?)
          ?.map((e) => Reservation.fromJson(e as Map<String, dynamic>))
          .toList(),
      image: json['image'] as String,
      qrcode: json['qrcode'] as String?,
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'reservations': instance.reservations,
      'image': instance.image,
      'qrcode': instance.qrcode,
    };
