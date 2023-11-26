// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hopla_update_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateUser _$UpdateUserFromJson(Map<String, dynamic> json) => UpdateUser(
      email: json['email'] as String,
      name: json['name'] as String,
      hasPremium: json['hasPremium'] as bool,
    );

Map<String, dynamic> _$UpdateUserToJson(UpdateUser instance) =>
    <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
      'hasPremium': instance.hasPremium,
    };
