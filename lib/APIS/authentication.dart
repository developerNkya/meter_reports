//attain the bear token of entered credidentials::
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';



Future<String> authentication(String username, String password) async {

  var authJson = {"username": username, "password": password};
  var response = await post(Uri.parse('http://162.250.125.124:8090/fummas_mobile/api/login'),
      headers: {'Content-Type': 'application/json'}, body: jsonEncode(authJson));



    final responseJson = json.decode(response.body);

    //getting the values if response
    final accessToken = responseJson['access_token']['access_token'];



    return accessToken;

}
