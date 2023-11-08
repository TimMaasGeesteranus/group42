import 'package:flutter/material.dart';
import 'package:ho_pla/model/house_change_notifier.dart';
import 'package:ho_pla/model/item.dart';
import 'package:ho_pla/views/device_creation.dart';
import 'package:provider/provider.dart';

class AddDeviceWidget extends StatefulWidget {
  const AddDeviceWidget({super.key});

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

  onAddDeviceClicked() async {
    var provider = Provider.of<HouseChangeNotifier>(context, listen: false);
    Item device = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DeviceCreationWidget(provider),
        ));

    provider.house.items.add(device);
    provider.houseModified();
  }
}
