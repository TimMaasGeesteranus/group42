import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';

class UniLinks {
  static Future<void> initUniLinks() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final initialLink = await getInitialLink();
      debugPrint(initialLink);
    } on PlatformException {
      // Handle exception by warning the user their action did not succeed
      // return?
    }
  }
}
