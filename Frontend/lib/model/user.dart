import 'house.dart';

class User {
  int id;
  String email;
  String name;
  String password;
  bool hasPremium;
  House? house;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.password,
    required this.hasPremium,
    this.house,
  });
}
