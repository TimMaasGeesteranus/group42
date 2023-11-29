import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/ho_pla_scaffold.dart';

class MyHouseWidget extends StatefulWidget {
  const MyHouseWidget({super.key});

  @override
  State<MyHouseWidget> createState() => _MyHouseWidgetState();
}

class _MyHouseWidgetState extends State<MyHouseWidget> {
  TextEditingController nameController = TextEditingController();

  final List<String> usernames = <String>['A', 'B', 'C']; //Dummy usernames
  static const double SIZEDBOXHEIGHT = 40;

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
                    //controller: nameController,
                    initialValue: "My Kingdom",
                    decoration: const InputDecoration(
                      labelText: "House Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: SIZEDBOXHEIGHT,),
                  const Text("House number"),
                  const Divider(),
                  const Text("#\t" "420"), //TODO insert houseid here
                  const SizedBox(height: SIZEDBOXHEIGHT,),
                  Text("${usernames.length} members"),
                  const Divider(),
                  ListView.separated(
                    padding: const EdgeInsets.all(8),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 50,
                        child: Center(child: Text(usernames[index])),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                    itemCount: usernames.length,
                  ),
                  ElevatedButton(
                    onPressed: OnLeaveClicked,
                    child: const Text('Leave House'),
                  )
                ])),
            floatingActionButton: FloatingActionButton(
              onPressed: OnSaveClicked,
              tooltip: 'Save changes',
              child: const Text("Save"),
            ),
          ),
        ));
  }

  OnLeaveClicked() {
    return;
  }

  OnSaveClicked() {
    return;
  }
}
