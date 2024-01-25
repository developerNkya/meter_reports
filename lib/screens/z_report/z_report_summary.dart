import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_app/APIS/single_z_report.dart';
import 'package:grocery_app/screens/summary/change_summary_date.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../APIS/authentication.dart';
import '../../../common_widgets/app_text.dart';
import 'package:pdf/widgets.dart' as pw;
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

class z_report_summary extends StatefulWidget {
  final int? id;
  final String? dateTo;
  final String? dateFrom;


  z_report_summary({
    this.id,
    this.dateTo,
    this.dateFrom,
  });

  @override
  State< z_report_summary> createState() => _z_report_summaryState();
}

class _z_report_summaryState extends State<z_report_summary> {
  final String imagePath = "assets/images/sample_qr.png";
  final String tra_img = "assets/images/tra_img3.png";

  List<Element> _elements = [];
  bool _isLoading = true;
  var receipt_data,dateTo;
  double _kSize = 100;
  late double displayed_summary;

  late String fromValue ='';
  late String toValue ='',mobile ='';
   late String name='',address='',tin='',vrn ='',serial='',uin='',taxoffice ='';
  late double totalAmountSum=0;
  late int dataListLength=0;
  late int ticket =0;
  late String amount='';
  var actualTime,actualDate,ZNUMBER;



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
    var now = DateTime.now();
    var formatterDate = DateFormat('dd-MM-yy');
    ZNUMBER = DateFormat('dd MM yy');
    var formatterTime = DateFormat('hh:mm:ss');
    actualDate = formatterDate.format(now);
    actualTime = formatterTime.format(now);

    DateTime currentDate = DateTime.now();
    DateTime endOfDay = DateTime(currentDate.year, currentDate.month, currentDate.day, 23, 59, 59);
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(endOfDay);
    dateTo = formattedDate;

    String userSummary = await single_z(auth, dateTo,widget.id.toString()) ?? '';
// Decode the JSON string back into a ma


    Map<String, dynamic> summaryMap = json.decode(userSummary);

// Extract values from the 'data' field
    Map<String, dynamic> data = summaryMap['data'];
    int id = data['id'];
    String dailyTotalAmount = data['DAILYTOTALAMOUNT'];
    int ticketCount = data['TICKETSFISCAL'];
    double grossAmount = double.parse(data['GROSS']);
    double nettAmount = double.parse(data['NETTAMOUNT_E']);
    double taxAmount = double.parse(data['TAXAMOUNT_E']);
    String znumber = data['znumber'];

// Extract other values
      name = data['name'];
    address = data['address'];
     tin = data['tin'];
     vrn = data['vrn'];
     serial = data['serial'];
     uin = data['uin'];
     taxoffice = data['taxoffice'];
     mobile = data['mobile'];
     ticket = data['TICKETSFISCAL'];
      amount = data['DAILYTOTALAMOUNT'];

// Calculate the total amount sum
    double totalAmountSum = double.parse(dailyTotalAmount);

// Set other values
    String fromValue = "${widget.dateFrom}"; // Replace with your actual 'from' value if available
    String toValue = '${widget.dateTo}'; // Assuming 'toDate' is defined elsewhere
    int dataListLength = 1; // Since you are processing a single record, the length is 1

// Print the extracted values
    print('from: $fromValue');
    print('to: $toValue');
    print('name: $name');
    print('address: $address');
    print('tin: $tin');
    print('vrn: $vrn');
    print('serial: $serial');
    print('uin: $uin');
    print('taxoffice: $taxoffice');
    print('totalAmountSum: $totalAmountSum');
    print('dataListLength: $dataListLength');
    print('mobile: $mobile');
// Access the 'from' value from the map
//       fromValue = '${fromValue}';
//       toValue = summaryMap['to'];

//       address = summaryMap['address'];
//       tin = summaryMap['tin'];
//       vrn = summaryMap['vrn'];
//       serial = summaryMap['serial'];
//       uin = summaryMap['uin'];
//       taxoffice = summaryMap['taxoffice'];
//       totalAmountSum = summaryMap['totalAmountSum'];
//       dataListLength = summaryMap['length'];
//       mobile = summaryMap['mobile'];


