import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final int houseid = 420;

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
                  const Text("House id"),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Text("#\t$houseid" ), //TODO insert houseid here
                    IconButton(onPressed: OnCopyClicked, icon: const Icon(Icons.copy))
                  ],),
                  const SizedBox(height: SIZEDBOXHEIGHT,),
                  Text("${usernames.length} members"),
                  const Divider(),
                  ListView.separated(
                    padding: const EdgeInsets.all(8),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onLongPress: OnLongPressMember,
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

  OnCopyClicked() async {
    await Clipboard.setData(ClipboardData(text: houseid.toString()));
  }

  OnLongPressMember() {
    return;
  }
}
