import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ho_pla/model/house.dart';
import 'package:ho_pla/model/house_change_notifier.dart';
import 'package:ho_pla/util/backend.dart';
import 'package:ho_pla/util/current_user.dart';
import 'package:ho_pla/util/device_preview.dart';
import 'package:ho_pla/util/ho_pla_scaffold.dart';
import 'package:ho_pla/views/add_device.dart';
import 'package:ho_pla/views/my_house.dart';
import 'package:provider/provider.dart';

class DevicesOverviewWidget extends StatefulWidget {
  final String houseId;

  const DevicesOverviewWidget(this.houseId, {super.key});

  @override
  State<DevicesOverviewWidget> createState() => _DevicesOverviewWidgetState();
}

class _DevicesOverviewWidgetState extends State<DevicesOverviewWidget> {
  late Future<House> loadHouseFuture;

  @override
  Widget build(BuildContext context) {
    return HoPlaScaffold(
        "Device overview",
        FutureBuilder<House>(
          builder: (context, snap) {
            if (snap.hasData) {
              return buildOverview(snap.data!);
            } else if (!snap.hasError) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Center(
                child: Text(snap.error.toString()),
              );
            }
          },
          future: loadHouseFuture,
        ));
  }

  Widget buildOverview(House house) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => HouseChangeNotifier(house),
      child: Consumer<HouseChangeNotifier>(
        builder: (context, notifier, child) => Column(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Text("House name ${notifier.house.name}"),
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
                itemCount: (notifier.house.items.length) + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index < notifier.house.items.length) {
                    return DevicePreviewWidget(notifier.house.items[index],
                        AssetImage(notifier.house.items[index].image));
                  } else {
                    // Create card that allows the user to create a new device here
                    return const AddDeviceWidget();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void onInformationButtonClicked() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const MyHouseWidget()));
  }

  @override
  void initState() {
    super.initState();
    loadHouseFuture = Backend.getHouseById(CurrentUser.houseId).then((res) {
      if (res.statusCode == 200) {
        debugPrint("Return${res.body}");
        var json = jsonDecode(res.body);

        return House.fromJson(jsonDecode(res.body));
      } else {
        throw Exception(res.body);
      }
    });
  }
}
