import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ho_pla/util/backend.dart';

// Do not add widget tests in the same file as this breaks for some reasons the
// backend tests
void main() {
  test('Register test', () async {
    var res = await Backend.register("test@test.de", "test", "12345678");
    debugPrint(res.statusCode.toString());
  });
}
