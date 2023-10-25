import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../util/ho_pla_scaffold.dart';

class ScheduleWidget extends StatefulWidget {
  const ScheduleWidget({super.key});

  @override
  State<ScheduleWidget> createState() => _ScheduleWidgetState();
}

class _ScheduleWidgetState extends State<ScheduleWidget> {
  ReservationsDataSource source = ReservationsDataSource();

  /// This future will complete with the reservations fetched from the backend.
  late Future<List<Appointment>> fetchReservationsFuture;

  @override
  Widget build(BuildContext context) {
    return HoPlaScaffold(
        "Overview",
        FutureBuilder<List<Appointment>>(
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
              );
            }
          },
        ));
  }

  void _onTap(CalendarTapDetails details) {
    // TODO: send request, error handling
    var app = Appointment(
      startTime: details.date!,
      endTime: details.date!.add(const Duration(minutes: 60)),
      subject: 'Reservation',
      color: Colors.blue,
    );

    source.appointments?.add(app);
    source.notifyListeners(CalendarDataSourceAction.add, [app]);
  }

  @override
  void initState() {
    fetchReservationsFuture = fetchReservations();
  }

  /// Async method that calls the backend
  Future<List<Appointment>> fetchReservations() async {
    // TODO: call backend here
    return [];
  }
}

/// Helper class needed for the plugin to function
class ReservationsDataSource extends CalendarDataSource {
  ReservationsDataSource();

  ReservationsDataSource.withSource(List<Appointment> source) {
    appointments = source;
  }
}
