import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:ho_pla/util/ho_pla_scaffold.dart';
import 'package:ho_pla/util/ho_pla_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({super.key});

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  bool darkMode = true;

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(child: Builder(
      builder: (context) {
        return HoPlaScaffold(
            "Settings",
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
              child: Column(
                children: [
                  const Icon(
                    Icons.person,
                    size: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 10),
                    child: Container(
                      color: Theme.of(context).cardColor,
                      child: ThemeSwitcher(builder: (context) {
                        return CheckboxListTile(
                          value: darkMode,
                          onChanged: (x) => switchTheme(context, x),
                          title: const Text("Dark mode"),
                        );
                      }),
                    ),
                  )
                ],
              ),
            ));
      },
    ));
  }

  void switchTheme(BuildContext context, bool? newValue) {
    setState(() {
      darkMode = newValue ?? darkMode;
    });
    save();
    ThemeSwitcher.of(context)
        .changeTheme(theme: darkMode ? customDarkTheme : ThemeData.light());
  }

  void save() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkmode', darkMode);
  }
}
