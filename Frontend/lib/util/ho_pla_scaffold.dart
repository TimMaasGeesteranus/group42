import 'package:flutter/material.dart';
import 'package:ho_pla/views/profile.dart';

/// A basic scaffold. It only has a navigation button if a page can be popped.
/// Allows custom title and body.
class HoPlaScaffold extends StatelessWidget {
  final String title;
  final Widget body;

  const HoPlaScaffold(this.title, this.body, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
          // Only display the BackButton if the user can navigate back.
          leading: Navigator.of(context).canPop()
              ? const BackButton(color: Colors.black)
              : null,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.account_box,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileWidget()));
              },
            )
          ],
        ),
        body: body);
  }
}
