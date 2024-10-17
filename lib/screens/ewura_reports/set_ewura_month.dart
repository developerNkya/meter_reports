import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/screens/ewura_reports/fetchEwuraReport.dart';
import 'package:grocery_app/screens/ewura_reports/fetchedEwuraReport.dart';
import 'package:grocery_app/screens/shift_management/shift_receipts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../APIS/authentication.dart';
import '../../common_widgets/app_text.dart';
import 'package:gsform/gs_form/core/form_style.dart';
import 'package:gsform/gs_form/widget/field.dart';
import 'package:gsform/gs_form/widget/form.dart';

import '../receipt_screen/choose_receipt_date.dart';

class ImgSample {
  static String get(String name){
    return 'assets/images/calender2.jpg';
  }

}


// ignore: must_be_immutable
class ChooseEwuraMonth extends StatefulWidget {
  ChooseEwuraMonth({Key? key}) : super(key: key);

  @override
  State<ChooseEwuraMonth> createState() => _ChooseEwuraMonthState();
}

class _ChooseEwuraMonthState extends State<ChooseEwuraMonth> {
  late GSForm form;
  DateTime? fromDate;
  DateTime? toDate;
  bool isLoading = false; // Add a loading state

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
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: AppText(
            text: "Ewura Reports",
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              // Define the shape of the card
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              // Define how the card's content should be clipped
              clipBehavior: Clip.antiAliasWithSaveLayer,
              // Define the child widget of the card
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Add padding around the row widget
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Add an image widget to display an image
                        Image.asset(
                          ImgSample.get("reading.png"),
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        // Add some spacing between the image and the text
                        Container(width: 20),
                        // Add an expanded widget to take up the remaining horizontal space
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // Add some spacing between the top of the card and the title
                              Container(height: 5),
                              // Add a title widget
                              Text(
                                "Choose Dates",
                                style: MyTextSample.title(context)!.copyWith(
                                  color: MyColorsSample.grey_80,
                                ),
                              ),
                              // Add some spacing between the title and the subtitle
                              Container(height: 5),
                              // Add a subtitle widget

                              // Add some spacing between the subtitle and the text
                              Container(height: 10),
                              // Add a text widget to display some text
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Start Month Selection
            Text(
              "Start Month",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                _selectMonthYear(context, isStartDate: true);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  fromDate != null
                      ? DateFormat('MMMM yyyy').format(fromDate!)
                      : 'Select Start Month',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 20), // Spacing between fields

            // End Month Selection
            Text(
              "End Month",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                _selectMonthYear(context, isStartDate: false);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  toDate != null
                      ? DateFormat('MMMM yyyy').format(toDate!)
                      : 'Select End Month',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 20), // Spacing before the submit button

            // Submit Button
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black45, // Background color
                      ),
                      onPressed: () {
                        _submitForm();
                      },
                      child: const Text('Submit',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectMonthYear(BuildContext context,
      {required bool isStartDate}) async {
    DateTime now = DateTime.now();
    int currentYear = now.year;

    // Create a List for months
    List<String> months = List.generate(
        12, (index) => DateFormat.MMMM().format(DateTime(0, index + 1)));

    // Show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String selectedMonth = months[now.month - 1]; // Default selected month
        int selectedYear = currentYear; // Default selected year

        return AlertDialog(
          title: Text('Select Month and Year'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dropdown for selecting month
                  DropdownButton<String>(
                    value: selectedMonth,
                    items: months.map((String month) {
                      return DropdownMenuItem<String>(
                        value: month,
                        child: Text(month),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedMonth = value!; // Update selected month
                      });
                    },
                  ),
                  // Dropdown for selecting year
                  DropdownButton<int>(
                    value: selectedYear,
                    items: List.generate(10, (index) => currentYear - index).map((
                        int year) {
                      return DropdownMenuItem<int>(
                        value: year,
                        child: Text(year.toString()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedYear = value!; // Update selected year
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                setState(() {
                  // Save selected month and year
                  DateTime selectedDate = DateTime(
                      selectedYear, months.indexOf(selectedMonth) + 1);
                  if (isStartDate) {
                    fromDate = selectedDate; // Set start date
                  } else {
                    toDate = selectedDate; // Set end date
                  }
                  // Dismiss dialog
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Loading..."),
            ],
          ),
        );
      },
    );
  }

  void _hideLoadingDialog() {
    Navigator.of(context, rootNavigator: true).pop(); // Dismiss the dialog
  }

  void _submitForm() async {
    // Show the loading dialog immediately
    _showLoadingDialog();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username');
    var password = prefs.getString('user_password');
    String auth = await authentication(username!, password.toString());

    if (fromDate != null && toDate != null) {
      DateTime startDate = DateTime(fromDate!.year, fromDate!.month, 1);
      DateTime endDate = DateTime(toDate!.year, toDate!.month + 1, 0);
      String accessToken = auth;

      // Make the network request to fetch Ewura report
      Map<String, dynamic> response = await fetchEwuraReport(
          accessToken, startDate, endDate);

      // Hide the loading dialog once the request is done
      _hideLoadingDialog();

      // Handle successful response
      if (response['status'] == 200) {
        double totalVolume = response['totalVolume'];
        double volumeUnleaded = response['volumeUnleaded'];
        double volumeDiesel = response['volumeDiesel'];
        double volumeKerosene = response['volumeKerosene'];

        // Navigate to the results screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FetchedEwuraReports(
              dateFrom: startDate,
              dateTo: endDate,
              totalVolume: totalVolume,
              volumeUnleaded: volumeUnleaded,
              volumeDiesel: volumeDiesel,
              volumeKerosene: volumeKerosene,
            ),
          ),
        );
      } else {
        // Handle error response
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          title: 'Oops...',
          text: response['message'],
          loopAnimation: false,
        );
      }
    } else {
      // Hide the loader if dates are not selected and show an error
      _hideLoadingDialog();
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        title: 'Oops...',
        text: 'Insert a date range',
        loopAnimation: false,
      );
    }
  }


}

