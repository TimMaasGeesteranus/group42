import 'package:flutter/material.dart';
import 'package:ho_pla/util/device_preview.dart';
import 'package:ho_pla/util/ho_pla_scaffold.dart';

class DevicesOverviewWidget extends StatefulWidget {
  const DevicesOverviewWidget({super.key});

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
                Text("Student House #1"),
                Spacer(),
                IconButton(
                    onPressed: onInformationButtonClicked,
                    icon: const Icon(Icons.info_outline))
              ],
            ),
            Expanded(
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  //childAspectRatio: 0.8
                ),
                children: [
                  DevicePreviewWidget(
                      AssetImage("assets/icons/washing-machine.png"),
                      "Washing machine #1"),
                  DevicePreviewWidget(
                      AssetImage("assets/icons/washing-machine.png"),
                      "Washing machine #1")
                ],
              ),
            )
          ],
        ));
  }

  void onInformationButtonClicked() {}
}
