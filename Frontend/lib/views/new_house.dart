import 'package:flutter/material.dart';

import '../util/ho_pla_scaffold.dart';

class NewHouseWidget extends StatefulWidget {
  const NewHouseWidget({super.key});

  @override
  State<NewHouseWidget> createState() => _NewHouseWidgetState();
}

class _NewHouseWidgetState extends State<NewHouseWidget> {
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
                const TextField(
                  decoration: InputDecoration(
                    labelText: "House name",
                    border: OutlineInputBorder(),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    print('Button Pressed');
                  },
                  child: const Text('Create new House'),
                )
              ],
            )));
  }
}
