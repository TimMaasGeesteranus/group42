import 'package:flutter/material.dart';

import '../model/item.dart';
import '../views/schedule.dart';

class DevicePreviewWidget extends StatefulWidget {
  final AssetImage image;
  final Item item;

  const DevicePreviewWidget(this.item, this.image, {super.key});

  @override
  State<DevicePreviewWidget> createState() => _DevicePreviewWidgetState();
}

class _DevicePreviewWidgetState extends State<DevicePreviewWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        color: Theme.of(context).cardColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image(image: widget.image, fit: BoxFit.fill),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(widget.item.name),
            )
          ],
        ),
      ),
    );
  }

  void onTap() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ScheduleWidget(widget.item)));
  }
}
