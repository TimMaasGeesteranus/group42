import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ho_pla/util/current_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/hopla_user.dart';
import 'backend.dart';

class WidgetWithRole extends StatefulWidget {
  const WidgetWithRole({super.key, required this.child});

  final Widget child;

  @override
  State<StatefulWidget> createState() => _WidgetWithRoleState();
}

class _WidgetWithRoleState extends State<WidgetWithRole> {
  bool get isAdmin => CurrentUser.hasPremium;

  static bool userPlanRetrieved = false;

  @override
  void initState() {
    retrieveUserPlan();
    super.initState();
  }

  retrieveUserPlan() async {
      if (!userPlanRetrieved) {
        if (CurrentUser.id == "") {
          print("getting user from preferences");
          final preferences = await SharedPreferences.getInstance();
          try {
            setState(() {
              CurrentUser.id = preferences.getString("userid")!;
              print("Just set id to ${CurrentUser.id}");
            });
          } on Error catch (e, _) {
            showError('Error retrieving the user id from the preferences');
          }
        }
        var res = await Backend.getUser(CurrentUser.id);
        if (res.statusCode == 200) {
          print("user yeeted from backend");
          User userById = User.fromJson(jsonDecode(res.body));
          setState(() {
            CurrentUser.hasPremium = userById.hasPremium;
          });
        }
        print(CurrentUser.id);
        userPlanRetrieved = true;
      }
      return;
  }


  @override
  Widget build(BuildContext context) {
    if (isAdmin) {
      return widget.child;
    }
    return Container();
  }

  void showError(String message) {
    var snackBar = SnackBar(content: Text(message));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
