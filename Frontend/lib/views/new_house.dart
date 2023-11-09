import 'package:flutter/material.dart';

import '../util/ho_pla_scaffold.dart';

class NewHouseWidget extends StatelessWidget {
  const NewHouseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return HoPlaScaffold(
        "Create new House",
        Center(
            child: Column(
          children: [
            Text("Give your new House a name"),
            TextField(
              decoration: const InputDecoration(
                labelText: "House name",
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print('Button Pressed');
              },
              child: Text('Create new House'),
            )
          ],
        )));
  }
}
