import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ho_pla/model/hopla_user.dart';
import 'package:ho_pla/util/backend.dart';
import 'package:ho_pla/util/current_user.dart';
import 'package:ho_pla/util/ho_pla_scaffold.dart';
import 'package:ho_pla/views/settings.dart';
import 'package:http/http.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  late Future<User?> loadingFuture;
  User? currentUser;

  @override
  Widget build(BuildContext context) {
    return HoPlaScaffold(
        "Profile",
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: FutureBuilder(
            future: loadingFuture,
            builder: (context, snap) {
              if (!snap.hasData && !snap.hasError) {
                // No data and no error => the request is still running
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snap.hasError) {
                return Center(
                  child: Text(snap.error.toString()),
                );
              } else {
                // Data is now definitely present.
                currentUser = snap.data!;
                return buildProfilePage(currentUser!);
              }
            },
          ),
        ));
  }

  Widget buildProfilePage(User currentUser) {
    return ListView(
      children: [
        const Icon(
          Icons.person,
          size: 100,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor:
                  Theme.of(context).cardColor, // Set the background color here
              hintText: 'Name',
            ),
            controller: _nameTextController,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor:
                  Theme.of(context).cardColor, // Set the background color here
              hintText: 'Email',
            ),
            controller: _emailTextController,
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: TextButton(
              onPressed: onClickSettings, child: const Text("Settings")),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: TextButton(
              onPressed: () => _premiumDialogBuilder(context),
              child: const Text("Go Premium!")),
        ),
        //const Spacer(),
        Container(
          width: double.infinity,
          margin:
              const EdgeInsets.only(bottom: 20, left: 30, right: 30, top: 60),
          child: TextButton(onPressed: onClickSave, child: const Text("Save")),
        ),
      ],
    );
  }

  void onClickSettings() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const SettingsWidget();
    }));
  }

  void onClickPremium() {
    // TODO: premium
  }

  Future<void> _premiumDialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Buy premium'),
          content: const Text(
              'Here will be the buy process of the premium subscription.\n'
              'However, this cannot be implemented yet.\n'
              'Press Enable to get premium for testing purposes.'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Enable'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void onClickSave() async {
    User? toChangeUser = currentUser;
    if (toChangeUser != null) {
      toChangeUser.name = _nameTextController.text;
      toChangeUser.email = _emailTextController.text;

      var res = await Backend.changeUser(toChangeUser);
      String message = res.statusCode == 200
          ? "Successfully changed"
          : "Error changing the user";

      var snackBar = SnackBar(content: Text(message));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      debugPrint("Current user is null. Cannot save.");
    }
  }

  @override
  void initState() {
    super.initState();
    loadingFuture = fetchUser();
  }

  Future<User?> fetchUser() async {
    Response response = await Backend.getHouseById(CurrentUser.id);

    if (response.statusCode != 200) {
      debugPrint("Error: response status code != 200: ${response.statusCode}");
      return null;
    }

    User user = jsonDecode(response.body);

    _nameTextController.text = user.name;
    _emailTextController.text = user.email;

    return user;
  }
}
