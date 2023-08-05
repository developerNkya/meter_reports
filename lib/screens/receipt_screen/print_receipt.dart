import 'dart:async';
import 'dart:io';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:lottie/lottie.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:image/image.dart' as img;
import 'package:video_player/video_player.dart';

import '../../LOGIN/login_page.dart';
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
  final String? pump;
  final String? fuel_grade;

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
    this.pump,
    this.fuel_grade
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
  final String imagePath = "assets/images/print2.jpg";
  VideoPlayerController controller = VideoPlayerController.asset('assets/animations/print3.mp4');

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
                // Container(
                //   width: double.infinity,
                //   height: 200, // Set the desired height for the image card
                //   child: Card(
                //     child: Image.asset(
                //       imagePath,
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                // ),

                //logic begins
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
                                    "Status",
                                    style: MyTextSample.title(context)!.copyWith(
                                      color: MyColorsSample.grey_80,
                                    ),
                                  ),
                                  // Add some spacing between the title and the subtitle
                                  Container(height: 5),
                                  // Add a subtitle widget
                                  Text(
                                    "Info:$_info\n",
                                    style: MyTextSample.body1(context)!.copyWith(
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  Text(
                                    _msj,
                                    style: MyTextSample.body1(context)!.copyWith(
                                      color: Colors.grey[500],
                                    ),
                                  ),

                                  // Add some spacing between the subtitle and the text
                                  Container(height: 10),
                                  // Add a text widget to display some text
                                  Text(
                                    MyStringsSample.card_text,
                                    maxLines: 2,
                                    style: MyTextSample.subhead(context)!.copyWith(
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                //logic ends
                // Text('info: $_info\n '),
                // Text(_msj),
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
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black54,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
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
                          Text(_progress ? _msjprogress : "Search",

                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black54,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: connected ? this.disconnect : null,
                      child: Text("Disconnect"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black54,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: connected ? this.printTest : null,
                      child: Text("Print"),
                    ),

                  ],
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Column(
                    children: [
                      Container(
                          height: 200,

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



                    ],
                  ),
                ),
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

    // Navigator.pop(context); // Close the dialog after the disconnect operation
  }


  Future<void> printTest() async {

    bool conexionStatus = await PrintBluetoothThermal.connectionStatus;
    //print("connection status: $conexionStatus");
    if (conexionStatus) {
      //
      // CoolAlert.show(
      //   context: context,
      //   type: CoolAlertType.loading,
      //   title: 'Wait...',
      //   text: 'Your receipt is being printed...',
      //   loopAnimation: true,
      // );

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
    bytes += generator.text('${widget.name}', styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('MOBILE: ${widget.mobile ?? ' '}', styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('TIN: ${widget.tin ?? ''}', styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('VRN: ${widget.vrn ?? ''}', styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('SERIAL NO:${widget.serial ?? ''}', styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('UIN:${widget.uin ?? ''}', styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('TAX OFFICE: ${widget.taxOffice ?? ''}', styles: PosStyles(align: PosAlign.center));

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
        text: '${widget.id ?? ''}',
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
        text: '${widget.zNum ?? ''}',
        width: 6,
        styles: PosStyles(align: PosAlign.right, underline: false,fontType: PosFontType.fontB,),
      ),
    ]);

    //row3:
    bytes += generator.row([
      PosColumn(
        text: 'DATE:${widget.date ?? ''}',
        width: 6,
        styles: PosStyles(align: PosAlign.left, underline: false,fontType: PosFontType.fontB,),
      ),
      PosColumn(
        text: 'TIME ${widget.time ?? ''}',
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
        text: 'PUMP:${widget.pump} NOZZLE:${widget.nozzle} ',
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
        text: '${widget.fuelGrade ?? ''}',
        width: 6,
        styles: PosStyles(align: PosAlign.left, underline: false,fontType: PosFontType.fontB,),
      ),
      PosColumn(
        text: '${widget.fuelGrade ?? ''}',
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
        text: '${widget.amount}',
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
        text: '0.00',
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
        text:  '${widget.amount}',
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

    bytes += generator.text('${widget.rctvNum}', styles: PosStyles(align: PosAlign.center));
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
class ImgSample {
  static String get(String name){
    return 'assets/images/print2.jpg';
  }
}

class MyStringsSample {
  static const String lorem_ipsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam efficitur ipsum in placerat molestie.  Fusce quis mauris a enim sollicitudin"
      "\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam efficitur ipsum in placerat molestie.  Fusce quis mauris a enim sollicitudin";
  static const String middle_lorem_ipsum = "Flutter is an open-source UI software development kit created by Google. It is used to develop cross-platform applications for Android, iOS, Linux, macOS, Windows, Google Fuchsia, and the web from a single codebase.";
  static const String card_text = " " ;
  final icon_text = Icons.ac_unit;
}




