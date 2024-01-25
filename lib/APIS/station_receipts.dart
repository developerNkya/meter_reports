import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

 fetchStationReceiptReport(String accessToken,String dateFrom,String dateTo) async {

   SharedPreferences prefs = await SharedPreferences.getInstance();
   var stationId = prefs.getString('stationId');
   var companyId = prefs.getString('company_id');



  var headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $accessToken',
    'Cookie':
    '_csrf-backend=d02273b7fb9811d2f426d7de25cf7a7c65aabcc1324b1f41a70d9a8e6a89fd32a%3A2%3A%7Bi%3A0%3Bs%3A13%3A%22_csrf-backend%22%3Bi%3A1%3Bs%3A32%3A%22YkgWgJNwFuG_6RFQL8EWge-jj1frtrWf%22%3B%7D'
  };

   var request = http.Request('POST', Uri.parse('http://67.217.56.19:8090/fummas_mobile/api/station-receipt-reports'));
   request.body = json.encode({
     "company_id": companyId,
     "station_id": stationId,
     "date_to": "$dateTo",
     "date_from": "$dateFrom",
     "pump": 0
   });

   // request.body = json.encode({
   //   "company_id": companyId,
   //   "station_id": stationId,
   //   "date_to": "2024-01-25",
   //   "date_from": "2024-01-23",
   //   "pump": 0
   // });

   request.headers.addAll(headers);

   http.StreamedResponse response = await request.send();

   if (response.statusCode == 200) {
     print('response::2000');
     // print(await response.stream.bytesToString());
         String stationReceipts= await response.stream.bytesToString();

    return stationReceipts;
   }
   else {
     print(response.reasonPhrase);
   }
}


