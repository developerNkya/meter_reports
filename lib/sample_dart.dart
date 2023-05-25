// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_session/flutter_session.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:grocery_app/common_widgets/app_text.dart';
// import 'package:grocery_app/models/grocery_item.dart';
// import 'package:grocery_app/screens/product_details/product_details_screen.dart';
// import 'package:grocery_app/widgets/grocery_item_card_widget.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
// import '../APIS/authentication.dart';
// import '../APIS/station_receipts.dart';
// import 'filter_screen.dart';
// import 'package:intl/intl.dart';
//
// //receipts section
// class CategoryItemsScreen extends StatefulWidget {
//   @override
//   State<CategoryItemsScreen> createState() => _CategoryItemsScreenState();
// }
//
// class _CategoryItemsScreenState extends State<CategoryItemsScreen> {
//
//   List<Employee> employees = <Employee>[];
//   late EmployeeDataSource employeeDataSource = EmployeeDataSource(employeeData: employees);
//   List<Element> _elements = <Element>[];
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     stationReceipt();
//
//   }
//   void stationReceipt() async{
//     var username = await FlutterSession().get('username');
//     var password = await FlutterSession().get('user_password');
//     var user_id = await FlutterSession().get('user_id');
//
//     //getting the auth key:::
//     String auth = await authentication(username, password.toString());
//
//     if(auth != null){
//       var dateFrom = "2021-10-11";
//       var dateTo ="2024-10-21";
//       //call receipt api:::
//       String userReceipts = await  fetchStationReceiptReport(auth,dateFrom,dateTo);
//       // String userStations1 = await userStations(auth,user_id.toString() );
//       Map<String, dynamic> response = jsonDecode(userReceipts);
//       Map<String, dynamic> parsedResponse = json.decode(userReceipts);
//
//       List<dynamic> dataList = parsedResponse['data'];
//
//       List<Map<String, dynamic>> objectsList = dataList.map((data) {
//         String date = data['DATE'].toString();
//         String time = data['TIME'].toString();
//         String fuelGrade = data['FUEL_GRADE'].toString();
//         String unit = 'ltr';
//         int amount = data['AMOUNT'] ;
//
//         return {
//           'date': date,
//           'time': time,
//           'fuelGrade': fuelGrade,
//           'unit': unit,
//           'amount': amount,
//         };
//       }).toList();
//
//       setState(() {
//         //Your code
//         objectsList.forEach((obj) {
//           Element element = Element(
//             obj['date'],
//             obj['time'],
//             obj['fuelGrade'],
//             obj['unit'],
//             obj['amount'],
//           );
//
//           _elements.add(element);
//         });
//
//       });
//       employees = getEmployeeData();
//       employeeDataSource = EmployeeDataSource(employeeData: employees);
//       _isLoading = false;
//     }
//
//     //getting the station names:::
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//         leading: GestureDetector(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: Container(
//             padding: EdgeInsets.only(left: 25),
//             child: Icon(
//               Icons.arrow_back_ios,
//               color: Colors.black,
//             ),
//           ),
//         ),
//         actions: [
//           GestureDetector(
//             onTap: () {
//             },
//             child: Container(
//               padding: EdgeInsets.only(right: 25),
//               child: Icon(
//                 Icons.graphic_eq,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//         ],
//         title: Container(
//           padding: EdgeInsets.symmetric(
//             horizontal: 25,
//           ),
//           child: AppText(
//             text: "Receipts",
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//           ),
//         ),
//       ),
//       body:
//       Column(
//         children: [
//           Expanded(
//             child: _elements.isEmpty
//                 ? Center(child: CircularProgressIndicator())
//                 : SfDataGrid(
//               source: employeeDataSource,
//               columnWidthMode: ColumnWidthMode.fill,
//               columns: <GridColumn>[
//                 GridColumn(
//                     columnName: 'DATE',
//                     label: Container(
//                         padding: EdgeInsets.all(16.0),
//                         alignment: Alignment.center,
//                         child: Text(
//                           'DATE',
//                         ))),
//                 GridColumn(
//                     columnName: 'TIME',
//                     label: Container(
//                         padding: EdgeInsets.all(8.0),
//                         alignment: Alignment.center,
//                         child: Text('TIME'))),
//                 GridColumn(
//                     columnName: 'FUEL GRADE',
//                     label: Container(
//                         padding: EdgeInsets.all(8.0),
//                         alignment: Alignment.center,
//                         child: Text(
//                           'FUEL GRADE',
//                           overflow: TextOverflow.ellipsis,
//                         ))),
//                 GridColumn(
//                     columnName: 'CITY',
//                     label: Container(
//                         padding: EdgeInsets.all(8.0),
//                         alignment: Alignment.center,
//                         child: Text('CITY'))),
//                 GridColumn(
//                     columnName: 'AMOUNT',
//                     label: Container(
//                         padding: EdgeInsets.all(8.0),
//                         alignment: Alignment.center,
//                         child: Text('AMOUNT'))),
//
//               ],
//             ),
//           ),
//           Positioned(
//             left: 0,
//             right: 0,
//             bottom: 0,
//             child: Container(
//               height: 60,
//               child: BottomAppBar(
//                 color: Colors.green,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.attach_money),
//                       onPressed: () {},
//                     ),
//                     Text('Total Amount:',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 25),
//                     ),
//                     Text(
//                       NumberFormat('#,###').format(
//                           calculateTotalAmount()
//                       ),
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 25),
//
//                     )
//
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void onItemClicked(BuildContext context, GroceryItem groceryItem) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ProductDetailsScreen(
//           groceryItem,
//           heroSuffix: "explore_screen",
//         ),
//       ),
//     );
//   }
//   List<Employee> getEmployeeData() {
//     List<Employee> employeeData = [];
//
//     _elements.forEach((element) {
//       Employee employee = Employee(
//         element.date ,
//         element.time,
//         element.fuelGrade,
//         element.unit,
//         element.amount,
//       );
//       employeeData.add(employee);
//     });
//     print(employeeData);
//     return employeeData;
//   }
//
//   int calculateTotalAmount() {
//     int totalAmount = 0;
//     for (var element in _elements) {
//       totalAmount += element.amount;
//     }
//     return totalAmount;
//   }
//
//
// }
//
//
// // }
//
// /// Custom business object class which contains properties to hold the detailed
// /// information about the employee which will be rendered in datagrid.
// class Employee {
//   /// Creates the employee class with required details.
//   Employee(this.id, this.name, this.designation, this.qty,this.amount);
//
//   /// Id of an employee.
//   final String id;
//
//   /// Name of an employee.
//   final String name;
//
//   /// Designation of an employee.
//   final String designation;
//
//   /// Salary of an employee.
//   final String qty;
//   final int amount;
// }
//
//
//
// /// An object to set the employee collection data source to the datagrid. This
// /// is used to map the employee data to the datagrid widget.
// class EmployeeDataSource extends DataGridSource {
//   /// Creates the employee data source class with required details.
//   EmployeeDataSource({required List<Employee> employeeData}) {
//     _employeeData = employeeData
//         .map<DataGridRow>((e) => DataGridRow(cells: [
//       DataGridCell<String>(columnName: 'id', value: e.id),
//       DataGridCell<String>(columnName: 'name', value: e.name),
//       DataGridCell<String>(
//           columnName: 'designation', value: e.designation),
//       DataGridCell<String>(columnName: 'salary', value: e.qty),
//       DataGridCell<int>(columnName: 'amount', value: e.amount),
//     ]))
//         .toList();
//   }
//
//   List<DataGridRow> _employeeData = [];
//
//   @override
//   List<DataGridRow> get rows => _employeeData;
//
//   @override
//   DataGridRowAdapter buildRow(DataGridRow row) {
//     return DataGridRowAdapter(
//         cells: row.getCells().map<Widget>((e) {
//           return Container(
//             alignment: Alignment.center,
//             padding: EdgeInsets.all(8.0),
//             child: Text(e.value.toString()),
//           );
//         }).toList());
//   }
//
// }
//
// class Element {
//   final String date;
//   final String time;
//   final String fuelGrade;
//   final String unit;
//   final int amount;
//
//   Element(this.date, this.time, this.fuelGrade, this.unit, this.amount);
//   @override
//   String toString() {
//     return '($date, $time, $fuelGrade, $unit, $amount)';
//   }
// }