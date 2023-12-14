import 'package:json_annotation/json_annotation.dart';

import 'house.dart';

part 'hopla_user.g.dart';

@JsonSerializable()
class User {
  int id;
  String email;
  String name;
  String password;
  bool hasPremium;
  House? house;
  String? firebaseId;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.password,
    required this.hasPremium,
    this.house,
    this.firebaseId,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
