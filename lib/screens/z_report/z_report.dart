import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:grocery_app/APIS/z_report.dart';
import 'package:grocery_app/screens/receipt_screen/receipt_layout.dart';
import 'package:grocery_app/screens/z_report/choose_zreport_date.dart';
import 'package:grocery_app/screens/z_report/z_report_summary.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/screens/receipt_screen/choose_receipt_date.dart';
import 'package:grocery_app/screens/product_details/product_details_screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:grocery_app/screens/receipt_screen/print_receipt.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';

import '../../../APIS/authentication.dart';
import '../../../APIS/station_receipts.dart';

class ZReport extends StatefulWidget {
  @override
  _ZReportState createState() => _ZReportState();
}

class _ZReportState extends State<ZReport> {
  List<Element> _elements = [];
  bool _isLoading = true;
  double _kSize = 100;

  var dateFrom = '',dateTo = '';



  @override
  void initState() {
    super.initState();
    stationReceipt();
  }

  void stationReceipt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username');
    var password = prefs.getString('user_password');
    var user_id = prefs.getString('user_id');

    //getting the auth key:::
    String auth = await authentication(username!, password.toString());

    if (auth != null) {
       dateFrom = "2021-10-11";
      // Get the current date
      DateTime currentDate = DateTime.now();

      // Format the current date to match the desired format
      String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

      // Assign the formatted date to the variable
      dateTo = formattedDate;
      //call receipt api:::
      String user_zReport= await zReport(auth, dateFrom, dateTo);
      // String userStations1 = await userStations(auth,user_id.toString() );
      Map<String, dynamic> parsedResponse = json.decode(user_zReport);

      List<dynamic> dataList = parsedResponse['data'];

      List<Map<String, dynamic>> objectsList = dataList.map((data) {
        // String znumber = data['znumber'].toString();
        // String ticket = data['TICKETSFISCAL'].toString();
        // String net_amount = data['NETTAMOUNT_E'].toString();

        int znumber = 0;
        int ticket = 0;
        int net_amount = 0;

        int z_id = 0;

        try {
          znumber = double.parse(data['znumber'].toString()).toInt();
          ticket = double.parse(data['TICKETSFISCAL'].toString()).toInt();
          net_amount = double.parse(data['NETTAMOUNT_E'].toString()).toInt();

          z_id = double.parse(data['id'].toString()).toInt();


        } catch (e) {
          print('Invalid amount value: ${data['AMOUNT']}');
        }

        return {
          'znumber': znumber,
          'ticket': ticket,
          'net_amount': net_amount,
          'z_id': z_id,
        };
      }).toList();

      setState(() {
        objectsList.forEach((obj) {
          Element element = Element(obj['znumber'], obj['ticket'], obj['net_amount'],obj['z_id']
          );
          _elements.add(element);
        });

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
                // MaterialPageRoute(builder: (context) => choose_receiptScreen()),
                MaterialPageRoute(builder: (context) => zreport_date()),
              );
            },
            child: Container(
              padding: EdgeInsets.only(right: 25),
              child: Icon(
                Icons.date_range,
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
            text: "Z-Report",
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
//
          : Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    DataTable(
                      showCheckboxColumn: false,
                      columns: [
                        DataColumn(label: Text('znumber')),
                        DataColumn(label: Text('ticket')),
                        DataColumn(label: Text('net_amount')),
                      ],
                      rows: _elements.map((element) {
                        return DataRow(
                          cells: [
                            DataCell(Text(element.znumber.toString())),
                            DataCell(Text(element.ticket.toString())),
                            DataCell(Text(element.net_amount.toString())),
                          ],
                          onSelectChanged: (selected) {
                            if (selected != null && selected) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  // builder: (context) => ReceiptScreen(),
                                  builder: (context) =>
                                      z_report_summary(id: element.z_id,dateTo:dateTo,dateFrom:dateFrom.toString()),
                                ),
                              );

                            }
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          BottomAppBar(
            child: Container(
              height: 60,
              child: BottomAppBar(
                color: Colors.black54,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.attach_money,
                          color: Colors.green
                      ),
                      onPressed: () {},
                    ),
                    Text(
                      'Total Amount:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                    Text(
                      NumberFormat('#,###').format(calculateTotalAmount()),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

    );
  }

  int calculateTotalAmount() {
    int totalAmount = 0;
    for (var element in _elements) {
      totalAmount += element.net_amount;
    }
    return totalAmount;
  }

  void onItemClicked(BuildContext context, GroceryItem groceryItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(
          groceryItem,
          heroSuffix: "explore_screen",
        ),
      ),
    );
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the employee which will be rendered in datagrid.
class Element {
  final int znumber;
  final int ticket;
  final int net_amount;
  final int z_id;


  Element(
      this.znumber, this.ticket, this.net_amount,this.z_id);

  @override
  String toString() {
    return '($znumber, $ticket, $net_amount)';
  }
}
