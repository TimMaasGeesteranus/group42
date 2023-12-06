import 'dart:convert';

import 'package:flutter/material.dart';
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
  late Future<List<Appointment>?> fetchReservationsFuture;

  @override
  Widget build(BuildContext context) {
    return HoPlaScaffold(
        "Overview",
        FutureBuilder<List<Appointment>?>(
          future: fetchReservationsFuture,
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
              return SfCalendar(
                view: CalendarView.week,
                onTap: _onTap,
                dataSource: source,
                onLongPress: _onLongPress,
              );
            }
          },
        ));
  }

  void _updateReservation(DateTime startTime, DateTime endTime, String reservationId) async {
    try {
      Appointment reservation = Appointment(
        startTime: startTime,
        endTime: endTime,
      );

      final response = await Backend.updateReservation(CurrentUser.id, reservationId, reservation);

      // Handle the response as needed
      debugPrint('Update Reservation Response: ${response.statusCode}');
    } catch (e) {
      // Handle errors
      debugPrint('Error updating reservation: $e');
    }
  }


  void _deleteReservation(String reservationId) async {
    try {
      final response = await Backend.deleteReservation(CurrentUser.id, reservationId);

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
            source.notifyListeners(CalendarDataSourceAction.remove, [selectedAppointment]);
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

  @override
  void initState() {
    super.initState();
    fetchReservationsFuture = fetchReservations();
  }

  /// Async method that calls the backend
  Future<List<Appointment>?> fetchReservations() async {
    Response response = await Backend.getItemByItem(widget.item.id.toString());

    if (response.statusCode != 200) {
      debugPrint("Error: response status code != 200: ${response.statusCode}");
      return [];
    }

    Item? item =
        response.body != "" ? Item.fromJson(jsonDecode(response.body)) : null;
    List<Appointment>? appointments = item?.reservations
        ?.map((e) => Appointment(
            id: e.id,
            startTime: e.startTime,
            endTime: e.endTime,
            subject: e.id.toString()))
        .toList();

    if (appointments == null) {
      return [];
    }

    return appointments;
  }
}

/// Helper class needed for the plugin to function
class ReservationsDataSource extends CalendarDataSource {
  ReservationsDataSource();

  ReservationsDataSource.withSource(List<Appointment> source) {
    appointments = source;
  }
}
