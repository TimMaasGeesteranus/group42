import 'package:flutter/material.dart';
import 'package:ho_pla/util/ho_pla_scaffold.dart';
import 'package:ho_pla/views/my_house.dart';

import '../util/backend.dart';

class JoinHouseWidget extends StatefulWidget {
  const JoinHouseWidget({super.key});

  @override
  State<JoinHouseWidget> createState() => _JoinHouseWidgetState();
}

class _JoinHouseWidgetState extends State<JoinHouseWidget> {
  TextEditingController houseCodeController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return HoPlaScaffold(
        "Join an existing house!",
        Column(children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: houseCodeController,
                decoration: const InputDecoration(hintText: 'Enter house code here'))),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: ElevatedButton(
                onPressed: joinHouse,
                  child: const Text('Join House'))),
        ]));
  }

  joinHouse() async {
    var userId = "10"; //TODO: how to get userId?
    print("join");
    print(houseCodeController.text);

    try {
      if (houseCodeController.text.isEmpty) {
        showError("Name cannot be empty");
      }
      else {
        var res = await Backend.joinHouse(
            userId, houseCodeController.text);

        if (res.statusCode == 201) {
          print("we got statuscode 201");

          if (context.mounted) {
            // Return to device overview
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => const MyHouseWidget()));
          }

          return;
        } else {
          showError('Could not join the house: status ${res.statusCode}');
        }
      }
    } on Exception catch (e, _) {
      showError('Error joining the house');
    }
  }

  void showError(String message) {
    var snackBar = SnackBar(content: Text(message));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}

