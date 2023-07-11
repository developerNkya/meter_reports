import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<String> authentication(String username, String password) async {
  var authJson = {"username": username, "password": password};
  var response = await http.post(
    Uri.parse('http://162.250.125.124:8090/fummas_mobile/api/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(authJson),
  );

  final responseJson = json.decode(response.body);

  // Getting the values from the response
  final accessToken = responseJson['access_token']['access_token'];

  // Store the access token using shared_preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('accessToken', accessToken);

  return accessToken;
}

Future<String?> getAccessToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('accessToken');
}

void main() async {
  // Example usage
  String accessToken = await authentication('username', 'password');
  print('Access Token: $accessToken');

  String? storedAccessToken = await getAccessToken();
  if (storedAccessToken != null) {
    print('Stored Access Token: $storedAccessToken');
  } else {
    print('No access token stored.');
  }
}
