import 'User.dart';
import 'item.dart';

class House {
  int id;
  String name;
  bool hasPremium;
  List<User> users;
  List<Item> items;

  House({
    required this.id,
    required this.name,
    required this.hasPremium,
    required this.users,
    required this.items,
  });
}
