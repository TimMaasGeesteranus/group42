import 'package:json_annotation/json_annotation.dart';

import 'item.dart';

part 'house.g.dart';

@JsonSerializable()
class House {
  int id;
  String name;
  bool hasPremium;
  List<Item> items;

  House({
    required this.id,
    required this.name,
    required this.hasPremium,
    required this.items,
  });


  factory House.fromJson(Map<String, dynamic> json) => _$HouseFromJson(json);

  Map<String, dynamic> toJson() => _$HouseToJson(this);
}
