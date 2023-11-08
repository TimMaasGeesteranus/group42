import 'package:flutter/material.dart';
import 'package:ho_pla/util/ho_pla_scaffold.dart';

class JoinHouseWidget extends StatelessWidget {
  const JoinHouseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return HoPlaScaffold(
        "Join an existing house!",
        Column(children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                  decoration:
                      InputDecoration(hintText: 'Enter house code here'))),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: ElevatedButton(
                onPressed: () {
                  // do something
                },
                  child: const Text('Join House'))),
        ]));
  }
}
