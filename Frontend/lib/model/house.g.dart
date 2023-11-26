// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'house.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

House _$HouseFromJson(Map<String, dynamic> json) => House(
      id: json['id'] as int,
      name: json['name'] as String,
      hasPremium: json['hasPremium'] as bool,
      items: (json['items'] as List<dynamic>)
          .map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HouseToJson(House instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'hasPremium': instance.hasPremium,
      'items': instance.items,
    };
