import 'package:flutter/material.dart';

class UpdateReservationWidget extends StatefulWidget {
  final Function(DateTime startTime, DateTime endTime) onConfirm;
  final Function() onDelete;

  const UpdateReservationWidget({
    Key? key,
    required this.onConfirm,
    required this.onDelete,
  }) : super(key: key);

  @override
  _UpdateReservationWidgetState createState() => _UpdateReservationWidgetState();
}

class _UpdateReservationWidgetState extends State<UpdateReservationWidget> {
  late TimeOfDay selectedStartTime;
  late TimeOfDay selectedEndTime;

  @override
  void initState() {
    super.initState();
    selectedStartTime = TimeOfDay.now();
    selectedEndTime = TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 1)));
  }

  Future<void> _selectStartTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedStartTime,
    );

    if (picked != null && picked != selectedStartTime) {
      setState(() {
        selectedStartTime = picked;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedEndTime,
    );

    if (picked != null && picked != selectedEndTime) {
      setState(() {
        selectedEndTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Reservation'),
      content: Column(
        children: [
          Row(
            children: [
              const Text('Start Time:'),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _selectStartTime(context),
                child: Text(selectedStartTime.format(context)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('End Time:'),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _selectEndTime(context),
                child: Text(selectedEndTime.format(context)),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cancel button
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            DateTime startDateTime = DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              selectedStartTime.hour,
              selectedStartTime.minute,
            );
            DateTime endDateTime = DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              selectedEndTime.hour,
              selectedEndTime.minute,
            );
            widget.onConfirm(startDateTime, endDateTime);
            Navigator.of(context).pop(); // Confirm button
          },
          child: const Text('Update'),
        ),
        TextButton(
          onPressed: () {
            widget.onDelete();
            Navigator.of(context).pop(); // Delete button
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
