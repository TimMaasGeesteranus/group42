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

  @override
  Widget build(BuildContext context) {
    return HoPlaScaffold(
        "Overview",
        SfCalendar(
          view: CalendarView.week,
          onTap: _onTap,
          dataSource: source,
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
}

class ReservationsDataSource extends CalendarDataSource {
  _ReservationsDataSource(List<Appointment> source) {
    appointments = source;
  }
}
