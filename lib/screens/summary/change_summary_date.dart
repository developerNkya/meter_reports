
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/screens/summary/filtered_summary.dart';
import 'package:intl/intl.dart';



import '../../common_widgets/app_text.dart';


import 'package:gsform/gs_form/core/form_style.dart';
import 'package:gsform/gs_form/model/data_model/date_data_model.dart';
import 'package:gsform/gs_form/widget/field.dart';
import 'package:gsform/gs_form/widget/form.dart';



// ignore: must_be_immutable
class change_summary_date extends StatefulWidget {
  change_summary_date({Key? key}) : super(key: key);

  @override
  State<change_summary_date> createState() => _change_summary_dateState();
}

class _change_summary_dateState extends State<change_summary_date> {
  late GSForm form;
  String selectedTime = '';

  DateTime? fromDate;
  TimeOfDay? fromTime;
  DateTime? toDate;
  TimeOfDay? toTime;
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
        padding: const EdgeInsets.all(0.0),
        child: Column(
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
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0,50,0,0),
                  child: form = GSForm.singleSection(
                    style: GSFormStyle(titleStyle: const TextStyle(color: Colors.black87, fontSize: 16.0)),
                    context,
                    fields: [
                      GSField.datePicker(
                        prefixWidget:Text(
                          fromDate != null && fromTime != null
                              ? '${fromDate!.toString().substring(0,10)} ${fromTime!.format(context)}'
                              : 'Select Start Date and Time',
                        ),
                        tag: 'licenceExpireDate',
                        title: 'Start date',
                        weight: 12,
                        required: true,
                        postfixWidget: new IconButton(
                          icon: new Icon(Icons.calendar_month),
                          color: Color(0xff676767),
                          onPressed: () {
                            _selectFromDate(context);
                          },
                          // color: Color(0xff676767),
                        ),
                        displayDateType: GSDateFormatType.numeric,
                        calendarType: GSCalendarType.gregorian,
                      ),

                      GSField.datePicker(
                        prefixWidget:Text(
                          toDate != null && toTime != null
                              ? '${toDate!.toString().substring(0,10)} ${toTime!.format(context)}'
                              : 'Select End Date and Time',
                        ),
                        tag: 'licenceExpireDate',
                        title: 'End date',
                        weight: 12,
                        required: true,
                        postfixWidget: new IconButton(
                          icon: new Icon(Icons.calendar_month),
                          color: Color(0xff676767),
                          onPressed: () {
                            _selectToDate(context);
                          },
                          // color: Color(0xff676767),
                        ),
                        displayDateType: GSDateFormatType.numeric,
                        calendarType: GSCalendarType.gregorian,
                      ),

                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
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
                          style: TextStyle(
                          color: Colors.white
                      )),
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
      String formattedFromDate = fromDate.toString().substring(0,10);
      String formattedTime = timeConverter(fromTime);
      String resultingFromDate = formattedFromDate + ' ' + formattedTime;

      String formattedToDate = toDate.toString().substring(0,10);
      String formattedToTime = timeConverter(toTime);
      String resultingToDate = formattedToDate + ' ' + formattedToTime;


      //  pass to filtered receipts::
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>filtered_summary(fromDate: resultingFromDate,fromTime: fromTime,toDate: resultingToDate,toTime: toTime)),
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

  timeConverter(time){
    DateTime dateTime = DateTime(0, 0, 0, time!.hour, time!.minute);
    // Format the DateTime object in 24-hour format
    String formattedTime = DateFormat('HH:mm:ss').format(dateTime);

    return formattedTime;
  }
}


class ImgSample {
  static String get(String name){
    return 'assets/images/calender2.jpg';
  }

}

class MyTextSample{

  static TextStyle? display4(BuildContext context){
    return Theme.of(context).textTheme.displayLarge;
  }

  static TextStyle? display3(BuildContext context){
    return Theme.of(context).textTheme.displayMedium;
  }

  static TextStyle? display2(BuildContext context){
    return Theme.of(context).textTheme.displaySmall;
  }

  static TextStyle? display1(BuildContext context){
    return Theme.of(context).textTheme.headlineMedium;
  }

  static TextStyle? headline(BuildContext context){
    return Theme.of(context).textTheme.headlineSmall;
  }

  static TextStyle? title(BuildContext context){
    return Theme.of(context).textTheme.titleLarge;
  }

  static TextStyle medium(BuildContext context){
    return Theme.of(context).textTheme.titleMedium!.copyWith(
      fontSize: 18,
    );
  }

  static TextStyle? subhead(BuildContext context){
    return Theme.of(context).textTheme.titleMedium;
  }

  static TextStyle? body2(BuildContext context){
    return Theme.of(context).textTheme.bodyLarge;
  }

  static TextStyle? body1(BuildContext context){
    return Theme.of(context).textTheme.bodyMedium;
  }

  static TextStyle? caption(BuildContext context){
    return Theme.of(context).textTheme.bodySmall;
  }

  static TextStyle? button(BuildContext context){
    return Theme.of(context).textTheme.labelLarge!.copyWith(
        letterSpacing: 1
    );
  }

  static TextStyle? subtitle(BuildContext context){
    return Theme.of(context).textTheme.titleSmall;
  }

  static TextStyle? overline(BuildContext context){
    return Theme.of(context).textTheme.labelSmall;
  }
}

class MyColorsSample {
  static const Color primary = Color(0xFF12376F);
  static const Color primaryDark = Color(0xFF0C44A3);
  static const Color primaryLight = Color(0xFF43A3F3);
  static const Color green = Colors.green;
  static Color black = const Color(0xFF000000);
  static const Color accent = Color(0xFFFF4081);
  static const Color accentDark = Color(0xFFF50057);
  static const Color accentLight = Color(0xFFFF80AB);
  static const Color grey_3 = Color(0xFFf7f7f7);
  static const Color grey_5 = Color(0xFFf2f2f2);
  static const Color grey_10 = Color(0xFFe6e6e6);
  static const Color grey_20 = Color(0xFFcccccc);
  static const Color grey_40 = Color(0xFF999999);
  static const Color grey_60 = Color(0xFF666666);
  static const Color grey_80 = Color(0xFF37474F);
  static const Color grey_90 = Color(0xFF263238);
  static const Color grey_95 = Color(0xFF1a1a1a);
  static const Color grey_100_ = Color(0xFF0d0d0d);
  static const Color transparent = Color(0x00f7f7f7);


}




//for the example


