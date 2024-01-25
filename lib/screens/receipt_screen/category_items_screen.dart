import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grocery_app/screens/receipt_screen/receipt_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/screens/receipt_screen/choose_receipt_date.dart';
import 'package:grocery_app/screens/product_details/product_details_screen.dart';
import 'package:intl/intl.dart';

import '../../APIS/authentication.dart';
import '../../APIS/station_receipts.dart';

class FormattedAmount {
  final int value;
  final String formattedString;

  FormattedAmount(this.value, this.formattedString);
}


class CategoryItemsScreen extends StatefulWidget {
  @override
  _CategoryItemsScreenState createState() => _CategoryItemsScreenState();
}

class _CategoryItemsScreenState extends State<CategoryItemsScreen> {
  List<Element> _elements = [];
  bool _isLoading = true;
  double _kSize = 100;
  String? yesterday_day;
  String? today_day;
  late DateTime currentDate;

  @override
  void initState() {
    super.initState();
    stationReceipt();
  }

  void stationReceipt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username');
    var password = prefs.getString('user_password');
    var userId = prefs.getString('user_id');

    //getting the auth key:::
    String auth = await authentication(username!, password.toString());

    DateTime yesterdayDate = DateTime.now().subtract(Duration(days:2));
    // Set the time to the end of the day (23:59:59)
    DateTime endOfYesterDay = DateTime(yesterdayDate.year, yesterdayDate.month, yesterdayDate.day, 00, 00, 00);
    // Format the end of day to match the desired format
    String formatted_Yesterday = DateFormat('yyyy-MM-dd HH:mm:ss').format(endOfYesterDay);
    // Assign the formatted date to the variable
    yesterday_day = DateFormat('yyyy-MM-dd').format(endOfYesterDay);
    var dateFrom = formatted_Yesterday;


    print('---esterday::');
    print(dateFrom);
    // Get the current date
        currentDate = DateTime.now();
    // Set the time to the end of the day (23:59:59)
    DateTime endOfDay = DateTime(currentDate.year, currentDate.month, currentDate.day, 23, 59, 59);
    // Format the end of day to match the desired format
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(endOfDay);
    // Assign the formatted date to the variable
    today_day = DateFormat('yyyy-MM-dd').format(endOfDay);

    var dateTo = formattedDate;

    //call receipt api:::
    var userReceipts = await fetchStationReceiptReport(auth, dateFrom, dateTo);

    if(userReceipts != null){
        // String userStations1 = await userStations(auth,user_id.toString() );
        Map<String, dynamic> parsedResponse = json.decode(userReceipts);

        List<dynamic> dataList = parsedResponse['data'];

        print('--------------------------------');
        print(dataList);

        print(dataList);

        List<Map<String, dynamic>> objectsList = dataList.map((data) {
          String date = data['DATE'].toString();
          String time = data['TIME'].toString();
          String fuelGrade = data['FUEL_GRADE'].toString();
          String litres = data['QTY'].toString();
          String unit = 'ltr';

          int amount = 0;
          FormattedAmount formattedAmount = FormattedAmount(0, '');

          int id = 0;

          try {
            amount = double.parse(data['AMOUNT'].toString()).toInt();

            // Format the amount with comma separation based on the number of digits
            String formattedAmountString = NumberFormat('#,##0').format(amount);

            // Convert the formatted amount string to an int (preserve commas)
            formattedAmount = FormattedAmount(amount, formattedAmountString);

            // Now, `formattedAmount` contains both the int and formatted string
            print(formattedAmount.value); // This is the integer value
            print(formattedAmount.formattedString); // This is the formatted string

            id = double.parse(data['id'].toString()).toInt();
          } catch (e) {
            print('Invalid amount value: ${data['AMOUNT']}');
          }

          print(formattedAmount.formattedString);

          return {
            'date': date,
            'time': time,
            'fuelGrade': fuelGrade,
            'unit': unit,
            'amount': formattedAmount.value,
            'formattedAmountString': formattedAmount.formattedString,
            'id': id,
            'qty': litres
          };
        }).toList();

        setState(() {
          objectsList.forEach((obj) {
            Element element = Element(obj['date'], obj['time'], obj['fuelGrade'],
                obj['unit'], obj['amount'], obj['id'], obj['qty']);

            _elements.add(element);
          });

          _isLoading = false;
        });
    }else {
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
      backgroundColor: Colors.white,
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
            text: "Receipts",
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
                          Text('Data from ${yesterday_day} to ${today_day}'),
                          DataTable(
                            showCheckboxColumn: false,
                            columns: [
                              DataColumn(label: Text('Date')),
                              DataColumn(label: Text('Time')),
                              DataColumn(label: Text('Fuel Grade')),
                              DataColumn(label: Text('Litres')),
                              DataColumn(label: Text('Amount')),
                            ],
                            rows: _elements.map((element) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(element.date)),
                                  DataCell(Text(element.time)),
                                  DataCell(Text(element.fuelGrade)),
                                  DataCell(Text(element.qty.toString())),
                                  DataCell(Text(NumberFormat('#,###').format(element.amount))),
                                ],
                                onSelectChanged: (selected) {
                                  if (selected != null && selected) {
                                    // onRowSelected(element);
                                    print(element.id);

                                    //  moving to the print receipt element::
                                    //   Navigator.pushReplacement(
                                    //     context,
                                    //     MaterialPageRoute(builder: (context) => ReceiptPage(receiptNumber: receiptNumber, zNumber: zNumber, receiptDate: receiptDate, pumpNumber: pumpNumber, nozzleNumber: nozzleNumber, fuelType: fuelType, unitPrice: unitPrice, amount: amount)),
                                    //   );

                                    // Navigator.pushReplacement(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => ReceiptPage(
                                    //       receiptNumber: '123333',
                                    //       zNumber: '2/333333',
                                    //       receiptDate: DateTime(2023, 4, 5, 4, 55, 44),
                                    //       pumpNumber: 2,
                                    //       nozzleNumber: 1,
                                    //       fuelType: 'DIESEL',
                                    //       unitPrice: 4.67,
                                    //       amount: 7.000,
                                    //     ),
                                    //   ),
                                    // );

                                    //
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        // builder: (context) => ReceiptScreen(),
                                        builder: (context) =>
                                            CoolReceiptPage(id: element.id),
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
  final String unit;
  final int amount;
  final int id;
  final String qty;

  Element(
      this.date, this.time, this.fuelGrade, this.unit, this.amount, this.id,this.qty);

  @override
  String toString() {
    return '($qty,$date, $time, $fuelGrade, $unit, $amount,$id)';
  }
}
