import 'dart:convert';
import 'package:http/http.dart' as http;

retireve_summary(String access_token,String toDate) async {
  var headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $access_token',
    'Cookie':
    '_csrf-backend=d02273b7fb9811d2f426d7de25cf7a7c65aabcc1324b1f41a70d9a8e6a89fd32a%3A2%3A%7Bi%3A0%3Bs%3A13%3A%22_csrf-backend%22%3Bi%3A1%3Bs%3A32%3A%22YkgWgJNwFuG_6RFQL8EWge-jj1frtrWf%22%3B%7D'
  };

  var request = http.Request(
    'POST',
    Uri.parse('http://162.250.125.124:8090/fummas_mobile/api/station-receipt-report'),
  );

  request.body = json.encode({
    "company_id": 1,
    "station_id": 1,
    "date_from": "2021-10-11",
    "date_to": "$toDate"
  });

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print('response::2000');
    String station_summary= await response.stream.bytesToString();

    // Step 1: Parse the JSON string into a Map.
    Map<String, dynamic> summaryMap = json.decode(station_summary);

// Step 2: Access the "summary" value from the Map.
    double summaryValue = summaryMap['summary'];

// Step 3: Create a separate variable to store the "summary" value.
    double summary = summaryValue;

    return summary;

  }
}


