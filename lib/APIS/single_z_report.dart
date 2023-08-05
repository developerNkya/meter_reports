import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SummaryObject {
  String from;
  String to;
  String name;
  String address;
  String tin;
  String vrn;
  String serial;
  String uin;
  String taxoffice;
  double totalAmountSum;
  int id;
  int length;
  String mobile;

  SummaryObject({
    required this.from,
    required this.to,
    required this.name,
    required this.address,
    required this.tin,
    required this.vrn,
    required this.serial,
    required this.uin,
    required this.taxoffice,
    required this.totalAmountSum,
    required this.id,
    required this.length,
    required this.mobile
  });

  // Define a method to convert the SummaryObject to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'from': from,
      'to': to,
      'name': name,
      'address': address,
      'tin': tin,
      'vrn': vrn,
      'serial': serial,
      'uin': uin,
      'taxoffice': taxoffice,
      'totalAmountSum': totalAmountSum,
      'id' : id,
      'length':length,
      'mobile': mobile
    };
  }
}

Future<String?> single_z(String access_token, String toDate,String z_id) async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var stationId = prefs.getString('stationId');
  var company_id = prefs.getString('company_id');


  var headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $access_token',
    'Cookie': '_csrf-backend=d02273b7fb9811d2f426d7de25cf7a7c65aabcc1324b1f41a70d9a8e6a89fd32a%3A2%3A%7Bi%3A0%3Bs%3A13%3A%22_csrf-backend%22%3Bi%3A1%3Bs%3A32%3A%22YkgWgJNwFuG_6RFQL8EWge-jj1frtrWf%22%3B%7D'
  };

  var request = http.Request(
    'POST',
    Uri.parse('http://162.250.125.124:8090/fummas_mobile/api/z-report'),
  );

  request.body = json.encode({
    "zreport_id":z_id
  });

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    String station_summary = await response.stream.bytesToString();

    return station_summary;

  }
}
