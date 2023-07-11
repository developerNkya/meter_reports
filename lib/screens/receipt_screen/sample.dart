
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grocery_app/APIS/handle_receipt.dart';
import 'package:grocery_app/screens/receipt_screen/print_receipt.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../APIS/authentication.dart';
import '../../common_widgets/app_text.dart';

class Element {
final int id;
final String date;
final String time;
final String fuelGrade;
final int amount;
final String dc;
final String gc;
final String zNum;
final String rctvNum;
final String qty;
final String nozzle;
final String? name;
final String? address;
final String? mobile;
final String? tin;
final String? vrn;
final String? serial;
final String? uin;
final String? regid;
final String? taxOffice;

Element(
this.id,
this.date,
this.time,
this.fuelGrade,
this.amount,
this.dc,
this.gc,
this.zNum,
this.rctvNum,
this.qty,
this.nozzle,
this.name,
this.address,
this.mobile,
this.tin,
this.vrn,
this.serial,
this.uin,
this.regid,
this.taxOffice,
);

@override
String toString() {
return 'Element(id: $id, date: $date, time: $time, fuelGrade: $fuelGrade, amount: $amount, dc: $dc, gc: $gc, zNum: $zNum, rctvNum: $rctvNum, qty: $qty, nozzle: $nozzle, name: $name, address: $address, mobile: $mobile, tin: $tin, vrn: $vrn, serial: $serial, uin: $uin, regid: $regid, taxOffice: $taxOffice)';
}
}
class CoolReceiptPage extends StatefulWidget {

final int? id;

CoolReceiptPage({
this.id,
});

@override
State<CoolReceiptPage> createState() => _CoolReceiptPageState();
}

