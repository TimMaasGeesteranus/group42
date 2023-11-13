import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ho_pla/util/current_user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Backend {
  // Use alias for localhost
  static const String host = "http://192.168.0.100:7206";

  static Future<http.Response> register(
      String email, String name, String password) async {
    final jsonData = {
      'email': email,
      'name': name,
      'password': password,
    };

    return http.post(
      Uri.parse('$host/User/register'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'accept': '*/*',
      },
      body: json.encode(jsonData),
    );
  }

  static Future<http.Response> login(String email, String password) async {
    final jsonData = {
      'email': email,
      'password': password,
    };

    return http.post(
      Uri.parse('$host/User/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'accept': '*/*',
      },
      body: json.encode(jsonData),
    );
  }

  static void saveAndSetUserIdByResponse(http.Response res) async {
    final Map<String, dynamic> responseData = json.decode(res.body);
    final String? userId = responseData['id'];

    if (userId != null) {
      final preferences = await SharedPreferences.getInstance();
      preferences.setString("userid", userId);
      CurrentUser.id = userId;
    } else {
      debugPrint("Error: did not receive a userId after OK 200 response.");
    }
  }
}
