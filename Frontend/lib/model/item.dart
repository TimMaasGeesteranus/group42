import 'package:json_annotation/json_annotation.dart';

import 'house.dart';
import 'reservation.dart';

part 'item.g.dart';

@JsonSerializable()
class Item {
  int id;
  String name;
  House house;
  List<Reservation> reservations;
  String image;

  Item({
    required this.id,
    required this.name,
    required this.house,
    required this.reservations,
    required this.image,
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
