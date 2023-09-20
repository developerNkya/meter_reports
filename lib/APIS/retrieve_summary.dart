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
  String dateFrom;
  String dateTo;

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
    required this.mobile,
    required this.dateFrom,
    required this.dateTo,
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
      'mobile': mobile,
      'dateFrom': dateFrom,
      'dateTo': dateTo
    };
  }
}

Future<String?> retrieve_summary(String access_token, String toDate) async {

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
    Uri.parse('http://67.217.56.19:8090/fummas_mobile/api/station-z-report'),
  );

  request.body = json.encode({
    "company_id": company_id,
    "station_id": stationId,
    "date_from": "2021-10-11",
    "date_to": "$toDate"
  });

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    String station_summary = await response.stream.bytesToString();
    Map<String, dynamic> jsonResponse = json.decode(station_summary);

    List<dynamic> dataList = jsonResponse['data'];

    int dataListLength = dataList.length;

    double totalAmountSum = 0;

    for (var obj in dataList) {
      String dailyTotalAmountString = obj['DAILYTOTALAMOUNT'];
      double dailyTotalAmount = double.parse(dailyTotalAmountString);
      totalAmountSum += dailyTotalAmount;

    }


    // Extract other required fields
    String from = "2021-10-11"; // Replace this with the actual 'from' value if available
    String to = toDate;
    String name = dataList.isNotEmpty ? dataList[0]['name'] : '';
    String address = dataList.isNotEmpty ? dataList[0]['address'] : '';
    String tin = dataList.isNotEmpty ? dataList[0]['tin'] : '';
    String vrn = dataList.isNotEmpty ? dataList[0]['vrn'] : '';
    String serial = dataList.isNotEmpty ? dataList[0]['serial'] : '';
    String uin = dataList.isNotEmpty ? dataList[0]['uin'] : '';
    String taxoffice = dataList.isNotEmpty ? dataList[0]['taxoffice'] : '';
    int id = dataList.isNotEmpty ? dataList[0]['id'] : '';
    int length = dataListLength;
    String mobile = dataList.isNotEmpty ? dataList[0]['mobile'] : '';
    String dateFrom = '2021-10-11';
    String dateTo = '$toDate';


    // Create the SummaryObject
    SummaryObject summaryObject = SummaryObject(
      from: from,
      to: to,
      name: name,
      address: address,
      tin: tin,
      vrn: vrn,
      serial: serial,
      uin: uin,
      taxoffice: taxoffice,
      totalAmountSum: totalAmountSum,
      id: id,
      length: dataListLength,
      mobile:mobile,
      dateFrom: dateFrom,
      dateTo: dateTo
    );

    // Convert the SummaryObject to a JSON string
    String summaryObjectJson = json.encode(summaryObject.toJson());

    // print('----------------');
    // print(dataList);
    // print('----------------');

    return summaryObjectJson;
  }
}
