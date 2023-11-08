import 'User.dart';
import 'item.dart';

class Reservation {
  int id;
  User user;
  Item item;
  DateTime startTime;
  DateTime endTime;

  Reservation({
    required this.id,
    required this.user,
    required this.item,
    required this.startTime,
    required this.endTime,
  });
}
