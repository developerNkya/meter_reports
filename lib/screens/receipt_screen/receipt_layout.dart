import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grocery_app/APIS/handle_receipt.dart';
import 'package:grocery_app/screens/receipt_screen/print_receipt.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../APIS/authentication.dart';
import '../../common_widgets/app_text.dart';

class Element {
  final int id;
  final String date;
  final String time;
  final String fuelGrade;
  final int amount;
  final String dc;
  final String gc;
  final String zNum;
  final String rctvNum;
  final String qty;
  final String nozzle;
  final String? name;
  final String? address;
  final String? mobile;
  final String? tin;
  final String? vrn;
  final String? serial;
  final String? uin;
  final String? regid;
  final String? taxOffice;
  final String? pump;
  final String? fuel_grade;
  final String? concatenated_time;


  Element(
    this.id,
    this.date,
    this.time,
    this.fuelGrade,
    this.amount,
    this.dc,
    this.gc,
    this.zNum,
    this.rctvNum,
    this.qty,
    this.nozzle,
    this.name,
    this.address,
    this.mobile,
    this.tin,
    this.vrn,
    this.serial,
    this.uin,
    this.regid,
    this.taxOffice,
    this.pump,
    this.fuel_grade,
    this.concatenated_time

  );

  @override
  String toString() {
    return 'Element(pump: $pump, id: $id, date: $date, time: $time, fuelGrade: $fuelGrade, amount: $amount, dc: $dc, gc: $gc, zNum: $zNum, rctvNum: $rctvNum, qty: $qty, nozzle: $nozzle, name: $name, address: $address, mobile: $mobile, tin: $tin, vrn: $vrn, serial: $serial, uin: $uin, regid: $regid, taxOffice: $taxOffice)';
  }
}

class CoolReceiptPage extends StatefulWidget {
  final int? id;

  CoolReceiptPage({
    this.id,
  });

  @override
  State<CoolReceiptPage> createState() => _CoolReceiptPageState();
}

class _CoolReceiptPageState extends State<CoolReceiptPage> {
  final String imagePath = "assets/images/sample_qr.png";

  List<Element> _elements = [];
  bool _isLoading = true;
  var receipt_data;
  double _kSize = 100;
  final String tra_img = "assets/images/tra_img3.png";
  late String concatenated_time;

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

