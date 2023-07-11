import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grocery_app/screens/receipt_screen/filtered_receipts.dart';

import 'package:lottie/lottie.dart';

import '../../common_widgets/app_text.dart';
import 'package:fluttertoast/fluttertoast.dart';


class choose_receiptScreen extends StatefulWidget {
  choose_receiptScreen({Key? key}) : super(key: key);

  @override
  State<choose_receiptScreen> createState() => _choose_receiptScreenState();
}

class _choose_receiptScreenState extends State<choose_receiptScreen> {
  String selectedTime = '';

  DateTime? fromDate;
  TimeOfDay? fromTime;
  DateTime? toDate;
  TimeOfDay? toTime;

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

            },
            child: Container(
              padding: EdgeInsets.only(right: 25),
              child: Icon(
                Icons.watch_later_outlined,
                color: Colors.black,
              ),
            ),
          ),
        ],
        title: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 25,
          ),
          child: AppText(
            text: "Change Dates",
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'From',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  _selectFromDate(context);
                },
                child: Text(
                  fromDate != null && fromTime != null
                      ? '${fromDate!.toString()} ${fromTime!.format(context)}'
                      : 'Select From Date and Time',
                ),
              ),
              SizedBox(height: 16),
              Text(
                'To',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  _selectToDate(context);
                },
                child: Text(
                  toDate != null && toTime != null
                      ? '${toDate!.toString()} ${toTime!.format(context)}'
                      : 'Select To Date and Time',
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Perform form submission or any desired action
                  _submitForm();
                },
                child: Text('Submit'),
              ),
              SizedBox(height: 16),
              Text(
                'Current Date Range:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                fromDate != null && toDate != null
                    ? 'From: ${fromDate!.toString()} ${fromTime!.format(context)} - To: ${toDate!.toString()} ${toTime!.format(context)}'
                    : 'Date range not selected',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showTimePicker() async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        this.selectedTime = selectedTime.format(context);
      });
    }
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          fromDate = pickedDate;
          fromTime = pickedTime;
        });
      }
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          toDate = pickedDate;
          toTime = pickedTime;
        });
      }
    }
  }

  void _submitForm() {
    // Perform form submission or any desired action with selected date range
    if (fromDate != null &&
        fromTime != null &&
        toDate != null &&
        toTime != null) {
      // Process the selected date range
      print('Selected Date Range: ${fromDate.toString()} ${fromTime!.format(context)} - ${toDate.toString()} ${toTime!.format(context)}');

    //  pass to filtered receipts::
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>FilteredReceipts(fromDate: fromDate,fromTime: fromTime,toDate: toDate,toTime: toTime)),
      );

    } else {
      // Date range not selected
      // print('Please select a date range');
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
