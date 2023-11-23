// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hopla_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int,
      email: json['email'] as String,
      name: json['name'] as String,
      password: json['password'] as String,
      hasPremium: json['hasPremium'] as bool,
      house: json['house'] == null
          ? null
          : House.fromJson(json['house'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'password': instance.password,
      'hasPremium': instance.hasPremium,
      'house': instance.house,
    };
