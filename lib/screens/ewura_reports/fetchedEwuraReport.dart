import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:share/share.dart';

class FetchedEwuraReports extends StatelessWidget {
  final DateTime dateFrom;
  final DateTime dateTo;
  final double totalVolume;
  final double volumeUnleaded;
  final double volumeDiesel;
  final double volumeKerosene;
  final String stationName;

  FetchedEwuraReports({
    required this.dateFrom,
    required this.dateTo,
    required this.totalVolume,
    required this.volumeUnleaded,
    required this.volumeDiesel,
    required this.volumeKerosene,
    required this.stationName
  });

  // Function to format numbers with comma as thousands separator
  String formatNumber(double number) {
    return NumberFormat('#,##0.00').format(number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
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
        title: Text(
          'Volume Report',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf, color: Colors.black),
            onPressed: () async {
              await _generatePdf(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          color: Colors.grey[200],
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateRangeCard(),
                  SizedBox(height: 16),
                  _buildVolumeTable(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateRangeCard() {
    String formattedFromDate = DateFormat('MMMM dd, yyyy').format(dateFrom);
    String formattedToDate = DateFormat('MMMM dd, yyyy').format(dateTo);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'From:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8),
              Text(
                formattedFromDate,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(width: 16),
              Text(
                'To:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8),
              Text(
                formattedToDate,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVolumeTable() {
    return DataTable(
      columns: [
        DataColumn(
          label: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Fuel Type',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        DataColumn(
          label: Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Volume (Liters)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
      rows: [
        _buildDataRow('Total Volume', totalVolume),
        _buildDataRow('Unleaded Volume', volumeUnleaded),
        _buildDataRow('Diesel Volume', volumeDiesel),
        _buildDataRow('Kerosene Volume', volumeKerosene),
      ],
    );
  }

  DataRow _buildDataRow(String fuelType, double volume) {
    return DataRow(
      cells: [
        DataCell(
          Align(
            alignment: Alignment.centerLeft,
            child: Text(fuelType),
          ),
        ),
        DataCell(
          Align(
            alignment: Alignment.centerRight,
            child: Text(formatNumber(volume)), // Use the format function here
          ),
        ),
      ],
    );
  }

  Future<void> _generatePdf(BuildContext context) async {
    // Load custom font
    final fontData = await rootBundle.load("assets/fonts/FAKERECE.ttf");
    final ttf = pw.Font.ttf(fontData);

    // Create PDF document
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Container(
            padding: pw.EdgeInsets.all(16.0),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: <pw.Widget>[
                pw.Text(
                  'VOLUME REPORT',
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, font: ttf),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  stationName,
                  style: pw.TextStyle(fontSize: 19, fontWeight: pw.FontWeight.bold, font: ttf),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'From: ${DateFormat('MMMM dd, yyyy').format(dateFrom)}',
                  style: pw.TextStyle(font: ttf),
                ),
                pw.Text(
                  'To: ${DateFormat('MMMM dd, yyyy').format(dateTo)}',
                  style: pw.TextStyle(font: ttf),
                ),
                pw.SizedBox(height: 20),
                pw.Table(
                  border: pw.TableBorder.all(),
                  children: [
                    _buildPdfDataRow('Total Volume', totalVolume, ttf),
                    _buildPdfDataRow('Unleaded Volume', volumeUnleaded, ttf),
                    _buildPdfDataRow('Diesel Volume', volumeDiesel, ttf),
                    _buildPdfDataRow('Kerosene Volume', volumeKerosene, ttf),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    // Save the PDF to a temporary file
    final output = await getTemporaryDirectory();

    // Create file name using the date range
    String fromValue = DateFormat('yyyy-MM-dd').format(dateFrom);
    String toValue = DateFormat('yyyy-MM-dd').format(dateTo);

    final file = File('${output.path}/EWURA-REPORT FROM $fromValue TO $toValue.pdf');
    await file.writeAsBytes(await pdf.save());

    // Open share dialog
    Share.shareFiles([file.path],
        text: 'Share Receipt PDF',
        subject: 'Receipt PDF');
  }

  pw.TableRow _buildPdfDataRow(String fuelType, double volume, pw.Font font) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(8.0),
          child: pw.Text(
            fuelType,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: font),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(8.0),
          child: pw.Text(
            formatNumber(volume)+' L', // Use the format function here
            style: pw.TextStyle(font: font),
          ),
        ),
      ],
    );
  }
}
