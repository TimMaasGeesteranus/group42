import 'package:flutter/cupertino.dart';

import 'house.dart';

class HouseChangeNotifier extends ChangeNotifier {
  final House house;

  HouseChangeNotifier(this.house);

  void houseModified() {
    notifyListeners();
  }

  House getHouse() {
    return house;
  }
}
