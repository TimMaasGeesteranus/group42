import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ho_pla/util/backend.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:uni_links/uni_links.dart';

import '../main.dart';

class UniLinks {
  static Future<void> initUniLinks() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final initialLink = await getInitialLink();
      debugPrint(initialLink);

      if (initialLink != null) {
        var args = tryParseUrl(initialLink);

        if (args != null) {
          var success = await handleReservation(args[0], args[1]);

          if (success) {
            debugPrint("Reserved time slot via qr code");
            showMessageDialog("Reserved!");
            return;
          } else {
            showMessageDialog("Reservation not possible");
          }
        } else {
          showMessageDialog("Invalid QR Code");
        }
      }

      debugPrint("Could not reserve via qr code");
    } on PlatformException {
      showMessageDialog("Reservation not possible on this platform");
    }
  }

  static Future<bool> handleReservation(String userId, String deviceId) async {
    Appointment reservation = Appointment(
        startTime: DateTime.now(),
        endTime: DateTime.now().add(Duration(hours: 1)));
    var res = await Backend.addReservation(userId, deviceId, reservation);

    return res.statusCode == 200;
  }

  static void showMessageDialog(String message) {
    showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => Center(
              child: Material(
                color: Colors.transparent,
                child: Text(message),
              ),
            ));
  }

  /// Returns the parsed paths of the url, namely first the userId and second the deviceId
  static List<String>? tryParseUrl(String url) {
    try {
      url = url.replaceAll("hopla://localhost/", "");
      var split = url.split("/");

      if (split.length != 2) {
        debugPrint("Url parameter length != 2. Expected userId and deviceId");
        return null;
      }

      return split;
    } catch (e) {
      debugPrint("Error parsing url: $url");
      return null;
    }
  }
}
