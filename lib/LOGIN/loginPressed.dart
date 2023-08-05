import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<String> login(String email, String password) async {
  var loginJson = {"username": email, "password": password};
  var response = await http.post(
    Uri.parse('http://162.250.125.124:8090/fummas_mobile/api/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(loginJson),
  );

  if (response.statusCode == 200) {
    final responseJson = json.decode(response.body);

    // Getting the values from the response
    final username = responseJson['username'];
    final accessToken = responseJson['access_token']['access_token'];
    final userId = responseJson['user_id'];
    final company_id = responseJson['company_id'];

    // Getting SharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Storing values in SharedPreferences
    await prefs.setString('username', username);
    await prefs.setString('access_token', accessToken);
    await prefs.setString('user_id', userId.toString());
    await prefs.setString('user_password', password);

    await prefs.setString('company_id',company_id.toString());

    return 'Login success';
  } else {
    return 'Login failure';
    // return response.body;
  }
}