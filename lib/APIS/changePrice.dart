
import 'dart:convert';

import 'package:grocery_app/screens/changePrice.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


changePrice2(String access_token,String unleaded,String diesel,String kerosene,String cng)async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var stationId = prefs.getString('stationId');
  var company_id = prefs.getString('company_id');
  var user_id = prefs.getString('user_id');


  var headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $access_token',
    'Cookie': '_csrf-backend=7f08107835f2ebb88e248dbd180fe198f38a86d2b7d3ff3231b1509813f9eed5a%3A2%3A%7Bi%3A0%3Bs%3A13%3A%22_csrf-backend%22%3Bi%3A1%3Bs%3A32%3A%22aiGhpQ8KlYTX2b0EG79DuQKwg0AqdQFV%22%3B%7D'
  };
  var request = http.Request('POST',
      Uri.parse('http://162.250.125.124:8090/fummas_mobile/api/change-price'));
  request.body = json.encode({
    "Fuelgrades": [
      {
        "price": "$unleaded",
        "name": "UNLEADED",
        "id": "1"
      },
      {
        "price": "$diesel",
        "name": "DIESEL",
        "id": "2"
      },
      {
        "price": "$kerosene",
        "name": "KEROSENE",
        "id": "3"
      },
      {
        "price": "$cng",
        "name": "CNG",
        "id": "4"
      }
    ],
    "station_id": stationId,
    "user_id": user_id
  });
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  }
  else {
    print(response.reasonPhrase);
  }
}