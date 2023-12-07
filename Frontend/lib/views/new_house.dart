import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ho_pla/util/current_user.dart';
import 'package:ho_pla/views/devices_overview.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/house.dart';
import '../util/backend.dart';
import '../util/ho_pla_scaffold.dart';

class NewHouseWidget extends StatefulWidget {
  const NewHouseWidget({super.key});

  @override
  State<NewHouseWidget> createState() => _NewHouseWidgetState();
}

class _NewHouseWidgetState extends State<NewHouseWidget> {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return HoPlaScaffold(
        "Create new House",
        Container(
            padding: const EdgeInsets.all(8),
            color: Theme.of(context).cardColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Give your new House a name"),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "House name",
                    border: OutlineInputBorder(),
                  ),
                ),
                ElevatedButton(
                  onPressed: onCreateClicked,
                  child: const Text('Create'),
                )
              ],
            )));
  }

  onCreateClicked() async {
    try {
      if (nameController.text.isEmpty) {
        showError("Name cannot be empty");
      }
      else {
        var res = await Backend.createHouse(
            int.parse(CurrentUser.id),nameController.text, false, 10); //TODO: Replace dummy values

        if (res.statusCode == 201) {
          House newHouse = House.fromJson(jsonDecode(res.body));

          String houseId = newHouse.id.toString();

          final preferences = await SharedPreferences.getInstance();
          preferences.setString("houseid", houseId);
          CurrentUser.houseId = houseId;

          if (context.mounted) {
            // Return to device overview
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => DevicesOverviewWidget(houseId)));
          }

          return;
        } else {
          showError('Could not create the house: status ${res.statusCode}');
        }
      }
    } on Exception catch (e, _) {
      showError('Error creating the house');
    }
  }

  void showError(String message) {
    var snackBar = SnackBar(content: Text(message));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