    if (auth != null) {
      String userReceipts = await handle_receipt(auth, widget.id.toString());

      Map<String, dynamic> parsedResponse = json.decode(userReceipts);
      // List<dynamic> dataList = parsedResponse['data'];

      print('object');

      receipt_data = parsedResponse['data'];
      print(receipt_data['id']);

       concatenated_time = receipt_data['TIME'].replaceAll(":", "");


      setState(() {
        Element element = Element(
          receipt_data['id'],
          receipt_data['DATE'],
          receipt_data['TIME'],
          receipt_data['FUEL_GRADE'],
          receipt_data['AMOUNT'],
          receipt_data['DC'],
          receipt_data['GC'],
          receipt_data['ZNUM'],
          receipt_data['RCTVNUM'],
          receipt_data['QTY'],
          receipt_data['NOSSEL'],
          receipt_data['name'],
          receipt_data['address'],
          receipt_data['mobile'],
          receipt_data['tin'],
          receipt_data['vrn'],
          receipt_data['serial'],
          receipt_data['uin'],
          receipt_data['regid'],
          receipt_data['taxoffice'],
          receipt_data['PUMP'],
          receipt_data['FUEL_GRADE'],
          concatenated_time
        );

        _elements.add(element);

        print('--------------------------------');
        print(_elements);

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
                MaterialPageRoute(
                  builder: (context) => ReceiptScreen(
                    id: _elements[0].id,
                    date: _elements[0].date,
                    time: _elements[0].time,
                    fuelGrade: _elements[0].fuelGrade,
                    amount: _elements[0].amount,
                    dc: _elements[0].dc,
                    gc: _elements[0].gc,
                    zNum: _elements[0].zNum,
                    rctvNum: _elements[0].rctvNum,
                    qty: _elements[0].qty,
                    nozzle: _elements[0].nozzle,
                    name: _elements[0].name,
                    address: _elements[0].address,
                    mobile: _elements[0].mobile,
                    tin: _elements[0].tin,
                    vrn: _elements[0].vrn,
                    serial: _elements[0].serial,
                    uin: _elements[0].uin,
                    regid: _elements[0].regid,
                    taxOffice: _elements[0].taxOffice,
                    pump: _elements[0].pump,


                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.only(right: 25),
              child: MyBlinkingButton(elements: _elements),
            ),
          ),
        ],
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: AppText(
            text: "Receipts",
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: Container(
                  height: 50,
                  child: LoadingAnimationWidget.twistingDots(
                      leftDotColor: Colors.black54,
                      rightDotColor: Colors.lightBlue,
                      size: _kSize)))
          // ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : Material(
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
                                    Text(
                                      'START OF LEGAL RECEIPT',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Receipt',
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 16.0),
                                    Image.asset(
                                        tra_img,
                                        height:120
                                    ),
                                    SizedBox(height: 16.0),
                                    Text(
                                      '${_elements[0].name ?? 'N/A'}\nMobile:${_elements[0].mobile ?? ''}\nTin ${_elements[0].tin ?? 'N/A'}\nVRN: ${_elements[0].vrn ?? 'N/A'}\nSERIAL NO: ${_elements[0].serial ?? 'N/A'}\nUIN:${_elements[0].uin ?? 'N/A'}\nTAX OFFICE: ${_elements[0].taxOffice ?? 'N/A'}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: 'Receipt',
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 15.0),
                                    const MySeparator(color: Colors.grey),
                                    SizedBox(height: 15.0),
                                    _buildRowWithColumns(
                                      leftColumn: 'RECEIPT NUMBER:',
                                      rightColumn:
                                          '${_elements[0].id ?? 'N/A'}',
                                    ),
                                    _buildRowWithColumns(
                                      leftColumn: 'Z NO:',
                                      rightColumn:
                                          '${_elements[0].zNum ?? 'N/A'}',
                                    ),
                                    _buildRowWithColumns(
                                      leftColumn:
                                          'DATE: ${_elements[0].date ?? 'N/A'}',
                                      rightColumn:
                                          'TIME: ${_elements[0].time ?? 'N/A'}',
                                    ),
                                    SizedBox(height: 15.0),
                                    const MySeparator(color: Colors.grey),
                                    SizedBox(height: 15.0),
                                    _buildRowWithColumns(
                                      leftColumn:
                                      'PUMP: ${_elements[0].pump ?? '1'}'+' NOZZLE:${_elements[0].pump ?? 'N/A'}',
                                      rightColumn:
                                      '',
                                    ),
                                    _buildRowWithColumns(
                                      leftColumn: '${_elements[0].fuelGrade ?? 'N/A'}',
                                      rightColumn: '',
                                    ),
                                    SizedBox(height: 15.0),
                                    const MySeparator(color: Colors.grey),
                                    SizedBox(height: 15.0),
                                    _buildRowWithColumns(
                                      leftColumn: 'TOTAL EXCL TAX: ',
                                      rightColumn: '${_elements[0].amount ?? 'N/A'}',
                                    ),
                                    _buildRowWithColumns(
                                      leftColumn: 'TOTAL TAX:',
                                      rightColumn: '0',
                                    ),
                                    _buildRowWithColumns(
                                      leftColumn: 'TOTAL INCL TAX:',
                                      rightColumn: '${_elements[0].amount ?? 'N/A'}',
                                    ),
                                    SizedBox(height: 15.0),
                                    const MySeparator(color: Colors.grey),
                                    SizedBox(height: 15.0),
                                    Text(
                                      'RECEIPT VERIFICATION NUMBER',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: 'Receipt',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      '${_elements[0].rctvNum ?? 'N/A'}',
                                      style: TextStyle(
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Receipt',
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 32.0),
                                    Center(
                                      child: QrImageView(
                                        data: 'https://virtual.tra.go.tz/efdmsRctVerify/${_elements[0].rctvNum}_${concatenated_time}',
                                        version: QrVersions.auto,
                                        size: 200,
                                        gapless: false,
                                      ),
                                    ),

                                    SizedBox(height: 15.0),
                                    Text(
                                      '** END OF LEGAL RECEIPT **',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: 'Receipt',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 8.0),
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ReceiptScreen(
                    id: widget.elements[0].id,
                    date: widget.elements[0].date,
                    time: widget.elements[0].time,
                    fuelGrade: widget.elements[0].fuelGrade,
                    amount: widget.elements[0].amount,
                    dc: widget.elements[0].dc,
                    gc: widget.elements[0].gc,
                    zNum: widget.elements[0].zNum,
                    rctvNum: widget.elements[0].rctvNum,
                    qty: widget.elements[0].qty,
                    nozzle: widget.elements[0].nozzle,
                    name: widget.elements[0].name,
                    address: widget.elements[0].address,
                    mobile: widget.elements[0].mobile,
                    tin: widget.elements[0].tin,
                    vrn: widget.elements[0].vrn,
                    serial: widget.elements[0].serial,
                    uin: widget.elements[0].uin,
                    regid: widget.elements[0].regid,
                    taxOffice: widget.elements[0].taxOffice,
                  ),
                ),
              );
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
