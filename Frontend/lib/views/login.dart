import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:ho_pla/views/join_house.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<StatefulWidget> createState() => LoginWidgetState();
}

class LoginWidgetState extends State<LoginWidget> {
  Future<String?> _authUser(LoginData data) {
    // TODO: login auth logic
    throw UnimplementedError();
  }

  Future<String?> _signupUser(SignupData data) {
    // TODO: login register logic
    throw UnimplementedError();
  }

  Future<String?> _recoverPassword(String name) {
    // TODO: login recover password logic
    throw UnimplementedError();
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
          builder: (context) => const JoinHouseWidget(),
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
