import 'package:flutter/material.dart';
import 'package:ho_pla/model/house.dart';
import 'package:ho_pla/views/device_creation.dart';

class AddDeviceWidget extends StatefulWidget {
  final House house;

  const AddDeviceWidget(this.house, {super.key});

  @override
  State<AddDeviceWidget> createState() => _AddDeviceWidgetState();
}

class _AddDeviceWidgetState extends State<AddDeviceWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: IconButton(
              onPressed: onAddDeviceClicked,
              icon: const Icon(Icons.add),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text("New item"),
          )
        ],
      ),
    );
  }

  onAddDeviceClicked() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DeviceCreationWidget(widget.house)));
  }
}
