import 'package:json_annotation/json_annotation.dart';

import 'reservation.dart';

part 'item.g.dart';

@JsonSerializable()
class Item {
  int id;
  String name;
  List<Reservation>? reservations;
  String image;
  String? qrcode;

  Item(
      {required this.id,
      required this.name,
      required this.reservations,
      required this.image,
      required this.qrcode});

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
