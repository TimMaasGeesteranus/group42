import 'house.dart';
import 'reservation.dart';

class Item {
  int id;
  String name;
  House house;
  List<Reservation> reservations;

  Item({
    required this.id,
    required this.name,
    required this.house,
    required this.reservations,
  });
}
