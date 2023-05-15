//attain the bear token of entered credidentials::
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';


//logic to extract user stations::::
class Station {
  final String name;

  Station({required this.name});
}

class ResponseData {
  final List<Station> stations;

  ResponseData({required this.stations});
}

ResponseData parseResponseData(String responseBody) {
  final parsed = json.decode(responseBody);
  final stations = (parsed['stations'] as List)
      .map((station) => Station(name: station['name'] as String))
      .toList();
  return ResponseData(stations: stations);
}

//logic to extract response::::
 userStations(String access_token, String user_id) async {

  var headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $access_token',
    'Cookie': '_csrf-backend=f923184428814c9e801d401fdf5c040ef3233838ddef16ce606986f3a05d2172a%3A2%3A%7Bi%3A0%3Bs%3A13%3A%22_csrf-backend%22%3Bi%3A1%3Bs%3A32%3A%22ZIgswJrY_69oAgf8PTdpAOA0zSKLkNIY%22%3B%7D'
  };
  var request = http.Request('POST', Uri.parse('http://162.250.125.124:8090/fummas_mobile/api/user-stations'));
  request.body = json.encode({
    "user_id": user_id
  });
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    // ResponseData responseData = parseResponseData(response as String);
    String stationData= await response.stream.bytesToString();

   return stationData;
  }
  else {
    print(response.reasonPhrase);
    return 'Invalid';
  }

}
