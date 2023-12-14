import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ho_pla/model/reservation.dart';
import 'package:ho_pla/util/backend.dart';
import 'package:ho_pla/util/current_user.dart';
import 'package:ho_pla/views/update_reservation.dart';
import 'package:http/http.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../model/item.dart';
import '../util/ho_pla_scaffold.dart';

class ScheduleWidget extends StatefulWidget {
  final Item item;

  const ScheduleWidget(this.item, {super.key});

  @override
  State<ScheduleWidget> createState() => _ScheduleWidgetState();
}

class _ScheduleWidgetState extends State<ScheduleWidget> {
  ReservationsDataSource source = ReservationsDataSource();

  /// This future will complete with the reservations fetched from the backend.
  late Future<List<Appointment>?> fetchAppointmentsFuture;

  @override
  Widget build(BuildContext context) {
    return HoPlaScaffold(
        "Overview",
        FutureBuilder<List<Appointment>?>(
          future: fetchAppointmentsFuture,
          builder: (context, snap) {
            if (!snap.hasData && !snap.hasError) {
              // No data and no error => the request is still running
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snap.hasError) {
              return Center(
                child: Text(snap.error.toString()),
              );
            } else {
              // Data is now definitely present.
              source = ReservationsDataSource.withSource(snap.data ?? []);
              return Column(
                children: [
                  Row(
                    children: [
                      TextButton(
                          onPressed: onMessageButtonClicked,
                          child: const Text("Notify last user"))
                    ],
                  ),
                  SfCalendar(
                    view: CalendarView.week,
                    onTap: _onTap,
                    dataSource: source,
                    onLongPress: _onLongPress,
                  ),
                ],
              );
            }
          },
        ));
  }

  void onMessageButtonClicked() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notify user?'),
          content: const Text(
              'This sends a notification to the user who last used the current device to release the device.'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                var lastReservation = await getLastReservation();
                if (lastReservation != null && lastReservation.user != null) {
                  var res = await Backend.sendMessage(
                      lastReservation.user!.id.toString(),
                      "Your reservation is over. Please free the ${widget.item.name}");
                  if (res.statusCode == 200) {
                    debugPrint("Successfully sent notification");
                    showSnackBar("Successful");
                    Navigator.of(context).pop();
                    return;
                  } else {
                    debugPrint("Error sending message: ${res.statusCode}");
                    Navigator.of(context).pop();
                    return;
                  }
                } else {
                  debugPrint("No last reservation found");
                  Navigator.of(context).pop();
                  return;
                }
                showSnackBar("Message could not be sent.");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<Reservation?> getLastReservation() async {
    var reservations = await fetchReservations();

    reservations?.sort((a, b) => b.startTime.compareTo(a.startTime));

    Reservation? previousReservation;

    DateTime now = DateTime.now();

    if (reservations != null) {
      for (int i = 0; i < reservations.length; i++) {
        if (now.isAfter(reservations[i].startTime)) {
          previousReservation = reservations[i];
          break;
        }
      }
    }
    return previousReservation;
  }

  void _updateReservation(
      DateTime startTime, DateTime endTime, String reservationId) async {
    try {
      Appointment reservation = Appointment(
        startTime: startTime,
        endTime: endTime,
      );

      final response = await Backend.updateReservation(
          CurrentUser.id, reservationId, reservation);

      // Handle the response as needed
      debugPrint('Update Reservation Response: ${response.statusCode}');
    } catch (e) {
      // Handle errors
      debugPrint('Error updating reservation: $e');
    }
  }

  void _deleteReservation(String reservationId) async {
    try {
      final response =
          await Backend.deleteReservation(CurrentUser.id, reservationId);

      // Handle the response as needed
      debugPrint('Delete Reservation Response: ${response.statusCode}');
    } catch (e) {
      // Handle errors
      debugPrint('Error deleting reservation: $e');
    }
  }

  void _onLongPress(CalendarLongPressDetails details) {
    if (details.appointments != null && details.appointments!.isNotEmpty) {
      Appointment selectedAppointment = details.appointments![0];

      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return UpdateReservationWidget(
          onConfirm: (DateTime startTime, DateTime endTime) {
            _updateReservation(startTime, endTime, selectedAppointment.subject);
          },
          onDelete: () {
            _deleteReservation(selectedAppointment.subject);

            source.appointments?.add(selectedAppointment);
            source.notifyListeners(
                CalendarDataSourceAction.remove, [selectedAppointment]);
          },
        );
      }));
    }
  }

  void _onTap(CalendarTapDetails details) async {
    var app = Appointment(
      startTime: details.date!,
      endTime: details.date!.add(const Duration(minutes: 60)),
      subject: 'Reservation',
      color: Colors.blue,
    );

    var res = await Backend.addReservation(
        CurrentUser.id, widget.item.id.toString(), app);

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.

    if (res.statusCode != 200) {
      debugPrint(
          "Error creating the reservation. Status code: ${res.statusCode} Body: ${res.body}");
      const snackBar =
          SnackBar(content: Text('Error creating the reservation'));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      const snackBar = SnackBar(content: Text('Successful!'));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      source.appointments?.add(app);
      source.notifyListeners(CalendarDataSourceAction.add, [app]);
    }
  }

  void showSnackBar(String message) {
    var snackBar = SnackBar(content: Text(message));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAppointmentsFuture = fetchAppointments();
  }

  /// Async method that calls the backend
  Future<List<Appointment>?> fetchAppointments() async {
    var reservations = await fetchReservations();

    List<Appointment>? appointments = reservations
        ?.map((e) => Appointment(
            id: e.id,
            startTime: e.startTime,
            endTime: e.endTime,
            subject: e.user?.name ?? e.id.toString()))
        .toList();

    if (appointments == null) {
      return [];
    }

    return appointments;
  }

  Future<List<Reservation>?> fetchReservations() async {
    Response response = await Backend.getItemByItem(widget.item.id.toString());

    if (response.statusCode != 200) {
      debugPrint("Error: response status code != 200: ${response.statusCode}");
      return [];
    }

    Item? item =
        response.body != "" ? Item.fromJson(jsonDecode(response.body)) : null;
    return item?.reservations;
  }
}

/// Helper class needed for the plugin to function
class ReservationsDataSource extends CalendarDataSource {
  ReservationsDataSource();

  ReservationsDataSource.withSource(List<Appointment> source) {
    appointments = source;
  }
}
