import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ho_pla/util/current_user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../model/hopla_user.dart';
import '../model/item.dart';

import '../model/hopla_update_user.dart';

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

  static Future<http.Response> getItemByItem(String itemId) {
    return http.get(
      Uri.parse('$host/items/get_item_by_id/$itemId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'accept': '*/*',
      },
    );
  }

  static Future<http.Response> addReservation(
      String userId, String itemId, Appointment reservation) {
    final jsonData = {
      'StartTime': reservation.startTime.toIso8601String(),
      'EndTime': reservation.endTime.toIso8601String(),
    };

    return http.post(
      Uri.parse('$host/users/create-reservation/$userId/$itemId'),
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

  static Future<http.Response> createDevice(
      String name, String houseId, String image) {
    final jsonData = {
      'Name': name,
      'HouseId': houseId,
      'Image': image,
      'QrCode': null,
    };

    return http.post(
      Uri.parse('$host/items/create_item'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'accept': '*/*',
      },
      body: json.encode(jsonData),
    );
  }

  static Future<http.Response> createHouse(
      String name, bool hasPremium, int houseSize) {
    final jsonData = {
      'Name': name,
      'HasPremium' : hasPremium,
      'HouseSize' : houseSize
    };

    return http.post(
      Uri.parse('$host/house'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'accept': '*/*',
      },
      body: json.encode(jsonData),
    );
  }

  static Future<http.Response> joinHouse(
      String userId, String houseId){

    return http.post(
      Uri.parse('$host/users/assign-house/$userId/$houseId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'accept': '*/*',
      }
    );
  }

  static Future<http.Response> getUser(String userId) {
    return http.get(
      Uri.parse('$host/users/get_user_by_id/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'accept': '*/*',
      },
    );
  }

  static Future<http.Response> changeUser(
      String userId, UpdateUser changedUser) {
    return http.put(
      Uri.parse('$host/users/edit-user/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'accept': '*/*',
      },
      body: jsonEncode(changedUser),
    );
  }
}
