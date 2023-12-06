import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/house.dart';
import '../util/backend.dart';
import '../util/ho_pla_scaffold.dart';
import 'devices_overview.dart';

class MyHouseWidget extends StatefulWidget {
  const MyHouseWidget({super.key});

  @override
  State<MyHouseWidget> createState() => _MyHouseWidgetState();
}

class _MyHouseWidgetState extends State<MyHouseWidget> {
  TextEditingController nameController = TextEditingController();

  final List<String> usernames = <String>['A', 'B', 'C']; //Dummy usernames
  String houseid = '';
  House? currenthouse;

  static const double SIZEDBOXHEIGHT = 40;

  @override
    void initState() {
    super.initState();
    _getHouseClass();
  }

  @override
  Widget build(BuildContext context) {
    return HoPlaScaffold(
        "Your House",
        Container(
          padding: const EdgeInsets.all(8),
          color: Theme.of(context).cardColor,
          child: Scaffold(
            body: Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                  TextFormField(
                    controller: nameController,
                    initialValue: "My Kingdom",
                    decoration: const InputDecoration(
                      labelText: "House Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: SIZEDBOXHEIGHT,),
                  const Text("House ID"),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Text("#\t$houseid" ), //TODO insert houseid here
                    IconButton(onPressed: onCopyClicked, icon: const Icon(Icons.copy))
                  ],),
                  const SizedBox(height: SIZEDBOXHEIGHT,),
                  Text("${usernames.length} members"),
                  const Divider(),
                  ListView.separated(
                    padding: const EdgeInsets.all(8),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onLongPress: onLongPressMember,
                        child: PopupMenuButton(

                          itemBuilder: (context) {
                            return <PopupMenuItem>[const PopupMenuItem(child: Text("Delete"))];},
                          child: Container(
                            height: 50,
                            child: Center(child: Text(usernames[index])),
                        )));
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                    itemCount: usernames.length,
                  ),
                  ElevatedButton(
                    onPressed: onLeaveClicked,
                    child: const Text('Leave House'),
                  )
                ])),
            floatingActionButton: FloatingActionButton(
              onPressed: onSaveClicked,
              tooltip: 'Save changes',
              child: const Text("Save"),
            ),
          ),
        ));
  }

  _getHouseClass() async {
    final preferences = await SharedPreferences.getInstance();
    try {
      houseid = preferences.getString("houseid")!;

      var res = await Backend.getHouseById(
          houseid);
      if (res.statusCode == 201) {
        House currentHouse = House.fromJson(jsonDecode(res.body));
        currenthouse = currentHouse;

        return;
      } else {
        showError('Could not get the house from houseid: status ${res.statusCode}');
      }

    } on Error catch (e, _) {
      showError('No HouseID saved in the preferences');
    }

  }

  onLeaveClicked() {
    return;
  }

  onSaveClicked() async {
    try {
      if (nameController.text.isEmpty) {
        showError("House Name cannot be empty");
      }
      else {
        var res = await Backend.updateHouse(
            houseid, null); //TODO: Replace null with correct class

        if (res.statusCode == 201) {

          if (context.mounted) {
            // Return to device overview
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => DevicesOverviewWidget(houseid)));
          }

          return;
        } else {
          showError('Could not update the house: status ${res.statusCode}');
        }
      }
    } on Exception catch (e, _) {
      showError('Error updating the house');
    }
    return;
  }

  onCopyClicked() async {
    await Clipboard.setData(ClipboardData(text: houseid.toString()));
    showMessage("House ID copied to clipboard!");
  }

  onLongPressMember() {
    return;
  }

  void showMessage(String message) {
    var snackBar = SnackBar(content: Text(message));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void showError(String message) {
    var snackBar = SnackBar(content: Text(message));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
