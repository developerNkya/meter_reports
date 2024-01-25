import 'dart:convert';
import 'package:http/http.dart' as http;

handle_receipt(String accessToken,String id) async {
  var headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $accessToken',
    'Cookie':
    '_csrf-backend=d02273b7fb9811d2f426d7de25cf7a7c65aabcc1324b1f41a70d9a8e6a89fd32a%3A2%3A%7Bi%3A0%3Bs%3A13%3A%22_csrf-backend%22%3Bi%3A1%3Bs%3A32%3A%22YkgWgJNwFuG_6RFQL8EWge-jj1frtrWf%22%3B%7D'
  };

  var request = http.Request(
    'POST',
    Uri.parse('http://67.217.56.19:8090/fummas_mobile/api/receipt'),
  );

  request.body = json.encode({
    "receipt_id": id,
  });

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print('response::2000');
    String stationReceipts= await response.stream.bytesToString();

    print(stationReceipts);
    return stationReceipts;


  }
}


