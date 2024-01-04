import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ho_pla/util/current_user.dart';
import 'package:ho_pla/views/new_house.dart';
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

  List<dynamic> users = [];
  String houseId = '';
  House? currentHouse;
  bool hasPremium = false;
  int houseSize = 0; //TODO add houseSize to the House model

  static const double SIZEDBOXHEIGHT = 40;

  @override
  void initState() {
    super.initState();
    _getHouseOfUser();
  }

  @override
  Widget build(BuildContext context) {
    return HoPlaScaffold(
        "Your House",
        Container(
          padding: const EdgeInsets.all(8),
          color: Theme.of(context).cardColor,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Center(
                child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "House Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: SIZEDBOXHEIGHT,
                    ),
                    const Text("House ID"),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("#\t$houseId"), //TODO insert houseid here
                        IconButton(
                            onPressed: onCopyClicked,
                            icon: const Icon(Icons.copy))
                      ],
                    ),
                    const SizedBox(
                      height: SIZEDBOXHEIGHT,
                    ),
                    const Text("Premium"),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (hasPremium) ...[
                          const Text("Activated"),
                          const Icon(Icons.grade),
                        ] else
                          const Text("Not Activated"),
                      ],
                    ),
                    const SizedBox(
                      height: SIZEDBOXHEIGHT,
                    ),
                    (users.length > 1)
                        ? Text("${users.length} members / $houseSize max")
                        : Text("${users.length} member  / $houseSize max"),
                    const Divider(),
                    ListView.separated(
                      padding: const EdgeInsets.all(8),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                            onLongPress: onLongPressMember,
                            child: PopupMenuButton(
                                itemBuilder: (context) {
                                  return <PopupMenuItem>[
                                    const PopupMenuItem(child: Text("Delete"))
                                  ];
                                },
                                child: Container(
                                  height: 50,
                                  child: Center(
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                        Text(users[index]['name']),
                                        if (users[index]['hasPremium'])
                                          const Icon(Icons.grade)
                                      ])),
                                )));
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      itemCount: users.length,
                    ),
                    const SizedBox(
                      height: SIZEDBOXHEIGHT * 1.3,
                    ),
                    ElevatedButton(
                        onPressed: onLeaveClicked,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade200),
                        child: const Text('Leave House')),
                  ]),
            )),
            floatingActionButton: FloatingActionButton(
              onPressed: onSaveClicked,
              tooltip: 'Save changes',
              child: const Text("Save"),
            ),
          ),
        ));
  }

  _getHouseOfUser() async {
    //TODO: Wait for completion of function before loading widget
    final preferences = await SharedPreferences.getInstance();
    try {
      setState(() {
        houseId = preferences.getString("houseid")!;
      });
      CurrentUser.houseId = houseId;

      var res = await Backend.getHouseById(houseId);
      if (res.statusCode == 200) {
        House houseById = House.fromJson(jsonDecode(res.body));

        setState(() {
          hasPremium = houseById.hasPremium;
          houseSize = houseById.houseSize;
        });

        currentHouse = houseById;
        nameController.text = currentHouse!.name;

        var resUsers = await Backend.getHouseUsers(houseId);

        if (resUsers.statusCode == 200) {
          setState(() {
            users = jsonDecode(resUsers.body);
          });

          // If any user hasPremium and the house is not Premium, update the hasPremium flag of the house
          if (!currentHouse!.hasPremium &&
              users.any((user) => user['hasPremium'])) {
            setState(() {
              hasPremium = true;
            });
            var res = await Backend.updateHouse(
                houseId, nameController.text, hasPremium, houseSize);
            if (res.statusCode == 200) {
              showMessage("Your house is now Premium!");
            } else {
              showError("Error activating Premium for the house");
            }
          }
        }
        return;
      } else {
        showError(
            'Could not get the house from houseid: status ${res.statusCode}');
      }
    } on Error catch (e, _) {
      showError('Error retrieving the House');
    }
  }

  onLeaveClicked() async {
    var res = await Backend.removeHouseFromUser(CurrentUser.id);

    if (res.statusCode == 200) {
      final preferences = await SharedPreferences.getInstance();
      preferences.remove("houseid");
      showMessage("Left house");
      if (context.mounted) {
        // Return to device overview
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const NewHouseWidget()),
            (Route<dynamic> route) => false);
      }
      return;
    } else {
      showError('Could not leave the house: status ${res.statusCode}');
    }
    return;
  }

  onSaveClicked() async {
    try {
      if (nameController.text.isEmpty) {
        showError("House Name cannot be empty");
      } else {
        var res = await Backend.updateHouse(
            houseId, nameController.text, hasPremium, houseSize);
        if (res.statusCode == 200) {
          if (context.mounted) {
            // Return to device overview
            showMessage("Changes saved!");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DevicesOverviewWidget(houseId)));
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
    await Clipboard.setData(ClipboardData(text: houseId.toString()));
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
