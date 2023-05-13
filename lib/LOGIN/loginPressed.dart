import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

Future<String> login(String email, String password) async {
  var loginJson = {"username": email, "password": password};
  var response = await post(Uri.parse('http://162.250.125.124:8090/fummas_mobile/api/login'),
      headers: {'Content-Type': 'application/json'}, body: jsonEncode(loginJson));

  if (response.statusCode == 200) {

    final responseJson = json.decode(response.body);

    //getting the values if response
    final username = responseJson['username'];
    final accessToken = responseJson['access_token']['access_token'];
    final userId = responseJson['user_id'];

    //setting values into session::
    await FlutterSession().set('username', username);
    await FlutterSession().set('access_token', accessToken);
    await FlutterSession().set('user_id', userId);

    return 'Login success';
  } else {
    return 'Login failure';
  }
}
