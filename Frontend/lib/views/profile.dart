import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:ho_pla/util/ho_pla_scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  bool darkMode = true;

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(child: Builder(
      builder: (context) {
        return HoPlaScaffold(
            "Profile",
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
                          onChanged: (newValue) {
                            setState(() {
                              darkMode = newValue ?? darkMode;
                            });
                            save();
                            ThemeSwitcher.of(context).changeTheme(
                                theme: darkMode
                                    ? ThemeData.dark()
                                    : ThemeData.light());
                          },
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

  void save() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkmode', darkMode);
  }
}
