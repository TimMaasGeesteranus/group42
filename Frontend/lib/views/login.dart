import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:ho_pla/util/backend.dart';
import 'package:ho_pla/views/new_house.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<StatefulWidget> createState() => LoginWidgetState();
}

class LoginWidgetState extends State<LoginWidget> {
  Future<String?> _authUser(LoginData data) async {
    var res = await Backend.login(data.name, data.password);
    debugPrint("Login status: ${res.statusCode.toString()}");

    if (res.statusCode == 200) {
      Backend.saveAndSetUserIdByResponse(res);
      return null;
    } else {
      return "Error ${res.statusCode}. ${res.body}";
    }
  }

  /// Called on signup user. Returns the message fpr the user if not successful.
  /// Returning null means success.
  Future<String?> _signupUser(SignupData data) async {
    String? firebaseId = await FirebaseMessaging.instance.getToken();
    var res = await Backend.register(data.name!,
        data.additionalSignupData!["name"]!, data.password!, firebaseId);
    debugPrint("Register status: ${res.statusCode.toString()}");

    if (res.statusCode == 200) {
      Backend.saveAndSetUserIdByResponse(res);
      return null;
    } else {
      return "Error ${res.statusCode}. ${res.body}";
    }
  }

  Future<String?> _recoverPassword(String name) async {
    // TODO: login recover password logic
    return "This service is not available right now";
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'HoPla!',
      //logo: , // TODO: Set logo
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () {
        // After completion navigate to the next widget
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const NewHouseWidget(),
        ));
      },
      onRecoverPassword: _recoverPassword,
      userType: LoginUserType.email,
      additionalSignupFields: const [
        UserFormField(keyName: "name", displayName: "Name")
      ],
      messages: LoginMessages(
        additionalSignUpFormDescription:
        "This wil be the name that is displayed for others:",
      ),
    );
  }
}