class _CoolReceiptPageState extends State<CoolReceiptPage> {
List<Element> _elements = [];
bool _isLoading = true;
var receipt_data;
@override

void initState() {
super.initState();
stationReceipt();
}

void stationReceipt() async {
SharedPreferences prefs = await SharedPreferences.getInstance();
var username = prefs.getString('username');
var password = prefs.getString('user_password');

// Getting the auth key
String auth = await authentication(username!, password.toString());

if (auth != null) {
String userReceipts = await handle_receipt(auth, widget.id.toString());

Map<String, dynamic> parsedResponse = json.decode(userReceipts);
// List<dynamic> dataList = parsedResponse['data'];

print('object');

receipt_data = parsedResponse['data'];
print(receipt_data['id']);

setState(() {
Element element = Element(
receipt_data['id'],
receipt_data['DATE'],
receipt_data['TIME'],
receipt_data['FUEL_GRADE'],
receipt_data['AMOUNT'],
receipt_data['DC'],
receipt_data['GC'],
receipt_data['ZNUM'],
receipt_data['RCTVNUM'],
receipt_data['QTY'],
receipt_data['NOSSEL'],
receipt_data['name'],
receipt_data['address'],
receipt_data['mobile'],
receipt_data['tin'],
receipt_data['vrn'],
receipt_data['serial'],
receipt_data['uin'],
receipt_data['regid'],
receipt_data['taxoffice'],
);

_elements.add(element);

print('--------------------------------');
print(_elements);

_isLoading = false;
});
}
}


@override

Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
backgroundColor: Colors.transparent,
elevation: 0,
centerTitle: true,
automaticallyImplyLeading: false,
leading: GestureDetector(
onTap: () {
Navigator.pop(context);
},
child: Container(
padding: EdgeInsets.only(left: 25),
child: Icon(
Icons.arrow_back_ios,
color: Colors.black,
),
),
),
actions: [
GestureDetector(
onTap: () {
//move to set date page:::
Navigator.pushReplacement(
context,
MaterialPageRoute(builder: (context) => ReceiptScreen(
id: _elements[0].id,
date: _elements[0].date,
time: _elements[0].time,
fuelGrade: _elements[0].fuelGrade,
amount: _elements[0].amount,
dc: _elements[0].dc,
gc: _elements[0].gc,
zNum: _elements[0].zNum,
rctvNum: _elements[0].rctvNum,
qty: _elements[0].qty,
nozzle: _elements[0].nozzle,
name: _elements[0].name,
address: _elements[0].address,
mobile: _elements[0].mobile,
tin: _elements[0].tin,
vrn: _elements[0].vrn,
serial: _elements[0].serial,
uin: _elements[0].uin,
regid: _elements[0].regid,
taxOffice: _elements[0].taxOffice,

)),
);
},
child: Container(
padding: EdgeInsets.only(right: 25),
child: Icon(
Icons.print,
color: Colors.black,
),
),
),
],
//receipts page::
title: Container(
padding: EdgeInsets.symmetric(
horizontal: 25,
),
child: AppText(
text: "Receipts",
fontWeight: FontWeight.bold,
fontSize: 20,
),
),
),
body:  _isLoading
? Center(
child: CircularProgressIndicator()) // Show loading indicator
    : SingleChildScrollView(
child:  Container(
padding: EdgeInsets.all(16.0),
child:   Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children:
<Widget>[
Text(
'START OF LEGAL RECEIPT',
style: TextStyle(
fontSize: 18.0,
fontWeight: FontWeight.bold,
),
textAlign: TextAlign.center,
),
SizedBox(height: 16.0),
Icon(
Icons.receipt,
size: 48.0,
),
SizedBox(height: 16.0),
Text(
'FUMAS\nMobile: 6777\nTin ${_elements[0].tin ?? 'N/A'}\nVRN: ${_elements[0].vrn ?? 'N/A'}\nSERIAL NO: ${_elements[0].serial ?? 'N/A'}\nUIN:${_elements[0].uin ?? 'N/A'}\nTAX OFFICE: ${_elements[0].taxOffice ?? 'N/A'}',
style: TextStyle(fontSize: 16.0),
textAlign: TextAlign.center,
),
SizedBox(height: 32.0),
_buildDividerDots(),
_buildRowWithColumns(
leftColumn: 'RECEIPT NUMBER:',
rightColumn: '${_elements[0].id ?? 'N/A'}',
),
_buildDividerDots(),
_buildRowWithColumns(
leftColumn: 'Z NO:',
rightColumn: '${_elements[0].zNum ?? 'N/A'}',
),
_buildDividerDots(),
_buildRowWithColumns(
leftColumn: 'DATE:',
rightColumn: '${_elements[0].date ?? 'N/A'}',
),
_buildDividerDots(),
_buildRowWithColumns(
leftColumn: 'TIME:',
rightColumn: '${_elements[0].time ?? 'N/A'}',
),
_buildDividerDots(),
_buildRowWithColumns(
leftColumn: 'PUMP:',
rightColumn: '2',
),
_buildRowWithColumns(
leftColumn: 'NOZZLE:',
rightColumn: '1',
),
_buildRowWithColumns(
leftColumn: 'UNLEADED:',
rightColumn: '0',
),
_buildDividerDots(),
_buildRowWithColumns(
leftColumn: 'TOTAL EXCL TAX: ',
rightColumn: '0.000',
),
_buildDividerDots(),
_buildRowWithColumns(
leftColumn: 'TOTAL TAX:',
rightColumn: '0',
),

_buildDividerDots(),
_buildRowWithColumns(
leftColumn: 'TOTAL INCL TAX:',
rightColumn: '0',
),
_buildDividerDots(),
SizedBox(height: 32.0),
Text(
'RECEIPT VERIFICATION CODE',
style: TextStyle(
fontSize: 16.0,
fontWeight: FontWeight.bold,
),
textAlign: TextAlign.center,
),
SizedBox(height: 8.0),
Text(
'3HH4JJ493JJJJ',
style: TextStyle(
fontSize: 24.0,
fontWeight: FontWeight.bold,
),
textAlign: TextAlign.center,
),
SizedBox(height: 32.0),
Text(
'SAMPLE QR CODE',
style: TextStyle(fontSize: 16.0),
textAlign: TextAlign.center,
),
SizedBox(height: 8.0),
// Container(
//   width: 200.0,
//   height: 200.0,
//   color: Colors.grey,
//   // child: Center(
//   //   child:QrImage(
//   //     data: 'https://example.com', // Replace with your link here
//   //     version: QrVersions.auto,
//   //     size: 200.0,
//   //     backgroundColor: Colors.grey,
//   //     foregroundColor: Colors.white,
//   //   ),
//   // ),
// ),
],
),
),
),
);
}

Widget _buildDividerDots() {
return Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Expanded(
child: Divider(
color: Colors.grey,
height: 1.0,
),
),
SizedBox(width: 8.0),
Text(
'•',
style: TextStyle(
fontSize: 20.0,
fontWeight: FontWeight.bold,
),
),
SizedBox(width: 8.0),
Expanded(
child: Divider(
color: Colors.grey,
height: 1.0,
),
),
],
);
}

Widget _buildRowWithColumns({required String leftColumn, required String rightColumn}) {
return Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Text(
leftColumn,
style: TextStyle(fontSize: 16.0),
),
Text(
rightColumn,
style: TextStyle(
fontSize: 16.0,
fontWeight: FontWeight.bold,
),
),
],
);
}
}

void main() {
runApp(MyApp());
}

class MyApp extends StatelessWidget {
@override
Widget build(BuildContext context) {
return MaterialApp(
title: 'Cool Receipt App',
theme: ThemeData(
primarySwatch: Colors.blue,
),
home: CoolReceiptPage(),
);
}
}







