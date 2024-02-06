import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:image/image.dart' as img;
import 'package:share/share.dart';
import 'package:video_player/video_player.dart';

import '../../common_widgets/app_text.dart';
import 'package:pdf/widgets.dart' as pw;









class ReceiptScreen extends StatefulWidget {
  final int? id;
  final String? date;
  final String? time;
  final String? fuelGrade;
  final String? amount;
  final String? dc;
  final String? gc;
  final int? zNum;
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
  final String? concatenated_time;
  final String? price;

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
    this.fuel_grade,
    this.concatenated_time,
    this.price
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
              onTap: () async {


                final traLogo = pw.MemoryImage((await rootBundle.load('assets/images/tra_img3.png')).buffer.asUint8List(),);

                String newDate = widget.zNum.toString().replaceAll('-', '');
                // String formattedAmount = widget.amount! % 1 == 0
                //     ? '${widget.amount!.toStringAsFixed(0)}.00'
                //     : widget.amount!.toStringAsFixed(2);

                String? formattedAmount =  widget.price;
                String? formattedTax =  widget.amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');


                print(widget.rctvNum);
                print(widget.concatenated_time);
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
                            pw.Text(
                              '*** START OF LEGAL RECEIPT ***',
                              style: pw.TextStyle(
                                fontSize: 18.0,
                                fontWeight: pw.FontWeight.bold,
                                font:ttf
                              ),
                              textAlign: pw.TextAlign.center,
                            ),
                            pw.SizedBox(height: 3.0),
                             //add image here
                            // pw.Image(tra_logo)

                            pw.Center(
                              child:  pw.Container(
                                height: 130.0,
                                child: pw.Image(traLogo,),
                              ),
                            ),

                            pw.SizedBox(height: 3.0),
                            pw.Text(
                              '${widget.name ?? 'N/A'}\nMobile:${widget.mobile ?? 'N/A'}\nTin:${widget.tin ?? 'N/A'}\nVRN:${widget.vrn ?? 'N/A'}\nSERIAL NO:${widget.serial ?? 'N/A'}\nUIN:${widget.uin ?? 'N/A'}\nTAX OFFICE:${widget.taxOffice ?? 'N/A'}',
                              style: pw.TextStyle(
                                fontSize: 16.0,
                                  font:ttf
                              ),
                              textAlign: pw.TextAlign.center,
                            ),
                            pw.SizedBox(height: 15.0),
                            // Create a dotted line separator
                            pw.Divider(
                              height: 1.0,
                              color: PdfColors.grey,
                              // dash: 2,
                            ),

                            // pw.Container(
                            //   child: MySeparator(color: Colors.grey),
                            // ),

                            //Dublicate title:::
                            // pw.Text(
                            //   'DUPLICATE RECEIPT:',
                            //   style: pw.TextStyle(
                            //       fontSize: 14.0,
                            //       fontWeight: pw.FontWeight.bold,
                            //       font:ttf
                            //   ),
                            //   textAlign: pw.TextAlign.center,
                            // ),
                            // pw.SizedBox(height: 5.0),


                            // MySeparator(color: Colors.grey),

                            pw.Row(
                              children: <pw.Widget>[
                                pw.Expanded(
                                  child: pw.Text(
                                    'RECEIPT NUMBER:',
                                    style: pw.TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: pw.FontWeight.bold,
                                        font:ttf

                                    ),

                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(
                                    '${widget.gc ?? 'N/A'}',
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
                            pw.Row(
                              children: <pw.Widget>[
                                pw.Expanded(
                                  child: pw.Text(
                                    'Z NO:',
                                    style: pw.TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: pw.FontWeight.bold,
                                        font:ttf
                                    ),
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(
                                    '${widget.dc ?? 'N/A'}/${newDate ?? ''}',
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

                            //date and time
                            pw.Row(
                              children: <pw.Widget>[
                                pw.Expanded(
                                  child: pw.Text(
                                    'DATE:${widget.date ?? 'N/A'}',
                                    style: pw.TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: pw.FontWeight.bold,
                                        font:ttf
                                    ),
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(
                                    'TIME: ${widget.time ?? 'N/A'}',
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
                            //pump
                            pw.Row(
                              children: <pw.Widget>[
                                pw.Expanded(
                                  child: pw.Text(
                                    'PUMP: ${widget.pump ?? '2'}'+' NOZZLE: 1',
                                    style: pw.TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: pw.FontWeight.bold,
                                        font:ttf
                                    ),
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(
                                    '',
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
                            //fuelgrade
                            pw.Row(
                              children: <pw.Widget>[
                                pw.Expanded(
                                  child: pw.Text(
                                    // '${widget.fuelGrade ?? 'N/A'} ${widget.price != '' ? } X ${widget.qty}',
                                    '${widget.fuelGrade ?? 'N/A'} ${formattedAmount != '' ? '$formattedAmount X ${widget.qty}' : ''}',
                                  style: pw.TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: pw.FontWeight.bold,
                                        font:ttf
                                    ),
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
                            //excl
                            pw.Row(
                              children: <pw.Widget>[
                                pw.Expanded(
                                  child: pw.Text(
                                    'TOTAL EXCL TAX:',
                                    style: pw.TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: pw.FontWeight.bold,
                                        font:ttf
                                    ),
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(
                                    '${formattedTax ?? 'N/A'}',
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
                            //tax
                            pw.Row(
                              children: <pw.Widget>[
                                pw.Expanded(
                                  child: pw.Text(
                                    'TOTAL TAX:',
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
                            //incl tax
                            pw.Row(
                              children: <pw.Widget>[
                                pw.Expanded(
                                  child: pw.Text(
                                    'TOTAL INCL TAX:',
                                    style: pw.TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: pw.FontWeight.bold,
                                        font:ttf
                                    ),
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(
                                    '${formattedTax ?? 'N/A'}',
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
                            pw.Row(
                              children: <pw.Widget>[
                                pw.Expanded(
                                  child: pw.Text(
                                    'RECEIPT VERIFICATION NUMBER',
                                    style: pw.TextStyle(
                                      fontSize: 14.0,
                                        font:ttf
                                    ),
                                    textAlign: pw.TextAlign.center,
                                    // fontFamily: 'Receipt',
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 8.0),
                            pw.Row(
                              children: <pw.Widget>[
                                pw.Expanded(
                                  child: pw.Text(
                                    '${widget.rctvNum ?? 'N/A'}',
                                    style: pw.TextStyle(
                                      fontSize: 14.0,
                                        font:ttf
                                    ),
                                    textAlign: pw.TextAlign.center,
                                    // fontFamily: 'Receipt',
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 32.0),
                            pw.Center(
                              child: pw.BarcodeWidget(
                                  data: 'https://verify.tra.go.tz/${widget.rctvNum}_${widget.concatenated_time}',
                                  barcode: pw.Barcode.qrCode(),
                                  width: 140,
                                  height: 100
                              ),
                            ),
                            pw.SizedBox(height: 15.0),
                            pw.Row(
                              children: <pw.Widget>[
                                pw.Expanded(
                                  child: pw.Text(
                                    '*** END OF LEGAL RECEIPT ***',
                                    style: pw.TextStyle(
                                      fontSize: 14.0,
                                        font:ttf
                                    ),
                                    textAlign: pw.TextAlign.center,
                                    // fontFamily: 'Receipt',
                                  ),
                                ),
                              ],
                            ),

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
                        backgroundColor: Colors.black54,
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
                               style:TextStyle(color:Colors.white),


                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black54,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: connected ? this.disconnect : null,
                      child: Text("Disconnect"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black54,
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

    String newDate = widget.zNum.toString().replaceAll('-', '');
    // String formattedAmount = widget.amount! % 1 == 0
    //     ? '${widget.amount!.toStringAsFixed(0)}.00'
    //     : widget.amount!.toStringAsFixed(2);

    String formattedTax =  widget.amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    String formattedAmount =  widget.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');



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




    bytes += generator.text('*** START OF LEGAL RECEIPT ***', styles: PosStyles(align: PosAlign.center));
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
    // bytes += generator.row([
    //   PosColumn(
    //     text: 'DUPLICATE RECEIPT:',
    //     width: 12,
    //     styles: PosStyles(
    //         underline: false,
    //         bold: true,
    //         fontType: PosFontType.fontA,
    //         align: PosAlign.center),
    //   ),
    // ]);

    bytes += generator.row([
      PosColumn(
        text: 'RECEIPT NUMBER:',
        width: 6,
        styles: PosStyles(
            underline: false,
            fontType: PosFontType.fontA,
            align: PosAlign.left),
      ),
      PosColumn(
        text: '${widget.gc ?? ''}',
        width: 6,
        styles: PosStyles(align: PosAlign.right, underline: false,
          fontType: PosFontType.fontA,
        ),
      ),
    ]);

    //row 2::
    bytes += generator.row([
      PosColumn(
        text: 'Z NUMBER:',
        width: 6,
        styles: PosStyles(align: PosAlign.left,underline: false,fontType: PosFontType.fontA,),
      ),
      PosColumn(
        text: '${widget.dc ?? 'N/A'}/${newDate ?? ''}',
        width: 6,
        styles: PosStyles(align: PosAlign.right,underline: false,fontType: PosFontType.fontA,),
      ),
    ]);

    //row3:
    bytes += generator.row([
      PosColumn(
        text: 'DATE:${widget.date ?? ''}',
        width: 6,
        styles: PosStyles(align: PosAlign.left, underline: false,fontType: PosFontType.fontA,),
      ),
      PosColumn(
        text: 'TIME ${widget.time ?? ''}',
        width: 6,
        styles: PosStyles(align: PosAlign.right, underline: false,fontType: PosFontType.fontA,),
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
        text: 'PUMP:${widget.pump !=null ? widget.pump : '2'} NOZZLE:${widget.nozzle} ',
        width: 12,
        styles: PosStyles(align: PosAlign.left,underline: false,fontType: PosFontType.fontA,),
      ),

    ]);

    //row5::
    bytes += generator.row([
      PosColumn(
        // text: '${widget.fuelGrade ?? 'N/A'} ${formattedAmount} X ${widget.qty}',
        text:  '${widget.fuelGrade ?? ''} ${formattedAmount != '' ? '$formattedAmount X ${widget.qty}' : ''}',
      width: 12,
        styles: PosStyles(align: PosAlign.left,underline: false,fontType: PosFontType.fontA,),
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
        styles: PosStyles(align: PosAlign.left,underline: false,fontType: PosFontType.fontA,),
      ),
      PosColumn(
        text: '${formattedTax ?? 'N/A'}',
        width: 6,
        styles: PosStyles(align: PosAlign.right,underline: false,fontType: PosFontType.fontA,),
      ),
    ]);


    //row7:
    bytes += generator.row([
      PosColumn(
        text: 'TOTAL TAX:',
        width: 6,
        styles: PosStyles(align: PosAlign.left,underline: false,fontType: PosFontType.fontA,),
      ),
      PosColumn(
        text: '0.00',
        width: 6,
        styles: PosStyles(align: PosAlign.right,underline: false,fontType: PosFontType.fontA,),
      ),
    ]);

    //row8:
    bytes += generator.row([
      PosColumn(
        text: 'TOTAL INCL TAX: ',
        width: 6,
        styles: PosStyles(align: PosAlign.left,underline: false,fontType: PosFontType.fontA,),
      ),
      PosColumn(
        text:  '${formattedTax ?? 'N/A'}',
        width: 6,
        styles: PosStyles(align: PosAlign.right,underline: false,fontType: PosFontType.fontA,),
      ),
    ]);

    //divider::
    bytes += generator.text(
      '------------------------------------------',
      styles: PosStyles(
        fontType: PosFontType.fontB,
      ),
    );

    bytes += generator.text('RECEIPT VERIFICATION CODE', styles: PosStyles(align: PosAlign.center,
      underline: false,
      fontType: PosFontType.fontA,
    ));
    bytes += generator.text('', styles: PosStyles(align: PosAlign.center, underline: false,
      fontType: PosFontType.fontA,));
    bytes += generator.text('${widget.rctvNum}', styles: PosStyles(align: PosAlign.center,
      underline: false,
      fontType: PosFontType.fontA,));
    bytes += generator.text('\n', styles: PosStyles(align: PosAlign.center, underline: false,
      fontType: PosFontType.fontA,));
    bytes += generator.qrcode('https://verify.tra.go.tz/${widget.rctvNum}_${widget.concatenated_time}');
    bytes += generator.text('\n', styles: PosStyles(align: PosAlign.center, underline: false,
      fontType: PosFontType.fontA,));
    bytes += generator.text('*** END OF LEGAL RECEIPT ***', styles: PosStyles(align: PosAlign.center,
      underline: false,
      fontType: PosFontType.fontA,));

    // spaces left blank intentionally:::
    bytes += generator.text('', styles: PosStyles(align: PosAlign.center,
      underline: false,
      fontType: PosFontType.fontA,));
    bytes += generator.text('', styles: PosStyles(align: PosAlign.center,
      underline: false,
      fontType: PosFontType.fontA,));


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


// Custom painter for the dashed line





