import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ho_pla/model/hopla_user.dart';
import 'package:ho_pla/util/current_user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Backend {
  // Use alias for localhost
  static const String host = "http://34.245.145.71:80";

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

  static Future<http.Response> getHouseById(String houseId) {
    return http.get(
      Uri.parse('$host/House/$houseId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'accept': '*/*',
      },
    );
  }

  static Future<http.Response> getItemsByHouseId(String houseId) {
    return http.get(
      Uri.parse('$host/items/get_items_by_house_id/$houseId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'accept': '*/*',
      },
    );
  }

  static Future<http.Response> addReservation(
      String userId, String itemId, Appointment reservation) {
    final jsonData = {
      'StartTime': reservation.startTime,
      'EndTime': reservation.endTime,
    };

    return http.post(
      Uri.parse('$host/items/create-reservation/$userId/$itemId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'accept': '*/*',
      },
      body: json.encode(jsonData),
    );
  }

  static void saveAndSetUserIdByResponse(http.Response res) async {
    final Map<String, dynamic> responseData = json.decode(res.body);
    final String? userId = responseData['id']?.toString();

    if (userId != null) {
      final preferences = await SharedPreferences.getInstance();
      preferences.setString("userid", userId);
      CurrentUser.id = userId;
    } else {
      debugPrint("Error: did not receive a userId after OK 200 response.");
    }
  }

  static Future<http.Response> getUser(String userId) {
    // TODO: for this there exists not backend yet
    return http.get(
      Uri.parse('$host/users/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'accept': '*/*',
      },
    );
  }

  static Future<http.Response> changeUser(User changedUser) {
    return http.put(
      Uri.parse('$host/users/edit-user/${changedUser.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'accept': '*/*',
      },
      body: jsonEncode(changedUser),
    );
  }
}
