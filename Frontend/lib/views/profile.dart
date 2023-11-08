import 'package:flutter/material.dart';
import 'package:ho_pla/util/ho_pla_scaffold.dart';
import 'package:ho_pla/views/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  late final SharedPreferences preferences;

  @override
  Widget build(BuildContext context) {
    return HoPlaScaffold(
        "Profile",
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: ListView(
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
                    fillColor: Theme.of(context)
                        .cardColor, // Set the background color here
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
                    fillColor: Theme.of(context)
                        .cardColor, // Set the background color here
                    hintText: 'Email',
                  ),
                  controller: _emailTextController,
                ),
              ),
              Container(
                width: double.infinity,
                margin:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: TextButton(
                    onPressed: onClickSettings, child: const Text("Settings")),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: TextButton(
                    onPressed: onClickPremium,
                    child: const Text("Go Premium!")),
              ),
              //const Spacer(),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(
                    bottom: 20, left: 30, right: 30, top: 60),
                child: TextButton(
                    onPressed: onClickSave, child: const Text("Save")),
              ),
            ],
          ),
        ));
  }

  void onClickSettings() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const SettingsWidget();
    }));
  }

  void onClickPremium() {
    // TODO: premium
  }

  void onClickSave() {
    // TODO: update backend
    preferences.setString("name", _nameTextController.text);
    preferences.setString("email", _emailTextController.text);
  }

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  void loadPreferences() async {
    preferences = await SharedPreferences.getInstance();
    _nameTextController.text = preferences.getString("name") ?? "";
    _emailTextController.text = preferences.getString("email") ?? "";
  }
}
