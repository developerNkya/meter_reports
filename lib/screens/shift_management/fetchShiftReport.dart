import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

Future<Map<String, dynamic>?> processReceipts(String stationReceipts) async {
  Map<String, dynamic> jsonData = jsonDecode(stationReceipts);
  List<dynamic> receipts = jsonData['data'];
  double totalAmount = 0.0;
  double totalPrice = 0.0;
  int totalTickets = receipts.length;
  String name = "";
  String address = "";
  String mobile = "";
  String tin = "";
  String vrn = "";
  String serial = "";
  String uin = "";
  String regid = "";
  String taxOffice = "";

  for (var receipt in receipts) {
    totalAmount += double.parse(receipt['AMOUNT']);
    totalPrice += double.parse(receipt['PRICE']);
    name = receipt['name'];
    address = receipt['address'];
    mobile = receipt['mobile'];
    tin = receipt['tin'];
    vrn = receipt['vrn'];
    serial = receipt['serial'];
    uin = receipt['uin'];
    regid = receipt['regid'];
    taxOffice = receipt['taxoffice'];
  }

  String znumber = DateFormat('yyyyMMdd').format(DateTime.now());

  Map<String, dynamic> finalStructure = {
    "id": 465,
    "DAILYTOTALAMOUNT": totalAmount.toStringAsFixed(2),
    "GROSS": totalPrice.toStringAsFixed(2),
    "znumber": znumber,
    "TICKETSFISCAL": totalTickets,
    "NETTAMOUNT_E": totalAmount.toStringAsFixed(2),
    "TAXAMOUNT_E": totalAmount.toStringAsFixed(2),
    "PMTAMOUNT_CASH": totalAmount.toStringAsFixed(2),
    "name": name,
    "address": address,
    "mobile": mobile,
    "tin": tin,
    "vrn": vrn,
    "serial": serial,
    "uin": uin,
    "regid": regid,
    "taxoffice": taxOffice,
  };
  return finalStructure;
}

Future<Map<String, dynamic>?> fetchShiftReport(String accessToken, String dateFrom, String dateTo) async {
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
    "date_to": "${dateTo}",
    "date_from": "${dateFrom}",
    //  "date_to": "2024-05-22 23:59:59",
    // "date_from": "2024-05-22",
    "pump": 0
  });

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    String stationReceipts = await response.stream.bytesToString();
    return await processReceipts(stationReceipts);
  } else {
    print(response.reasonPhrase);
    return null;
  }
}
