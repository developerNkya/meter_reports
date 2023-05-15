import 'dart:convert';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:grocery_app/APIS/z_report.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/screens/product_details/product_details_screen.dart';
import 'package:grocery_app/widgets/grocery_item_card_widget.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../APIS/authentication.dart';
import '../APIS/changePrice.dart';
import '../APIS/station_receipts.dart';
import 'filter_screen.dart';
import 'package:intl/intl.dart';


//z_report section
class changePrice extends StatefulWidget {
  @override
  State<changePrice> createState() => changePriceState();

}

class changePriceState extends State<changePrice> {

  List<Employee> employees = <Employee>[];
  late EmployeeDataSource employeeDataSource = EmployeeDataSource(employeeData: employees);
  List<Element> _elements = <Element>[];

  final _formKey = GlobalKey<FormState>();
  TextEditingController _field1Controller = TextEditingController();
  TextEditingController _field2Controller = TextEditingController();
  TextEditingController _field3Controller = TextEditingController();
  TextEditingController _field4Controller = TextEditingController();
  final String imagePath = "assets/images/grey.jpg";

  @override
  void initState() {
    super.initState();

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

            },
            child: Container(
              padding: EdgeInsets.only(right: 25),
              child: Icon(
                Icons.water_drop,
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
            text: "change Price",
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                    child:Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8), // Adjust opacity as needed
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child:                            TextFormField(
                                controller: _field1Controller,
                                decoration: InputDecoration(
                                  labelText: 'UNLEADED',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a value';
                                  }
                                  return null;
                                },
                              ),
                            ),

                            SizedBox(height: 8.0),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8), // Adjust opacity as needed
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child:TextFormField(
                                controller: _field2Controller,
                                decoration: InputDecoration(
                                  labelText: 'DIESEL',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a value';
                                  }
                                  return null;
                                },
                              ),
                            ),

                            SizedBox(height: 8.0),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8), // Adjust opacity as needed
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: TextFormField(
                                controller: _field3Controller,
                                decoration: InputDecoration(
                                  labelText: 'KEROSENE',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a value';
                                  }
                                  return null;
                                },
                              ),
                            ),

                            SizedBox(height: 8.0),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8), // Adjust opacity as needed
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: TextFormField(
                                controller: _field4Controller,
                                decoration: InputDecoration(
                                  labelText: 'CNG',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a value';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 16.0),


                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
// All fields are valid, perform your submission logic here
                                  String field1 = _field1Controller.text;
                                  String field2 = _field2Controller.text;
                                  String field3 = _field3Controller.text;
                                  String field4 = _field4Controller.text;

                                  changePrice1(field1, field2, field3, field4);

                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                              ),
                              child: Text('Submit'),
                            ),

                          ],
                        ),
                      ),
                    ),

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
        element.date ,
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

  void changePrice1(unleaded,diesel,kerosene,cng)async{
    var username = await FlutterSession().get('username');
    var password = await FlutterSession().get('user_password');
    var user_id = await FlutterSession().get('user_id');

    //getting the auth key:::
    String auth = await authentication(username, password.toString());

    if(auth != null){
      //call receipt api:::
      String changePrice = await changePrice2(auth,unleaded,diesel,kerosene,cng);
    //  show message:::
      CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        title: 'Success...',
        text: 'Price updated successfully',
        loopAnimation: false,
        onConfirmBtnTap: () {
          //clearing the textfields:::
          _field1Controller.text ='';
          _field2Controller.text = '';
          _field3Controller.text = '';
           _field4Controller.text = '';

        },
      );
    }

    //getting the station names:::
  }


}


// }

/// Custom business object class which contains properties to hold the detailed
/// information about the employee which will be rendered in datagrid.
class Employee {
  /// Creates the employee class with required details.
  Employee(this.id, this.name, this.designation, this.qty,this.amount);

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