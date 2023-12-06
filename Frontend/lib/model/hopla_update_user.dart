import 'package:json_annotation/json_annotation.dart';

part 'hopla_update_user.g.dart';

@JsonSerializable()
class UpdateUser {
  String email;
  String name;
  bool hasPremium;

  UpdateUser(
      {required this.email, required this.name, required this.hasPremium});

  factory UpdateUser.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateUserToJson(this);
}
