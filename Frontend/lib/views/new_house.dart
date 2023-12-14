import 'dart:convert';

import 'package:flutter/gestures.dart';
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
  TextEditingController idController = TextEditingController();

  TextStyle defaultStyle = const TextStyle(color: Colors.black);
  TextStyle linkStyle = const TextStyle(color: Colors.blue);

  bool joinHouse = false;

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
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "House name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: onCreateClicked,
                  child: const Text('Create'),
                ),
                const SizedBox(
                  height: 40,
                ),
                const SizedBox(
                  height: 20,
                ),
                if (joinHouse)
                  getJoinWidget(),
                if (!joinHouse)
                  askJoinWidget(),


              ],
            )));
  }

  onCreateClicked() async {
    try {
      if (nameController.text.isEmpty) {
        showError("Name cannot be empty");
      } else {
        var res = await Backend.createHouse(int.parse(CurrentUser.id),
            nameController.text, false); //TODO: check premium of user

        if (res.statusCode == 201) {
          House newHouse = House.fromJson(jsonDecode(res.body));

          String houseId = newHouse.id.toString();

          final preferences = await SharedPreferences.getInstance();
          preferences.setString("houseid", houseId);
          CurrentUser.houseId = houseId;

          if (context.mounted) {
            // Return to device overview
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
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

  onJoinClicked() async {
    try {
      if (idController.text.isEmpty) {
        showError("Id cannot be empty");
      } else {
        String houseId = idController.text;
        var res = await Backend.joinHouse(CurrentUser.id,
            houseId);

        if (res.statusCode == 200) {

          final preferences = await SharedPreferences.getInstance();
          preferences.setString("houseid", houseId);
          CurrentUser.houseId = houseId;

          if (context.mounted) {
            // Return to device overview
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => DevicesOverviewWidget(houseId)));
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

  Widget askJoinWidget() {
    return RichText(
      text: TextSpan(
        style: defaultStyle,
        children: <TextSpan>[
          const TextSpan(text: 'Or '),
          TextSpan(
              text: 'join an already existing house',
              style: linkStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  setState(() {
                    joinHouse = true;
                  });
                }),
          const TextSpan(text: " by its House Id"),
        ],
      ),
    );
  }

  Widget getJoinWidget() {
    return Column(
      children: [
        TextField(
          controller: idController,
          decoration: const InputDecoration(
            labelText: "House Id",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: onJoinClicked,
          child: const Text('Join'),
        ),
      ],
    );
  }

  void showError(String message) {
    var snackBar = SnackBar(content: Text(message));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
