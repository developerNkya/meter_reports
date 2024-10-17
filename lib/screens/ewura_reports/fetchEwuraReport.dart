import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
Future<Map<String, dynamic>> fetchEwuraReport(String accessToken, DateTime startMonth, DateTime endMonth) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var stationId = prefs.getString('stationId');
  var companyId = prefs.getString('company_id');
  String dateFrom = "${startMonth.year}-${startMonth.month.toString().padLeft(2, '0')}-01 00:00:00";
  String dateTo = "${endMonth.year}-${endMonth.month.toString().padLeft(2, '0')}-${DateTime(endMonth.year, endMonth.month + 1, 0).day} 23:59:59";

  var headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $accessToken',
  };

  var request = http.Request('POST', Uri.parse('http://67.217.56.19:8090/fummas_mobile/api/station-receipt-reports'));
  request.body = json.encode({
    "company_id": companyId,
    "station_id": stationId,
    "date_from": dateFrom,
    "date_to": dateTo,
    "pump": 0
  });

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    String stationReceipts = await response.stream.bytesToString();
    Map<String, dynamic> jsonResponse = json.decode(stationReceipts);

    double totalVolume = 0.0;
    double volumeUnleaded = 0.0;
    double volumeDiesel = 0.0;
    double volumeKerosene = 0.0;

    for (var receipt in jsonResponse['data']) {
      totalVolume += double.tryParse(receipt['AMOUNT']) ?? 0.0;

      if (receipt['FUEL_GRADE'] == 'UNLEADED') {
        volumeUnleaded += double.tryParse(receipt['AMOUNT']) ?? 0.0;
      } else if (receipt['FUEL_GRADE'] == 'DIESEL') {
        volumeDiesel += double.tryParse(receipt['AMOUNT']) ?? 0.0;
      } else if (receipt['FUEL_GRADE'] == 'KEROSENE') {
        volumeKerosene += double.tryParse(receipt['AMOUNT']) ?? 0.0;
      }
    }

    // Return the results
    return {
      'totalVolume': totalVolume,
      'volumeUnleaded': volumeUnleaded,
      'volumeDiesel': volumeDiesel,
      'volumeKerosene': volumeKerosene,
      'status': jsonResponse['status'],
      'message': jsonResponse['message'],
    };
  } else {
    print(response.reasonPhrase);
    return {'status': response.statusCode, 'message': response.reasonPhrase};
  }
}
