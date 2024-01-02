import 'package:shared_preferences/shared_preferences.dart';

String durationToHoursMinutes(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }

  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitHours = twoDigits(duration.inHours);

  return '$twoDigitHours:$twoDigitMinutes';
}

Duration parseHoursMinutes(String input) {
  List<String> parts = input.split(':');

  if (parts.length != 2) {
    throw FormatException('Invalid input format');
  }

  try {
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);

    return Duration(hours: hours, minutes: minutes);
  } catch (e) {
    throw FormatException('Invalid input format');
  }
}

Future<Duration?> loadSavedDefaultDuration(int itemId) async {
  final pref = await SharedPreferences.getInstance();
  String? stringDuration = pref.getString("defaultDurationOfDevice${itemId}");

  if (stringDuration != null) {
    Duration savedDuration = parseHoursMinutes(stringDuration);
    return savedDuration;
  }

  return null;
}
