import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grocery_app/APIS/z_report.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/screens/product_details/product_details_screen.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../APIS/authentication.dart';
import '../APIS/station_receipts.dart';
import 'filter_screen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// z_report section
class ZReport extends StatefulWidget {
  @override
  State<ZReport> createState() => _ZReportState();
}

class _ZReportState extends State<ZReport> {
  List<Employee> employees = <Employee>[];
  late EmployeeDataSource employeeDataSource =
  EmployeeDataSource(employeeData: employees);
  List<Element> _elements = <Element>[];
  bool _isLoading = true;
  final String imagePath = "assets/images/grey.jpg";

  @override
  void initState() {
    super.initState();
    stationReceipt();
  }

  void stationReceipt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username');
    var password = prefs.getString('user_password');
   var user_id = prefs.getString('user_id');

    //getting the auth key:::
    String auth = await authentication(username!, password.toString());

    if (auth != null) {
      var dateFrom = "2021-10-11";
      // Get the current date
      DateTime currentDate = DateTime.now();

      // Format the current date to match the desired format
      String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

      // Assign the formatted date to the variable
      var dateTo = formattedDate;
      //call receipt api:::
      String zReports = await zReport(auth, dateFrom, dateTo);
      // String userStations1 = await userStations(auth, user_id.toString());
      Map<String, dynamic> response = jsonDecode(zReports);
      Map<String, dynamic> parsedResponse = json.decode(zReports);

      List<dynamic> dataList = parsedResponse['data'];

      List<Map<String, dynamic>> objectsList = dataList.map((data) {
        String date = data['DAILYTOTALAMOUNT'].toString();
        String time = data['GROSS'].toString();
        String fuelGrade = data['NETTAMOUNT_E'].toString();
        String unit = 'TAXAMOUNT_E';
        int amount = 0;

        try {
          amount = double.parse(data['PMTAMOUNT_CASH'].toString()).toInt();
        } catch (e) {
          print('Invalid amount value: ${data['PMTAMOUNT_CASH']}');
        }

        return {
          'date': date,
          'time': time,
          'fuelGrade': fuelGrade,
          'unit': unit,
          'amount': amount,
        };
      }).toList();

      setState(() {
        //Your code
        objectsList.forEach((obj) {
          Element element = Element(
            obj['date'],
            obj['time'],
            obj['fuelGrade'],
            obj['unit'],
            obj['amount'],
          );

          _elements.add(element);
        });
      });

      employees = getEmployeeData();
      employeeDataSource = EmployeeDataSource(employeeData: employees);
      _isLoading = false;
    }

    //getting the station names:::
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
            onTap: () {},
            child: Container(
              padding: EdgeInsets.only(right: 25),
              child: Icon(
                Icons.newspaper,
                color: Colors.black,
              ),
            ),
          ),
        ],
        title: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 25,
          ),
          child: AppText(
            text: "Z-Report",
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Stack(
        children: [
          _isLoading
              ? Center(
            child: CircularProgressIndicator(),
          )
              : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('DAILY')),
                DataColumn(label: Text('GROSS')),
                DataColumn(label: Text('NET_AMT')),
                DataColumn(label: Text('TAX_AMT')),
                DataColumn(label: Text('AMOUNT')),
              ],
              rows: _elements.map((element) {
                return DataRow(
                  cells: [
                    DataCell(Text(element.date)),
                    DataCell(Text(element.time)),
                    DataCell(Text(element.fuelGrade)),
                    DataCell(Text(element.unit)),
                    DataCell(Text(element.amount.toString())),
                  ],
                );
              }).toList(),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 60,
              child: BottomAppBar(
                color: Colors.green,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.attach_money),
                      onPressed: () {},
                    ),
                    Text(
                      'Total Amount:',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    Text(
                      NumberFormat('#,###').format(calculateTotalAmount()),
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onItemClicked(BuildContext context, GroceryItem groceryItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(
          groceryItem,
          heroSuffix: "explore_screen",
        ),
      ),
    );
  }

  List<Employee> getEmployeeData() {
    List<Employee> employeeData = [];

    _elements.forEach((element) {
      Employee employee = Employee(
        element.date,
        element.time,
        element.fuelGrade,
        element.unit,
        element.amount,
      );
      employeeData.add(employee);
    });
    print(employeeData);
    return employeeData;
  }

  int calculateTotalAmount() {
    int totalAmount = 0;
    for (var element in _elements) {
      totalAmount += element.amount;
    }
    return totalAmount;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the employee which will be rendered in datagrid.
class Employee {
  /// Creates the employee class with required details.
  Employee(this.id, this.name, this.designation, this.qty, this.amount);

  /// Id of an employee.
  final String id;

  /// Name of an employee.
  final String name;

  /// Designation of an employee.
  final String designation;

  /// Salary of an employee.
  final String qty;
  final int amount;
}

/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.
class EmployeeDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  EmployeeDataSource({required List<Employee> employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'id', value: e.id),
      DataGridCell<String>(columnName: 'name', value: e.name),
      DataGridCell<String>(
          columnName: 'designation', value: e.designation),
      DataGridCell<String>(columnName: 'salary', value: e.qty),
      DataGridCell<int>(columnName: 'amount', value: e.amount),
    ]))
        .toList();
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: Text(e.value.toString()),
          );
        }).toList());
  }
}

class Element {
  final String date;
  final String time;
  final String fuelGrade;
  final String unit;
  final int amount;

  Element(this.date, this.time, this.fuelGrade, this.unit, this.amount);

  @override
  String toString() {
    return '($date, $time, $fuelGrade, $unit, $amount)';
  }
}