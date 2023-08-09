import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:grocery_app/APIS/fetchSummarydata.dart';
import 'package:grocery_app/screens/receipt_screen/receipt_layout.dart';
import 'package:grocery_app/screens/summary/change_summary_date.dart';
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

class filtered_summary extends StatefulWidget {
  final DateTime? fromDate;
  final TimeOfDay? fromTime;
  final TimeOfDay? toTime;
  final DateTime? toDate;
  double _kSize = 100;

  filtered_summary({
    this.fromDate,
    this.fromTime,
    this.toDate,
    this.toTime,
  });

  @override
  _filtered_summaryState createState() => _filtered_summaryState();
}

class _filtered_summaryState extends State<filtered_summary> {
  List<Element> _elements = [];
  bool _isLoading = true;
  double _kSize = 100;
  final String tra_img = "assets/images/tra_img3.png";

  late String fromValue;
  late String toValue,mobile,dateFrom,to;
  late String name,address,tin,vrn,serial,uin,taxoffice;
  late double totalAmountSum;
  late int dataListLength;

  var actualTime,actualDate;

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
    var now = DateTime.now();
    var formatterDate = DateFormat('dd-MM-yy');
    var formatterTime = DateFormat('hh:mm:ss');
    actualDate = formatterDate.format(now);
    actualTime = formatterTime.format(now);
    // Get the current date
    var dateFrom = widget.fromDate.toString();
    // Get the current date
    DateTime currentDate = widget.toDate as DateTime;
    // Format the current date to match the desired format
    String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

    // Assign the formatted date to the variable
    var dateTo = formattedDate;

    String filtered_summary = await fetchSummarydata(auth, dateFrom, dateTo) ?? '';

