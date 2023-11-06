import 'package:flutter/material.dart';
import 'package:ho_pla/model/house.dart';
import 'package:ho_pla/util/device_preview.dart';
import 'package:ho_pla/util/ho_pla_scaffold.dart';
import 'package:ho_pla/views/add_device.dart';

class DevicesOverviewWidget extends StatefulWidget {
  final House house;

  const DevicesOverviewWidget(this.house, {super.key});

  @override
  State<DevicesOverviewWidget> createState() => _DevicesOverviewWidgetState();
}

class _DevicesOverviewWidgetState extends State<DevicesOverviewWidget> {
  @override
  Widget build(BuildContext context) {
    return HoPlaScaffold(
        "Device overview",
        Column(
          children: [
            Row(
              children: [
                Text(widget.house.name),
                const Spacer(),
                IconButton(
                    onPressed: onInformationButtonClicked,
                    icon: const Icon(Icons.info_outline))
              ],
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  //childAspectRatio: 0.8
                ),
                itemCount: (widget.house.items.length ?? 0) + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index < widget.house.items.length) {
                    // TODO: get actual image here
                    return DevicePreviewWidget(
                        const AssetImage("assets/icons/washing-machine.png"),
                        widget.house.items[index].name);
                  } else {
                    // Create card that allows the user to create a new device here
                    return AddDeviceWidget(widget.house);
                  }
                },
              ),
            )
          ],
        ));
  }

  void onInformationButtonClicked() {}
}
