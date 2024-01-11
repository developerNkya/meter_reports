import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



zReport(String access_token,String dateFrom,String dateTo) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var stationId = prefs.getString('stationId');
  var company_id = prefs.getString('company_id');


  var headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $access_token',
    'Cookie': '_csrf-backend=9bc22f332ad1d875ba27cb5a8a18b0d2d1ed350fbcf80c77ce7bd189d4bca79ea%3A2%3A%7Bi%3A0%3Bs%3A13%3A%22_csrf-backend%22%3Bi%3A1%3Bs%3A32%3A%2219qg02WbJwqsAkAdle2CHBkuvU_p4OAO%22%3B%7D'
  };

  var request = http.Request('POST', Uri.parse('http://67.217.56.19:8090/fummas_mobile/api/station-z-report'));
  request.body = json.encode({
    "company_id": company_id,
    "station_id": stationId,
    "date_from": "$dateFrom",
    "date_to": "$dateTo"
  });
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
      String zReport= await response.stream.bytesToString();
      return zReport;
  }
  else {
    print(response.reasonPhrase);
  }
}