    if (filtered_summary  != ''){
      Map<String, dynamic> summaryMap = json.decode(filtered_summary);

      String value_from_api = summaryMap['from'];
      DateTime fromDate = DateTime.parse(value_from_api);
       fromValue = DateFormat('yyyy-MM-dd').format(fromDate);

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

      // dateTo = summaryMap['dateTo'];


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

                              _buildRowWithColumns(
                                leftColumn: 'Z NUMBER:',
                                rightColumn: '',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'DATE:${actualDate}',
                                rightColumn: '',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'TIME:${actualTime}',
                                rightColumn: '',
                              ),
                              SizedBox(height: 15.0),
                              const MySeparator(color: Colors.grey),
                              SizedBox(height: 10.0),

                              _buildRowWithColumns(
                                leftColumn: 'DISCOUNTS',
                                rightColumn: '0',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'SUBCHARGES',
                                rightColumn: '0',
                              ),

                              SizedBox(height: 8.0),
                              const MySeparator(color: Colors.grey),
                              SizedBox(height: 10.0),

                              _buildRowWithColumns(
                                leftColumn: 'TICKETS VOID:',
                                rightColumn: '0',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'TICKETS VOID TOTAL:',
                                rightColumn: '0',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'CORRECTIONS:',
                                rightColumn: '0',
                              ),
                              SizedBox(height: 8.0),
                              const MySeparator(color: Colors.grey),
                              SizedBox(height: 10.0),

                              _buildRowWithColumns(
                                leftColumn: 'FIRST RECEIPT:',
                                rightColumn: '${fromValue}',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'LAST RECEIPT:',
                                rightColumn: '${toValue}',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'RECEIPTS ISSUED:',
                                rightColumn: '0',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'UNLEADED:',
                                rightColumn: '0',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'AMOUNT:',
                                rightColumn: '0',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'DIESEL:',
                                rightColumn: '0',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'KEROSENE:',
                                rightColumn: '0',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'TOTAL:',
                                rightColumn: '0',
                              ),
                              SizedBox(height: 8.0),
                              const MySeparator(color: Colors.grey),
                              SizedBox(height: 10.0),
                              Text(
                                'PAYMENTS REPORT',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16.0, fontFamily: 'Receipt'),
                              ),
                              SizedBox(height: 8.0),
                              const MySeparator(color: Colors.grey),
                              _buildRowWithColumns(
                                leftColumn: 'CASH:',
                                rightColumn: '0',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'CCARD:',
                                rightColumn: '0',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'CHEQUE:',
                                rightColumn: '0',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'EMONEY:',
                                rightColumn: '0',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'INVOICE:',
                                rightColumn: '0',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'TOTAL:',
                                rightColumn: '0',
                              ),
                              SizedBox(height: 8.0),
                              const MySeparator(color: Colors.grey),
                              SizedBox(height: 10.0),
                              Text(
                                'VAT REPORT',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16.0, fontFamily: 'Receipt'),
                              ),
                              SizedBox(height: 8.0),
                              const MySeparator(color: Colors.grey),
                              SizedBox(height: 5.0),
                              Text(
                                  'VAT A (18.00%)',
                                  style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,)
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'TURNOVER:',
                                rightColumn: '0',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'NET AMOUNT:',
                                rightColumn: '0',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'TAX AMOUNT:',
                                rightColumn: '0',
                              ),
                              SizedBox(height: 8.0),
                              SizedBox(height: 5.0),
                              Text(
                                  'VAT B (0.00%)',
                                  style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,)
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'TURNOVER:',
                                rightColumn: '0',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'NET AMOUNT:',
                                rightColumn: '0',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'TAX AMOUNT:',
                                rightColumn: '0',
                              ),
                              SizedBox(height: 8.0),

                              SizedBox(height: 5.0),
                              Text(
                                  'VAT C (0.00%)',
                                  style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,)
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'TURNOVER:',
                                rightColumn: '0',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'NET AMOUNT:',
                                rightColumn: '0',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'TAX AMOUNT:',
                                rightColumn: '0',
                              ),
                              SizedBox(height: 8.0),

                              SizedBox(height: 5.0),
                              Text(
                                  'VAT D (0.00%)',
                                  style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,)
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'TURNOVER:',
                                rightColumn: '0',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'NET AMOUNT:',
                                rightColumn: '0',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'TAX AMOUNT:',
                                rightColumn: '0',
                              ),
                              SizedBox(height: 8.0),

                              SizedBox(height: 5.0),
                              Text(
                                  'VAT E (0.00%)',
                                  style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,)
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'TURNOVER:',
                                rightColumn: '${totalAmountSum}',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'NET AMOUNT:',
                                rightColumn: '${totalAmountSum}',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'TAX AMOUNT:',
                                rightColumn: '0',
                              ),
                              SizedBox(height: 8.0),
                              const MySeparator(color: Colors.grey),
                              SizedBox(height: 10.0),

                              Text(
                                'DEFAULT TAX RATES',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16.0, fontFamily: 'Receipt'),
                              ),

                              SizedBox(height: 8.0),
                              const MySeparator(color: Colors.grey),
                              SizedBox(height: 10.0),

                              _buildRowWithColumns(
                                leftColumn: 'TURNOVER(A+B+C+D+E):',
                                rightColumn: '${totalAmountSum}',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'NET SUM(A+B+C+D+E):',
                                rightColumn: '${totalAmountSum}',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'VAT (A+B+C+D+E):',
                                rightColumn: '0.00',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'TURNOVER (SR):',
                                rightColumn: '0.00',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'TURNOVER (EX):',
                                rightColumn: '0.00',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'TURNOVER TOTAL:',
                                rightColumn: '${totalAmountSum}',
                              ),
                              SizedBox(height: 15.0),
                              const MySeparator(color: Colors.grey),
                              SizedBox(height: 10.0),

                              _buildRowWithColumns(
                                leftColumn: 'DAILY TOTAL:',
                                rightColumn: '${totalAmountSum}',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'GROSS:',
                                rightColumn: '0.00',
                              ),
                              SizedBox(height: 15.0),
                              const MySeparator(color: Colors.grey),
                              SizedBox(height: 23.0),


                              Text(
                                '***END OF ZREPORT***',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16.0, fontFamily: 'Receipt'),
                              ),

                              SizedBox(height: 60.0),

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
