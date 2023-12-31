import 'dart:convert';

import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:ho_pla/model/reservation.dart';
import 'package:ho_pla/util/backend.dart';
import 'package:ho_pla/util/current_user.dart';
import 'package:ho_pla/util/duration_util.dart';
import 'package:ho_pla/util/widget_with_role.dart';
import 'package:ho_pla/views/qr_code.dart';
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
  Duration defaultDuration = const Duration(hours: 1);
  CalendarController calendarController = CalendarController();

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    children: [
                      WidgetWithRole(
                        child: TextButton(
                            onPressed: onMessageButtonClicked,
                            child: const Text("Notify last user")),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      WidgetWithRole(
                        child: TextButton(
                            onPressed: onQrCodeGenerationClicked,
                            child: const Text("Generate QR Code")),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      TextButton(
                          onPressed: changeDefaultDuration,
                          child: Text(
                              "Change duration: ${durationToHoursMinutes(defaultDuration)}")),
                      const SizedBox(
                        width: 10,
                      ),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              calendarController.view =
                                  (calendarController.view == CalendarView.week
                                      ? CalendarView.day
                                      : CalendarView.week);
                            });
                          },
                          child: const Text("Toggle view")),
                    ],
                  ),
                  Expanded(
                    child: SfCalendar(
                      controller: calendarController,
                      view: CalendarView.week,
                      onTap: _onTap,
                      dataSource: source,
                      onLongPress: _onLongPress,
                    ),
                  ),

                  TextButton(
                      onPressed: onDeleteButtonClicked,
                      child: Text(
                          "Delete item")),

                ],
              );
            }
          },
        ));
  }

  void onDeleteButtonClicked() async { //TODO create deleteButton and get itemId
    String itemId = widget.item.id.toString();

      try {
        debugPrint("tyring");
        var res = await Backend.deleteDevice(itemId);

        if (res.statusCode == 204) {
          debugPrint("Item successfully deleted");
          Navigator.pop(context); // Navigate back

          return;
        } else {
          debugPrint('Could not delete the item: status ${res.statusCode}');
        }
      } on Exception catch (e, _) {
        debugPrint('Error deleting the device. Try again later');
      }

  }

  void onQrCodeGenerationClicked() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return QrCodeWidget(widget.item);
    }));
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

  Future<bool> _updateReservation(
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

      return response.statusCode == 200;
    } catch (e) {
      // Handle errors
      debugPrint('Error updating reservation: $e');
      return false;
    }
  }

  Future<bool> _deleteReservation(String reservationId) async {
    try {
      final response =
          await Backend.deleteReservation(CurrentUser.id, reservationId);

      // Handle the response as needed
      debugPrint('Delete Reservation Response: ${response.statusCode}');

      return response.statusCode == 200;
    } catch (e) {
      // Handle errors
      debugPrint('Error deleting reservation: $e');
      return false;
    }
  }

  void _onLongPress(CalendarLongPressDetails details) {
    if (details.appointments != null && details.appointments!.isNotEmpty) {
      Appointment selectedAppointment = details.appointments![0];

      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return UpdateReservationWidget(
          onConfirm: (DateTime startTime, DateTime endTime) async {
            bool success = await _updateReservation(
                startTime, endTime, selectedAppointment.id.toString());

            if (success) {
              // Rather ugly reload as update is not possible
              fetchAppointmentsFuture = fetchAppointments();
              fetchAppointmentsFuture.then((value) => {setState(() {})});
            } else {
              showSnackBar("Could not update");
            }
          },
          onDelete: () async {
            var success =
                await _deleteReservation(selectedAppointment.id.toString());

            if (success) {
              source.appointments?.add(selectedAppointment);
              source.notifyListeners(
                  CalendarDataSourceAction.remove, [selectedAppointment]);
            } else {
              showSnackBar("Could not delete");
            }
          },
          formerStart: selectedAppointment.startTime,
          formerEnd: selectedAppointment.endTime,
        );
      }));
    }
  }

  void _onTap(CalendarTapDetails details) async {
    var app = Appointment(
      startTime: details.date!,
      endTime: details.date!.add(defaultDuration),
      subject: 'Reservation',
      color: Colors.blue,
    );

    var res = await Backend.addReservation(
        CurrentUser.id, widget.item.id.toString(), app);


    if (res.statusCode != 200) {
      debugPrint(
          "Error creating the reservation. Status code: ${res.statusCode} Body: ${res.body}");
      const snackBar =
          SnackBar(content: Text('Error creating the reservation'));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      debugPrint(res.body.toString());
      // Set id now
      app.id = res.body.split(" ")[1];

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

  void changeDefaultDuration() async {
    final resultingDuration = await showDurationPicker(
      context: context,
      initialTime: defaultDuration,
      baseUnit: BaseUnit.minute,
    );

    if (resultingDuration != null) {
      saveDefaultDuration(resultingDuration, widget.item.id);
      setState(() {
        defaultDuration = resultingDuration;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _setSavedDefaultDuration();
    fetchAppointmentsFuture = fetchAppointments();
  }

  void _setSavedDefaultDuration() async {
    Duration? savedDuration = await loadSavedDefaultDuration(widget.item.id);
    debugPrint("SavedDuration: $savedDuration");
    if (savedDuration != null) {
        setState(() {
          defaultDuration = savedDuration;
        });
    }
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
