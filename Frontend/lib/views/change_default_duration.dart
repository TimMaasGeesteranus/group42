import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:ho_pla/util/duration_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeDefaultDurationWidget extends StatefulWidget {
  final int itemId;

  const ChangeDefaultDurationWidget(this.itemId, {super.key});

  @override
  State<ChangeDefaultDurationWidget> createState() =>
      _ChangeDefaultDurationWidgetState();
}

class _ChangeDefaultDurationWidgetState
    extends State<ChangeDefaultDurationWidget> {
  Duration _selectedDuration = const Duration(hours: 1);

  @override
  void initState() {
    super.initState();

    _setSavedDefaultDuration();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change default reservation duration'),
      content: Column(
        children: [
          Row(
            children: [
              const Text('Duration:'),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _selectStartTime(context),
                child: Text(durationToHoursMinutes(_selectedDuration)),
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
          child: const Text('Return'),
        ),
      ],
    );
  }

  void _setSavedDefaultDuration() async {
    final savedDuration = await loadSavedDefaultDuration(widget.itemId);

    if (savedDuration != null) {
      if (!mounted) {
        _selectedDuration = savedDuration;
      } else {
        setState(() {
          _selectedDuration = savedDuration;
        });
      }
    }
  }

  void saveDefaultDuration(Duration toSave) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString("defaultDurationOfDevice${widget.itemId}",
        durationToHoursMinutes(toSave));
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final resultingDuration = await showDurationPicker(
      context: context,
      initialTime: const Duration(hours: 1),
      baseUnit: BaseUnit.minute,
    );

    if (resultingDuration != null) {
      saveDefaultDuration(resultingDuration);
      setState(() {
        _selectedDuration = resultingDuration;
      });
    }
  }
}
