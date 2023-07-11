import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:image/image.dart' as img;

import '../../common_widgets/app_text.dart';


class ReceiptScreen extends StatefulWidget {
  final int? id;
  final String? date;
  final String? time;
  final String? fuelGrade;
  final int? amount;
  final String? dc;
  final String? gc;
  final String? zNum;
  final String? rctvNum;
  final String? qty;
  final String? nozzle;
  final String? name;
  final String? address;
  final String? mobile;
  final String? tin;
  final String? vrn;
  final String? serial;
  final String? uin;
  final String? regid;
  final String? taxOffice;

  ReceiptScreen({
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
  });

  @override
  _ReceiptScreenState createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  String _info = "";
  String _msj = '';
  bool connected = false;
  List<BluetoothInfo> items = [];
  List<String> _options = ["permission bluetooth granted", "bluetooth enabled", "connection status", "update info"];

  String _selectSize = "2";
  final _txtText = TextEditingController(text: "Hello developer");
  bool _progress = false;
  String _msjprogress = "";

  String optionprinttype = "58 mm";
  List<String> options = ["58 mm", "80 mm"];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (context) => choose_receiptScreen()),
                // );
              },
              child: Container(
                padding: EdgeInsets.only(right: 25),
                child: Icon(
                  Icons.print,
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
              text: "Print Receipts",
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('info: $_info\n '),
                Text(_msj),
                Row(
                  children: [
                    Text("Type print"),
                    SizedBox(width: 10),
                    DropdownButton<String>(
                      value: optionprinttype,
                      items: options.map((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          optionprinttype = newValue!;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        this.getBluetoots();
                      },
                      child: Row(
                        children: [
                          Visibility(
                            visible: _progress,
                            child: SizedBox(
                              width: 25,
                              height: 25,
                              child: CircularProgressIndicator.adaptive(strokeWidth: 1, backgroundColor: Colors.white),
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(_progress ? _msjprogress : "Search"),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: connected ? this.disconnect : null,
                      child: Text("Disconnect"),
                    ),
                    ElevatedButton(
                      onPressed: connected ? this.printTest : null,
                      child: Text("Print"),
                    ),
                  ],
                ),
                Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    child: ListView.builder(
                      itemCount: items.length > 0 ? items.length : 0,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            String mac = items[index].macAdress;
                            this.connect(mac);
                          },
                          title: Text('Name: ${items[index].name}'),
                          subtitle: Text("macAddress: ${items[index].macAdress}"),
                        );
                      },
                    )),
                SizedBox(height: 10),

                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    int porcentbatery = 0;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await PrintBluetoothThermal.platformVersion;
      print("patformversion: $platformVersion");
      porcentbatery = await PrintBluetoothThermal.batteryLevel;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    final bool result = await PrintBluetoothThermal.bluetoothEnabled;
    print("bluetooth enabled: $result");
    if (result) {
      _msj = "Bluetooth enabled, please search and connect";
    } else {
      _msj = "Bluetooth not enabled";
    }

    setState(() {
      _info = platformVersion + " ($porcentbatery% battery)";
    });
  }

  Future<void> getBluetoots() async {
    setState(() {
      _progress = true;
      _msjprogress = "Wait";
      items = [];
    });
    final List<BluetoothInfo> listResult = await PrintBluetoothThermal.pairedBluetooths;

    /*await Future.forEach(listResult, (BluetoothInfo bluetooth) {
      String name = bluetooth.name;
      String mac = bluetooth.macAdress;
    });*/

    setState(() {
      _progress = false;
    });

    if (listResult.length == 0) {
      _msj = "There are no bluetoohs linked, go to settings and link the printer";
    } else {
      _msj = "Touch an item in the list to connect";
    }

    setState(() {
      items = listResult;
    });
  }

  Future<void> connect(String mac) async {
    setState(() {
      _progress = true;
      _msjprogress = "Connecting...";
      connected = false;
    });
    final bool result = await PrintBluetoothThermal.connect(macPrinterAddress: mac);
    print("state conected $result");
    if (result) connected = true;
    setState(() {
      _progress = false;
    });
  }

  Future<void> disconnect() async {
    final bool status = await PrintBluetoothThermal.disconnect;
    setState(() {
      connected = false;
    });
    print("status disconnect $status");
  }

  Future<void> printTest() async {
    bool conexionStatus = await PrintBluetoothThermal.connectionStatus;
    //print("connection status: $conexionStatus");
    if (conexionStatus) {
      List<int> ticket = await testTicket();
      final result = await PrintBluetoothThermal.writeBytes(ticket);
      print("print test result:  $result");
    } else {
      //no conectado, reconecte
    }
  }

  Future<void> printString() async {
    bool conexionStatus = await PrintBluetoothThermal.connectionStatus;
    if (conexionStatus) {
      String enter = '\n';
      await PrintBluetoothThermal.writeBytes(enter.codeUnits);
      //size of 1-5
      String text = "Hello";
      await PrintBluetoothThermal.writeString(printText: PrintTextSize(size: 1, text: text));
      await PrintBluetoothThermal.writeString(printText: PrintTextSize(size: 2, text: text + " size 2"));
      await PrintBluetoothThermal.writeString(printText: PrintTextSize(size: 3, text: text + " size 3"));
    } else {
      //desconectado
      print("desconectado bluetooth $conexionStatus");
    }
  }

  Future<List<int>> testTicket() async {
    List<int> bytes = [];
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(optionprinttype == "58 mm" ? PaperSize.mm58 : PaperSize.mm80, profile);
    //bytes += generator.setGlobalFont(PosFontType.fontA);
    bytes += generator.reset();

    final ByteData data = await rootBundle.load('assets/tra_img.png');
    final Uint8List bytesImg = data.buffer.asUint8List();
    img.Image? image = img.decodeImage(bytesImg);

    if (Platform.isIOS) {
      // Resizes the image to half its original size and reduces the quality to 80%
      final resizedImage = img.copyResize(image!, width: image.width ~/ 1.3, height: image.height ~/ 1.3, interpolation: img.Interpolation.nearest);
      final bytesimg = Uint8List.fromList(img.encodeJpg(resizedImage));
      //image = img.decodeImage(bytesimg);
    }

    //Using `ESC *`
    // bytes += generator.image(image!);

    // bytes += generator.text('Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    // bytes += generator.text('Special 1: ñÑ àÀ èÈ éÉ üÜ çÇ ôÔ', styles: PosStyles(codeTable: 'CP1252'));
    // bytes += generator.text('Special 2: blåbærgrød', styles: PosStyles(codeTable: 'CP1252'));
    //
    // bytes += generator.text('Bold text', styles: PosStyles(bold: true));
    // bytes += generator.text('Reverse text', styles: PosStyles(reverse: true));
    // bytes += generator.text('Underlined text', styles: PosStyles(underline: true), linesAfter: 1);
    // bytes += generator.text('Align left', styles: PosStyles(align: PosAlign.left));
    bytes += generator.text('**START OF LEGAL RECEIPT **', styles: PosStyles(align: PosAlign.center));
    bytes += generator.image(image!);
    bytes += generator.text('FUMAS', styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('MOBILE: ${widget.mobile ?? 'N/A'}', styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('TIN: ${widget.tin ?? 'N/A'}', styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('VRN: ${widget.vrn ?? 'N/A'}', styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('SERIAL NO:${widget.serial ?? 'N/A'}', styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('UIN:${widget.uin ?? 'N/A'}', styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('TAX OFFICE: ${widget.taxOffice ?? 'N/A'}', styles: PosStyles(align: PosAlign.center));

    bytes += generator.text(
      '------------------------------------------',
      styles: PosStyles(
        fontType: PosFontType.fontB,
      ),
    );

    // bytes += generator.text('Align right', styles: PosStyles(align: PosAlign.right), linesAfter: 1);
    //
    bytes += generator.row([
      PosColumn(
        text: 'RECEIPT NUMBER:',
        width: 6,
        styles: PosStyles(align: PosAlign.left, underline: false,fontType: PosFontType.fontB,),
      ),
      PosColumn(
        text: '${widget.id ?? 'N/A'}',
        width: 6,
        styles: PosStyles(align: PosAlign.right, underline: false,fontType: PosFontType.fontB,),
      ),
    ]);

    //row 2::
    bytes += generator.row([
      PosColumn(
        text: 'Z NUMBER:',
        width: 6,
        styles: PosStyles(align: PosAlign.left, underline: false,fontType: PosFontType.fontB,),
      ),
      PosColumn(
        text: '${widget.zNum ?? 'N/A'}',
        width: 6,
        styles: PosStyles(align: PosAlign.right, underline: false,fontType: PosFontType.fontB,),
      ),
    ]);

    //row3:
    bytes += generator.row([
      PosColumn(
        text: 'DATE:${widget.date ?? 'N/A'}',
        width: 6,
        styles: PosStyles(align: PosAlign.left, underline: false,fontType: PosFontType.fontB,),
      ),
      PosColumn(
        text: 'TIME ${widget.time ?? 'N/A'}',
        width: 6,
        styles: PosStyles(align: PosAlign.right, underline: false,fontType: PosFontType.fontB,),
      ),
    ]);

    //divider
    bytes += generator.text(
      '------------------------------------------',
      styles: PosStyles(
        fontType: PosFontType.fontB,
      ),
    );
    //row4:
    bytes += generator.row([
      PosColumn(
        text: 'PUMP:2 NOZZLE:1 ',
        width: 6,
        styles: PosStyles(align: PosAlign.left, underline: false,fontType: PosFontType.fontB,),
      ),
      PosColumn(
        text: '',
        width: 6,
        styles: PosStyles(align: PosAlign.right, underline: false,fontType: PosFontType.fontB,),
      ),
    ]);

    //row5::
    bytes += generator.row([
      PosColumn(
        text: '${widget.fuelGrade ?? 'N/A'}',
        width: 6,
        styles: PosStyles(align: PosAlign.left, underline: false,fontType: PosFontType.fontB,),
      ),
      PosColumn(
        text: '0',
        width: 6,
        styles: PosStyles(align: PosAlign.right, underline: false,fontType: PosFontType.fontB,),
      ),
    ]);

    //divider::
    bytes += generator.text(
      '------------------------------------------',
      styles: PosStyles(
        fontType: PosFontType.fontB,
      ),
    );

    //row6:
    bytes += generator.row([
      PosColumn(
        text: 'TOTAL EXCL TAX:',
        width: 6,
        styles: PosStyles(align: PosAlign.left, underline: false,fontType: PosFontType.fontB,),
      ),
      PosColumn(
        text: '0',
        width: 6,
        styles: PosStyles(align: PosAlign.right, underline: false,fontType: PosFontType.fontB,),
      ),
    ]);


    //row7:
    bytes += generator.row([
      PosColumn(
        text: 'TOTAL TAX:',
        width: 6,
        styles: PosStyles(align: PosAlign.left, underline: false,fontType: PosFontType.fontB,),
      ),
      PosColumn(
        text: '0.000',
        width: 6,
        styles: PosStyles(align: PosAlign.right, underline: false,fontType: PosFontType.fontB,),
      ),
    ]);

    //row8:
    bytes += generator.row([
      PosColumn(
        text: 'TOTAL INCL TAX: ',
        width: 6,
        styles: PosStyles(align: PosAlign.left, underline: false,fontType: PosFontType.fontB,),
      ),
      PosColumn(
        text:  'N/A',
        width: 6,
        styles: PosStyles(align: PosAlign.right, underline: false,fontType: PosFontType.fontB,),
      ),
    ]);

    //divider::
    bytes += generator.text(
      '------------------------------------------',
      styles: PosStyles(
        fontType: PosFontType.fontB,
      ),
    );

    bytes += generator.text('RECEIPT VERIFICATION CODE', styles: PosStyles(align: PosAlign.center));

    bytes += generator.text('3HH4JJ493JJJJ', styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('\n', styles: PosStyles(align: PosAlign.center));
    bytes += generator.qrcode('https://virtual.tra.go.tz/efdmsRctVerify/5D278B362_180039');
    bytes += generator.text('\n', styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('** END OF LEGAL RECEIPT **', styles: PosStyles(align: PosAlign.center));


    //
    // //barcode
    //
    // final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    // bytes += generator.barcode(Barcode.upcA(barData));
    //
    // //QR code
    // bytes += generator.qrcode('example.com');
    //
    // bytes += generator.text(
    //   'Text size 50%',
    //   styles: PosStyles(
    //     fontType: PosFontType.fontB,
    //   ),
    // );
    //
    // bytes += generator.text(
    //   'Text size 100%',
    //   styles: PosStyles(
    //     fontType: PosFontType.fontA,
    //   ),
    // );
    // bytes += generator.text(
    //   'Text size 200%',
    //   styles: PosStyles(
    //     height: PosTextSize.size2,
    //     width: PosTextSize.size2,
    //   ),
    // );
    //
    // bytes += generator.feed(2);
    //bytes += generator.cut();
    return bytes;
  }

  Future<void> printWithoutPackage() async {
    //impresion sin paquete solo de PrintBluetoothTermal
    bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    if (connectionStatus) {
      String text = _txtText.text.toString() + "\n";
      bool result = await PrintBluetoothThermal.writeString(printText: PrintTextSize(size: int.parse(_selectSize), text: text));
      print("status print result: $result");
      setState(() {
        _msj = "printed status: $result";
      });
    } else {
      //no conectado, reconecte
      setState(() {
        _msj = "no connected device";
      });
      print("no conectado");
    }
  }
}
