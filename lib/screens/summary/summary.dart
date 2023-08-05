import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grocery_app/APIS/handle_receipt.dart';
import 'package:grocery_app/screens/receipt_screen/print_receipt.dart';
import 'package:grocery_app/screens/summary/change_summary_date.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../APIS/authentication.dart';
import '../../../common_widgets/app_text.dart';
import '../../APIS/retrieve_summary.dart';

class Element {
  final int summary;

  Element(
      this.summary
      );

  @override
  String toString() {
    return 'Element(id: $summary)';
  }
}

class Summary extends StatefulWidget {
  final int? id;

  Summary({
    this.id,
  });

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  final String imagePath = "assets/images/sample_qr.png";
  final String tra_img = "assets/images/tra_img3.png";

  List<Element> _elements = [];
  bool _isLoading = true;
  var receipt_data;
  double _kSize = 100;
  late double displayed_summary;

 late String fromValue;
  late String toValue,mobile;
  late String name,address,tin,vrn,serial,uin,taxoffice;
   late double totalAmountSum;
   late int dataListLength;




  @override
  void initState() {
    super.initState();
    stationReceipt();
  }

  stationReceipt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username');
    var password = prefs.getString('user_password');

    // Getting the auth key
    String auth = await authentication(username!, password.toString());

    if (auth != null) {
      DateTime currentDate = DateTime.now();
      // Format the current date to match the desired format
      String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

      // Assign the formatted date to the variable
      var dateTo = formattedDate;
      String userSummary = await retrieve_summary(auth, dateTo) ?? '';
// Decode the JSON string back into a map
      Map<String, dynamic> summaryMap = json.decode(userSummary);
// Access the 'from' value from the map
      fromValue = summaryMap['from'];
      toValue = summaryMap['to'];
      name = summaryMap['name'];
      address = summaryMap['address'];
      tin = summaryMap['tin'];
      vrn = summaryMap['vrn'];
      serial = summaryMap['serial'];
      uin = summaryMap['uin'];
      taxoffice = summaryMap['taxoffice'];
      totalAmountSum = summaryMap['totalAmountSum'];
      dataListLength = summaryMap['length'];
      mobile = summaryMap['mobile'];


      setState(() {
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
              // Move to set date page
              Navigator.pushReplacement(
                context,
                // MaterialPageRoute(builder: (context) => choose_receiptScreen()),
                MaterialPageRoute(builder: (context) => change_summary_date()),
              );
            },
            child: Container(
              padding: EdgeInsets.only(right: 25),
              child: Icon(
                  Icons.summarize_outlined,
                  color: Colors.black45
              ),
            ),
          ),
        ],
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: AppText(
            text: "Summary",
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator())
          :Material(
        child: Container(
          color: Colors.black54,
          child: Center(
            child: Container(
              height: 600,
              width: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          width:
                          400, // Set a fixed width for horizontal scrolling
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.stretch,
                            children: <Widget>[

                              SizedBox(height: 16.0),
                              Image.asset(
                                  tra_img,
                                  height:120
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                '${name} \nP.O.O BOX:${address}  \nMobile:${mobile}\nTin ${tin}\nVRN:${vrn}\nSERIAL NO:${serial}\nUIN:${uin}\nTAX OFFICE:${taxoffice}',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Receipt',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 15.0),
                              const MySeparator(color: Colors.grey),
                              SizedBox(height: 10.0),
                              Text(
                                'CURRENT DATE TIME',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16.0, fontFamily: 'Receipt'),
                              ),
                              _buildRowWithColumns(
                                leftColumn: '${toValue}',
                                rightColumn: '00:00:00',
                              ),
                              SizedBox(height: 15.0),
                              const MySeparator(color: Colors.grey),
                              SizedBox(height: 10.0),
                              Text(
                                'REPORT BY DATE',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16.0, fontFamily: 'Receipt'),
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'FROM',
                                rightColumn: '${fromValue}',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'TO',
                                rightColumn: '${toValue}',
                              ),

                              SizedBox(height: 15.0),
                              const MySeparator(color: Colors.grey),
                              SizedBox(height: 10.0),
                              Text(
                                'DEFAULT TAX RATES',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16.0, fontFamily: 'Receipt'),
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'A',
                                rightColumn: '0.00',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'B',
                                rightColumn: '0.00',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'C',
                                rightColumn: '0.00',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'D',
                                rightColumn: '0.00',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'E',
                                rightColumn: '0.00',
                              ),
                              SizedBox(height: 15.0),
                              const MySeparator(color: Colors.grey),
                              SizedBox(height: 10.0),
                              Text(
                                'TURNOVERS',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16.0, fontFamily: 'Receipt'),
                              ),
                              SizedBox(height: 5.0),
                              _buildRowWithColumns(
                                leftColumn: 'TURNOVER TOTAL *A',
                                rightColumn: '0.00',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'TAX *A',
                                rightColumn: '0.00',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'TURNOVER TOTAL *B',
                                rightColumn: '0.00',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'TAX *B',
                                rightColumn: '0.00',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'TURNOVER TOTAL *C',
                                rightColumn: '0.00',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'TAX *C',
                                rightColumn: '0.00',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'TURNOVER TOTAL *D',
                                rightColumn: '0.00',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'TAX *D',
                                rightColumn: '0.00',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'TURNOVER TOTAL *E',
                                rightColumn: '0.00',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'TAX  *E',
                                rightColumn: '${totalAmountSum}',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'NET(A+B+C+D+E)',
                                rightColumn: '${totalAmountSum}',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'TURNOVER(EX)',
                                rightColumn: '0.00',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'TURNOVER(S.R)',
                                rightColumn: '0.00',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'LEGAL RECEIPT',
                                rightColumn: '${dataListLength}',
                              ),

                              // SizedBox(height: 20.0), // Add some space between the summary and the image
                              // Center(
                              //   child: Image.asset(
                              //     imagePath,
                              //     height: 150, // Set the desired height for the image
                              //     width: 150, // Set the desired width for the image
                              //   ),
                              // ),


                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRowWithColumns(
      {required String leftColumn, required String rightColumn}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          leftColumn,
          style: TextStyle(fontSize: 16.0, fontFamily: 'Receipt'),
        ),
        Text(
          rightColumn,
          style: TextStyle(
            fontSize: 16.0,
            fontFamily: 'Receipt',
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }


// fetchSummary() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   var username = prefs.getString('username');
//   var password = prefs.getString('user_password');
//
//   String auth = await authentication(username!, password.toString());
//
//   if (auth != null) {
//     DateTime currentDate = DateTime.now();
//     // Format the current date to match the desired format
//     String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
//
//     // Assign the formatted date to the variable
//     var dateTo = formattedDate;
//     String userSummary = await retireve_summary(auth,dateTo);
//
//     print(userSummary);
//     // return '123';
//
//     return userSummary;
//
//   }
// }


}

class MyBlinkingButton extends StatefulWidget {
  final List<Element> elements;
  const MyBlinkingButton({Key? key, required this.elements}) : super(key: key);
  @override
  _MyBlinkingButtonState createState() => _MyBlinkingButtonState();
}

class _MyBlinkingButtonState extends State<MyBlinkingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController =
    new AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: MaterialButton(
        onPressed: () {},
        child: IconButton(
            icon: Image.asset('assets/icons/print_3.png'),
            color: Colors.black,
            onPressed: () {
            }),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class MySeparator extends StatelessWidget {
  const MySeparator({Key? key, this.height = 1, this.color = Colors.black})
      : super(key: key);
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 10.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
