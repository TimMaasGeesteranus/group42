// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'house.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

House _$HouseFromJson(Map<String, dynamic> json) => House(
      id: json['id'] as int,
      name: json['name'] as String,
      hasPremium: json['hasPremium'] as bool,
      users: House._fromJson(json['users'] as List<Map<String, dynamic>>),
      items: (json['items'] as List<dynamic>)
          .map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HouseToJson(House instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'hasPremium': instance.hasPremium,
      'users': House._toJson(instance.users),
      'items': instance.items,
    };
