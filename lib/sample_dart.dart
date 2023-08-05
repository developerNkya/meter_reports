import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';

class YourDataTablePage extends StatefulWidget {
  @override
  _YourDataTablePageState createState() => _YourDataTablePageState();
}

class Element {
  final int id;
  final String date;
  final String time;
  final String fuelGrade;
  final String unit;
  final double amount;

  Element({
    required this.id,
    required this.date,
    required this.time,
    required this.fuelGrade,
    required this.unit,
    required this.amount,
  });
}

class _YourDataTablePageState extends State<YourDataTablePage> {
  final List<Element> _elements = []; // Replace with your data

  int _currentPage = 0;
  int _rowsPerPage = 10;

  List<Element> getPaginatedElements() {
    final startIndex = _currentPage * _rowsPerPage;
    final endIndex = startIndex + _rowsPerPage;
    return _elements.sublist(startIndex, endIndex.clamp(0, _elements.length));
  }

  double calculateTotalAmount() {
    return getPaginatedElements().fold(
        0, (previousValue, element) => previousValue + element.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  DataTable(
                    showCheckboxColumn: false,
                    columns: [
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Time')),
                      DataColumn(label: Text('Fuel Grade')),
                      DataColumn(label: Text('Unit')),
                      DataColumn(label: Text('Amount')),
                    ],
                    rows: getPaginatedElements().map((element) {
                      return DataRow(
                        cells: [
                          DataCell(Text(element.date)),
                          DataCell(Text(element.time)),
                          DataCell(Text(element.fuelGrade)),
                          DataCell(Text(element.unit)),
                          DataCell(Text(element.amount.toString())),
                        ],
                        onSelectChanged: (selected) {
                          if (selected != null && selected) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CoolReceiptPage(id: element.id),
                              ),
                            );
                          }
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
        BottomAppBar(
          child: Container(
            height: 60,
            child: BottomAppBar(
              color: Colors.black54,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NeumorphicButton(
                    onPressed: () {
                      setState(() {
                        _currentPage = (_currentPage - 1).clamp(0, (_elements.length / _rowsPerPage).ceil() - 1);
                      });
                    },
                    style: NeumorphicStyle(
                      boxShape: NeumorphicBoxShape.circle(),
                    ),
                    child: Icon(Icons.navigate_before),
                  ),
                  Text(
                    'Total Amount:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                  Text(
                    NumberFormat('#,###').format(calculateTotalAmount()),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                  NeumorphicButton(
                    onPressed: () {
                      setState(() {
                        _currentPage = (_currentPage + 1).clamp(0, (_elements.length / _rowsPerPage).ceil() - 1);
                      });
                    },
                    style: NeumorphicStyle(
                      boxShape: NeumorphicBoxShape.circle(),
                    ),
                    child: Icon(Icons.navigate_next),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CoolReceiptPage extends StatelessWidget {
  final int id;

  CoolReceiptPage({required this.id});

  @override
  Widget build(BuildContext context) {
    // Replace with your receipt page implementation
    return Scaffold(
      appBar: AppBar(
        title: Text('Receipt Page'),
      ),
      body: Center(
        child: Text('Receipt for ID: $id'),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: YourDataTablePage()));
}