    setState(() {
      _isLoading = false;
    });

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
            onTap: () async {

              final traLogo = pw.MemoryImage((await rootBundle.load('assets/images/tra_img3.png')).buffer.asUint8List(),);

              String newDate =  ZNUMBER.toString().replaceAll('-', '');
              // String formattedAmount = widget.amount! % 1 == 0
              //     ? '${widget.amount!.toStringAsFixed(0)}.00'
              //     : widget.amount!.toStringAsFixed(2);

              String? formattedAmount =  '';
              String? formattedTax =  '';


              // Generate PDF content
              final pdf = pw.Document();
              //add new font::
              final font = await rootBundle.load("assets/fonts/FAKERECE.ttf");
              final ttf = pw.Font.ttf(font);
              pdf.addPage(
                pw.Page(
                  pageFormat: PdfPageFormat(14 * PdfPageFormat.cm, 30 * PdfPageFormat.cm, marginAll: 0.5 * PdfPageFormat.cm),
                  build: (pw.Context context) {
                    return pw.Container(
                      padding: pw.EdgeInsets.all(16.0),
                      width: 400,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                        children: <pw.Widget>[
                          pw.SizedBox(height: 3.0),
                          pw.Center(
                            child:  pw.Container(
                              height: 130.0,
                              child: pw.Image(traLogo,),
                            ),
                          ),

                          pw.SizedBox(height: 3.0),
                          pw.Text(
                            '${name ?? 'N/A'}\nMobile:${mobile ?? 'N/A'}\nTin:${tin ?? 'N/A'}\nVRN:${vrn ?? 'N/A'}\nSERIAL NO:${serial ?? 'N/A'}\nUIN:${uin ?? 'N/A'}\nTAX OFFICE:${taxoffice ?? 'N/A'}',
                            style: pw.TextStyle(
                                fontSize: 16.0,
                                font:ttf
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                          pw.SizedBox(height: 08.0),
                          // Create a dotted line separator
                          pw.Divider(
                            height: 1.0,
                            color: PdfColors.grey,
                            // dash: 2,
                          ),

                          // pw.Container(
                          //   child: MySeparator(color: Colors.grey),
                          // ),


                          // MySeparator(color: Colors.grey),

                          //Dublicate title:::
                          pw.Text(
                            'CURRENT DATE TIME',
                            style: pw.TextStyle(
                                fontSize: 14.0,
                                fontWeight: pw.FontWeight.bold,
                                font:ttf
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                          pw.SizedBox(height: 5.0),

                          pw.Row(
                            children: <pw.Widget>[
                              pw.Expanded(
                                child: pw.Text(
                                '${actualDate ?? 'N/A'}',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: pw.FontWeight.bold,
                                      font:ttf

                                  ),

                                ),
                              ),
                              pw.Expanded(
                                child: pw.Text(
                                  '${actualTime ?? 'N/A'}',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      font:ttf
                                  ),
                                  textAlign: pw.TextAlign.right,
                                  // fontFamily: 'Receipt',
                                ),
                              ),

                            ],
                          ),
                          //z-no

                          pw.SizedBox(height: 15.0),
                          pw.Divider(
                            height: 1.0,
                            color: PdfColors.grey,
                            // dash: 2,
                          ),
                          pw.Text(
                            'REPORT BY DATE',
                            style: pw.TextStyle(
                                fontSize: 14.0,
                                fontWeight: pw.FontWeight.bold,
                                font:ttf
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                          pw.SizedBox(height: 5.0),
                          // pw.SizedBox(height: 15.0),
                          //pump
                          pw.Row(
                            children: <pw.Widget>[

                              pw.Expanded(
                                child: pw.Text(
                                  'FROM',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: pw.FontWeight.bold,
                                      font:ttf
                                  ),
                                ),
                              ),
                              pw.Expanded(
                                child: pw.Text(
                                  '${widget.dateFrom?? ''}',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      font:ttf
                                    // fontFami: 'Receipt',
                                  ),
                                  textAlign: pw.TextAlign.right,
                                  // fontFamily: 'Receipt',
                                ),
                              ),
                            ],
                          ),
                          pw.Row(
                            children: <pw.Widget>[

                              pw.Expanded(
                                child: pw.Text(
                                  'TO',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: pw.FontWeight.bold,
                                      font:ttf
                                  ),
                                ),
                              ),
                              pw.Expanded(
                                child: pw.Text(
                                  '${widget.dateTo ?? ''}',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      font:ttf
                                    // fontFami: 'Receipt',
                                  ),
                                  textAlign: pw.TextAlign.right,
                                  // fontFamily: 'Receipt',
                                ),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 15.0),
                          pw.Divider(
                            height: 1.0,
                            color: PdfColors.grey,
                            // dash: 2,
                          ),
                          pw.SizedBox(height: 15.0),

                          pw.Text(
                            'DEFAULT TAX RATES',
                            style: pw.TextStyle(
                                fontSize: 14.0,
                                fontWeight: pw.FontWeight.bold,
                                font:ttf
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                          pw.SizedBox(height: 5.0),

                          //excl
                          pw.Row(
                            children: <pw.Widget>[
                              pw.Expanded(
                                child: pw.Text(
                                  'A',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: pw.FontWeight.bold,
                                      font:ttf
                                  ),
                                ),
                              ),
                              pw.Expanded(
                                child: pw.Text(
                                  '0.00',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      font:ttf
                                  ),
                                  textAlign: pw.TextAlign.right,
                                  // fontFamily: 'Receipt',
                                ),
                              ),
                            ],
                          ),

                          pw.Row(
                            children: <pw.Widget>[
                              pw.Expanded(
                                child: pw.Text(
                                  'B',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: pw.FontWeight.bold,
                                      font:ttf
                                  ),
                                ),
                              ),
                              pw.Expanded(
                                child: pw.Text(
                                  '0.00',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      font:ttf
                                  ),
                                  textAlign: pw.TextAlign.right,
                                  // fontFamily: 'Receipt',
                                ),
                              ),
                            ],
                          ),
                          pw.Row(
                            children: <pw.Widget>[
                              pw.Expanded(
                                child: pw.Text(
                                  'C',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: pw.FontWeight.bold,
                                      font:ttf
                                  ),
                                ),
                              ),
                              pw.Expanded(
                                child: pw.Text(
                                  '0.00',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      font:ttf
                                  ),
                                  textAlign: pw.TextAlign.right,
                                  // fontFamily: 'Receipt',
                                ),
                              ),
                            ],
                          ),
                          pw.Row(
                            children: <pw.Widget>[
                              pw.Expanded(
                                child: pw.Text(
                                  'D',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: pw.FontWeight.bold,
                                      font:ttf
                                  ),
                                ),
                              ),
                              pw.Expanded(
                                child: pw.Text(
                                  '0.00',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      font:ttf
                                  ),
                                  textAlign: pw.TextAlign.right,
                                  // fontFamily: 'Receipt',
                                ),
                              ),
                            ],
                          ),
                          pw.Row(
                            children: <pw.Widget>[
                              pw.Expanded(
                                child: pw.Text(
                                  'E',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: pw.FontWeight.bold,
                                      font:ttf
                                  ),
                                ),
                              ),
                              pw.Expanded(
                                child: pw.Text(
                                  '0.00',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      font:ttf
                                  ),
                                  textAlign: pw.TextAlign.right,
                                  // fontFamily: 'Receipt',
                                ),
                              ),
                            ],
                          ),

