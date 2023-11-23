import 'package:json_annotation/json_annotation.dart';

import 'hopla_user.dart';
import 'item.dart';

part 'house.g.dart';

@JsonSerializable()
class House {
  int id;
  String name;
  bool hasPremium;
  @JsonKey(
    toJson: _toJson,
    fromJson: _fromJson,
  )
  List<User> users;
  List<Item> items;

  House({
    required this.id,
    required this.name,
    required this.hasPremium,
    required this.users,
    required this.items,
  });

  static List<Map<String, dynamic>> _toJson(List<User> users) =>
      users.map((e) => e.toJson()).toList();

  static List<User> _fromJson(List<Map<String, dynamic>> values) =>
      values.map((v) => User.fromJson(v)).toList();

  factory House.fromJson(Map<String, dynamic> json) => _$HouseFromJson(json);

  Map<String, dynamic> toJson() => _$HouseToJson(this);
}
