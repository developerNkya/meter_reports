import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/screens/ewura_reports/fetchEwuraReport.dart';
import 'package:grocery_app/screens/ewura_reports/fetchedEwuraReport.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../APIS/authentication.dart';
import '../../common_widgets/app_text.dart';

class ImgSample {
  static String get(String name) {
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
  DateTime? fromDate;
  DateTime? toDate;
  bool isLoading = false; // Loading state
  bool isSubmitting = false; // Submitting state to disable the button

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
            padding: const EdgeInsets.only(left: 25),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25),
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
            // Card Section for Title and Image
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      ImgSample.get("reading.png"),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Text(
                            "Choose Dates",
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Start Month Selection
            const Text(
              "Start Month",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                _selectMonthYear(context, isStartDate: true);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  fromDate != null
                      ? DateFormat('MMMM yyyy').format(fromDate!)
                      : 'Select Start Month',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // End Month Selection
            const Text(
              "End Month",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                _selectMonthYear(context, isStartDate: false);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  toDate != null
                      ? DateFormat('MMMM yyyy').format(toDate!)
                      : 'Select End Month',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Submit Button
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSubmitting ? Colors.grey : Colors
                            .black45,
                      ),
                      onPressed: isSubmitting ? null : _submitForm,
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
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
    List<String> months = List.generate(
        12, (index) => DateFormat.MMMM().format(DateTime(0, index + 1)));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String selectedMonth = months[now.month - 1];
        int selectedYear = currentYear;

        return AlertDialog(
          title: const Text('Select Month and Year'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                        selectedMonth = value!;
                      });
                    },
                  ),
                  DropdownButton<int>(
                    value: selectedYear,
                    items: List.generate(10, (index) => currentYear - index)
                        .map((int year) {
                      return DropdownMenuItem<int>(
                        value: year,
                        child: Text(year.toString()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedYear = value!;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                setState(() {
                  DateTime selectedDate = DateTime(
                      selectedYear, months.indexOf(selectedMonth) + 1);
                  if (isStartDate) {
                    fromDate = selectedDate;
                  } else {
                    toDate = selectedDate;
                  }
                });
                Navigator.of(context).pop();
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
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
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
    Navigator.of(context, rootNavigator: true).pop();
  }

  void _submitForm() async {

    print('clicked');
    // Avoid resubmission if already submitting
    if (isSubmitting) {
      return;
    }

    // Check if both dates are selected
    if (fromDate != null && toDate != null) {
      setState(() {
        isSubmitting = true;
      });

      // Get user credentials
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var username = prefs.getString('username');
      var password = prefs.getString('user_password');

      // If authentication credentials are missing, stop the process
      if (username == null || password == null) {
        _showErrorDialog("User authentication failed. Please login again.");
        setState(() {
          isSubmitting = false;
        });
        return;
      }

      // Authenticate the user
      String auth = await authentication(username, password);

      // Dates for the report
      DateTime startDate = DateTime(fromDate!.year, fromDate!.month, 1);
      DateTime endDate = DateTime(toDate!.year, toDate!.month + 1, 0);

      _showLoadingDialog();

      try {
        // Fetch the Ewura report
        Map<String, dynamic> response = await fetchEwuraReport(auth, startDate, endDate);

        // Hide the loading dialog
        _hideLoadingDialog();

        setState(() {
          isSubmitting = false;
        });

        if (response['status'] == 200) {
          // Navigate to the report screen on success
          double totalVolume = response['totalVolume'];
          double volumeUnleaded = response['volumeUnleaded'];
          double volumeDiesel = response['volumeDiesel'];
          double volumeKerosene = response['volumeKerosene'];

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
          // Show an error alert on failure
          _showErrorDialog(response['message']);
        }
      } catch (e) {
        // Hide the loading dialog and reset the flag in case of an error
        _hideLoadingDialog();
        setState(() {
          isSubmitting = false;
        });
        _showErrorDialog("An error occurred. Please try again.");
      }
    } else {
      _showErrorDialog("Please select both start and end months.");
    }
  }

  void _showErrorDialog(String message) {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.error,
      title: 'Error',
      text: message,
      loopAnimation: false,
    );
  }

}