                          pw.SizedBox(height: 15.0),
                          pw.Divider(
                            height: 1.0,
                            color: PdfColors.grey,
                            // dash: 2,
                          ),
                          pw.SizedBox(height: 15.0),
                          pw.Text(
                            'TURNOVERS',
                            style: pw.TextStyle(
                                fontSize: 14.0,
                                fontWeight: pw.FontWeight.bold,
                                font:ttf
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                          pw.SizedBox(height: 5.0),

                          pw.Row(
                            children: <pw.Widget>[
                              pw.Expanded(
                                child: pw.Text(
                                  'TURNOVER TOTAL *A',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: pw.FontWeight.bold,
                                      font:ttf

                                  ),

                                ),
                              ),
                              pw.Expanded(
                                child: pw.Text(
                                  '0.00',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      font:ttf
                                  ),
                                  textAlign: pw.TextAlign.right,
                                  // fontFamily: 'Receipt',
                                ),
                              ),

                            ],
                          ),
                          pw.Row(
                            children: <pw.Widget>[
                              pw.Expanded(
                                child: pw.Text(
                                  'TAX *A',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: pw.FontWeight.bold,
                                      font:ttf

                                  ),

                                ),
                              ),
                              pw.Expanded(
                                child: pw.Text(
                                  '0.00',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      font:ttf
                                  ),
                                  textAlign: pw.TextAlign.right,
                                  // fontFamily: 'Receipt',
                                ),
                              ),

                            ],
                          ),
                          pw.Row(
                            children: <pw.Widget>[
                              pw.Expanded(
                                child: pw.Text(
                                  'TURNOVER TAX *B',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: pw.FontWeight.bold,
                                      font:ttf

                                  ),

                                ),
                              ),
                              pw.Expanded(
                                child: pw.Text(
                                  '0.00',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      font:ttf
                                  ),
                                  textAlign: pw.TextAlign.right,
                                  // fontFamily: 'Receipt',
                                ),
                              ),

                            ],
                          ),
                          pw.Row(
                            children: <pw.Widget>[
                              pw.Expanded(
                                child: pw.Text(
                                  'TAX *B',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: pw.FontWeight.bold,
                                      font:ttf

                                  ),

                                ),
                              ),
                              pw.Expanded(
                                child: pw.Text(
                                  '0.00',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      font:ttf
                                  ),
                                  textAlign: pw.TextAlign.right,
                                  // fontFamily: 'Receipt',
                                ),
                              ),

                            ],
                          ),
                          pw.Row(
                            children: <pw.Widget>[
                              pw.Expanded(
                                child: pw.Text(
                                  'TURNOVER TOTAL *C',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: pw.FontWeight.bold,
                                      font:ttf

                                  ),

                                ),
                              ),
                              pw.Expanded(
                                child: pw.Text(
                                  '0.00',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      font:ttf
                                  ),
                                  textAlign: pw.TextAlign.right,
                                  // fontFamily: 'Receipt',
                                ),
                              ),

                            ],
                          ),
                          pw.Row(
                            children: <pw.Widget>[
                              pw.Expanded(
                                child: pw.Text(
                                  'TAX *C',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: pw.FontWeight.bold,
                                      font:ttf

                                  ),

                                ),
                              ),
                              pw.Expanded(
                                child: pw.Text(
                                  '0.00',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      font:ttf
                                  ),
                                  textAlign: pw.TextAlign.right,
                                  // fontFamily: 'Receipt',
                                ),
                              ),

                            ],
                          ),
                          pw.Row(
                            children: <pw.Widget>[
                              pw.Expanded(
                                child: pw.Text(
                                  'TURNOVER TOTAL *D',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: pw.FontWeight.bold,
                                      font:ttf

                                  ),

                                ),
                              ),
                              pw.Expanded(
                                child: pw.Text(
                                  '0.00',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      font:ttf
                                  ),
                                  textAlign: pw.TextAlign.right,
                                  // fontFamily: 'Receipt',
                                ),
                              ),

                            ],
                          ),
                          pw.Row(
                            children: <pw.Widget>[
                              pw.Expanded(
                                child: pw.Text(
                                  'TAX *D',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: pw.FontWeight.bold,
                                      font:ttf

                                  ),

                                ),
                              ),
                              pw.Expanded(
                                child: pw.Text(
                                  '0.00',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      font:ttf
                                  ),
                                  textAlign: pw.TextAlign.right,
                                  // fontFamily: 'Receipt',
                                ),
                              ),

                            ],
                          ),
                          pw.Row(
                            children: <pw.Widget>[
                              pw.Expanded(
                                child: pw.Text(
                                  'TURNOVER TOTAL *E',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: pw.FontWeight.bold,
                                      font:ttf

                                  ),

                                ),
                              ),
                              pw.Expanded(
                                child: pw.Text(
                                  '0.00',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      font:ttf
                                  ),
                                  textAlign: pw.TextAlign.right,
                                  // fontFamily: 'Receipt',
                                ),
                              ),

                            ],
                          ),
                          pw.Row(
                            children: <pw.Widget>[
                              pw.Expanded(
                                child: pw.Text(
                                  'TAX *E',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: pw.FontWeight.bold,
                                      font:ttf

                                  ),

                                ),
                              ),
                              pw.Expanded(
                                child: pw.Text(
                                  '$amount',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      font:ttf
                                  ),
                                  textAlign: pw.TextAlign.right,
                                  // fontFamily: 'Receipt',
                                ),
                              ),

                            ],
                          ),
                          pw.Row(
                            children: <pw.Widget>[
                              pw.Expanded(
                                child: pw.Text(
                                  'NET(A+B+C+D+E)',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: pw.FontWeight.bold,
                                      font:ttf

                                  ),

                                ),
                              ),
                              pw.Expanded(
                                child: pw.Text(
                                  '$amount',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      font:ttf
                                  ),
                                  textAlign: pw.TextAlign.right,
                                  // fontFamily: 'Receipt',
                                ),
                              ),

                            ],
                          ),
                          pw.Row(
                            children: <pw.Widget>[
                              pw.Expanded(
                                child: pw.Text(
                                  'TURNOVER(EX)',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: pw.FontWeight.bold,
                                      font:ttf

                                  ),

                                ),
                              ),
                              pw.Expanded(
                                child: pw.Text(
                                  '0.00',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      font:ttf
                                  ),
                                  textAlign: pw.TextAlign.right,
                                  // fontFamily: 'Receipt',
                                ),
                              ),

                            ],
                          ),
                          pw.Row(
                            children: <pw.Widget>[
                              pw.Expanded(
                                child: pw.Text(
                                  'TURNOVER(SR)',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: pw.FontWeight.bold,
                                      font:ttf

                                  ),

                                ),
                              ),
                              pw.Expanded(
                                child: pw.Text(
                                  '0.00',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      font:ttf
                                  ),
                                  textAlign: pw.TextAlign.right,
                                  // fontFamily: 'Receipt',
                                ),
                              ),

                            ],
                          ),
                          pw.Row(
                            children: <pw.Widget>[
                              pw.Expanded(
                                child: pw.Text(
                                  'LEGAL RECEIPT',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: pw.FontWeight.bold,
                                      font:ttf

                                  ),

                                ),
                              ),
                              pw.Expanded(
                                child: pw.Text(
                                  '$ticket',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      font:ttf
                                  ),
                                  textAlign: pw.TextAlign.right,
                                  // fontFamily: 'Receipt',
                                ),
                              ),

                            ],
                          ),


                          //THE BOUNDARY:::
                          // ... Continue adding other widgets ...
                        ],
                      ),
                    );
                  },
                ),
              );





              // Save the PDF to a temporary file
              final output = await getTemporaryDirectory();
              final file = File('${output.path}/receipt.pdf');
              await file.writeAsBytes(await pdf.save());

              // Open share dialog
              Share.shareFiles(['${file.path}'],
                  text: 'Share Receipt PDF',
                  subject: 'Receipt PDF');
            },
            child: Container(
              padding: EdgeInsets.only(right: 25),
              child: Icon(
                Icons.share,
                color: Colors.black,
              ),
            ),
          ),
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
            text: "Z-Report Summary",
            fontWeight: FontWeight.bold,
            fontSize: 19,
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
                                '$name \nP.O.BOX:$address  \nMobile:$mobile\nTin $tin\nVRN:$vrn\nSERIAL NO:$serial\nUIN:$uin\nTAX OFFICE:$taxoffice',
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
                                leftColumn: '$actualDate',
                                rightColumn: '$actualTime',
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
                                rightColumn: '${widget.dateFrom?? ''}',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'TO',
                                rightColumn: '${widget.dateTo ?? ''}',
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
                                rightColumn: '$amount',
                              ),
                              _buildRowWithColumns(
                                leftColumn: 'NET(A+B+C+D+E)',
                                rightColumn: '$amount',
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
                                rightColumn: '$ticket',
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
