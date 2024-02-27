//
import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:image/image.dart' as img;

import 'dart:typed_data';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:share/share.dart';


class TestClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QRCodePage(),
    );
  }
}

class QRCodePage extends StatefulWidget {
  @override
  _QRCodePageState createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey qrKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: RepaintBoundary(
            key: qrKey,
            child: QrImageView(
              data: "http://www.dericknkya.com",
              backgroundColor: CupertinoColors.white,
            ),
          ),
        ),
        Positioned(
          bottom: 30,
          child: FloatingActionButton(
            onPressed: () {
              _captureAndSharePng("Your content here", qrKey);
            },
            child: Text("Capture"),
          ),
        ),
      ],
    );
  }


  Future<void> _captureAndSharePng(String content, GlobalKey qrKey) async {
    try {
      RenderObject? boundary = qrKey.currentContext?.findRenderObject();
      if (boundary != null && boundary is RenderRepaintBoundary) {
        // Convert widget to image
        var image = await boundary.toImage();
        // Convert image to byte data
        ByteData? byteData = await image.toByteData(
            format: ImageByteFormat.png);
        if (byteData != null) {
          Uint8List pngBytes = byteData.buffer.asUint8List();

          // Get temporary directory
          final tempDir = await getTemporaryDirectory();
          // Create a file to save the image
          final file = File('${tempDir.path}/shareqr.png');
          // Write the bytes to the file
          await file.writeAsBytes(pngBytes);

          // Share the image file
          await Share.shareFiles([file.path], text: content);
        } else {
          throw Exception("Failed to convert image to byte data");
        }
      } else {
        throw Exception("Failed to find render object");
      }
    } catch (e) {
      print("Error: $e");
      // Handle error gracefully, e.g., show a snackbar or an alert dialog
    }
  }
}
