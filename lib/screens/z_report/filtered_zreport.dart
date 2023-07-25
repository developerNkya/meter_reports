import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:grocery_app/screens/receipt_screen/receipt_layout.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/screens/receipt_screen/choose_receipt_date.dart';
import 'package:grocery_app/screens/product_details/product_details_screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';

import '../../APIS/authentication.dart';
import '../../APIS/station_receipts.dart';

class filtered_zreport extends StatefulWidget {
  final DateTime? fromDate;
  final TimeOfDay? fromTime;
  final TimeOfDay? toTime;
  final DateTime? toDate;
  double _kSize = 100;

  filtered_zreport({
    this.fromDate,
    this.fromTime,
    this.toDate,
    this.toTime,
  });

  @override
  _filtered_zreportState createState() => _filtered_zreportState();
}

class _filtered_zreportState extends State<filtered_zreport> {
  List<Element> _elements = [];
  bool _isLoading = true;
  double _kSize = 100;
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

    // Get the current date
    var dateFrom = widget.fromDate.toString();

    // Get the current date
    DateTime currentDate = widget.toDate as DateTime;

    // Format the current date to match the desired format
    String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

    // Assign the formatted date to the variable
    var dateTo = formattedDate;

    String userReceipts = await fetchStationReceiptReport(auth, dateFrom, dateTo);

    if (userReceipts != null) {
      if (userReceipts.isNotEmpty) {
        Map<String, dynamic> parsedResponse = json.decode(userReceipts);

        // Check if data is available
        if (parsedResponse.containsKey('data')) {
          List<dynamic> dataList = parsedResponse['data'];

          List<Map<String, dynamic>> objectsList = dataList.map((data) {
            String date = data['DATE'].toString();
            String time = data['TIME'].toString();
            String fuelGrade = data['FUEL_GRADE'].toString();
            int unit = 0;
            int amount = 0;
            int id = 0;

            try {
              amount = double.parse(data['AMOUNT'].toString()).toInt();
              id = double.parse(data['id'].toString()).toInt();

              print(id);


            } catch (e) {
              print('Invalid amount value: ${data['AMOUNT']}');
            }

            return {
              'date': date,
              'time': time,
              'fuelGrade': fuelGrade,
              'unit': unit,
              'amount': amount,
              'id' : id,
            };
          }).toList();

          setState(() {
            _elements.clear(); // Clear the elements list

            objectsList.forEach((obj) {
              Element element = Element(
                  obj['date'],
                  obj['time'],
                  obj['fuelGrade'],
                  obj['unit'],
                  obj['amount'],
                  obj['id']
              );

              _elements.add(element);
            });

            _isLoading = false;
          });
        } else {
          // No data available
          setState(() {
            _isLoading = false;
            _elements.clear(); // Clear the elements list
          });
        }
      } else {
        // No data available
        setState(() {
          _isLoading = false;
          _elements.clear(); // Clear the elements list
        });
      }
    } else {
      // Error occurred while fetching userReceipts, handle the error
      setState(() {
        _isLoading = false;
        _elements.clear(); // Clear the elements list
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
                MaterialPageRoute(builder: (context) => SingleSectionForm()),
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
            text: "zreport",
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: _isLoading
          ? Center(
        child:  Center(
            child: Container(
                height: 50,
                child: LoadingAnimationWidget.inkDrop(
                    color: Colors.white,
                    size: _kSize))),
      )
          :Column(
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
                        DataColumn(label: Text('Date')),
                        DataColumn(label: Text('Time')),
                        DataColumn(label: Text('Fuel Grade')),
                        DataColumn(label: Text('Unit')),
                        DataColumn(label: Text('Amount')),
                      ],
                      rows: _elements.map((element) {
                        return DataRow(
                          cells: [
                            DataCell(Text(element.date)),
                            DataCell(Text(element.time)),
                            DataCell(Text(element.fuelGrade)),
                            DataCell(Text('ltr')),
                            DataCell(Text(element.amount.toString())),
                          ],
                          onSelectChanged: (selected) {
                            if (selected != null && selected) {
                              // Handle row selection here
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CoolReceiptPage(id: element.id),
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
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 60,
              child: BottomAppBar(
                color: Colors.black54,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      color: Colors.green,
                      icon: Icon(Icons.attach_money),
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
      totalAmount += element.amount;
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
  final String date;
  final String time;
  final String fuelGrade;
  final int unit;
  final int amount;
  final int id;

  Element(this.date, this.time, this.fuelGrade, this.unit, this.amount,this.id);

  @override
  String toString() {
    return '($date, $time, $fuelGrade, $unit, $amount,$id)';
  }
}
