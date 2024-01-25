import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/screens/product_details/product_details_screen.dart';
import 'package:gsform/gs_form/core/form_style.dart';
import 'package:gsform/gs_form/widget/field.dart';
import 'package:gsform/gs_form/widget/form.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../APIS/authentication.dart';
import '../APIS/changePrice.dart';
import 'package:shared_preferences/shared_preferences.dart';

//z_report section
class changePrice extends StatefulWidget {
  @override
  State<changePrice> createState() => changePriceState();
}

class changePriceState extends State<changePrice> {
  late GSForm form;
  List<Employee> employees = <Employee>[];
  late EmployeeDataSource employeeDataSource =
      EmployeeDataSource(employeeData: employees);
  List<Element> _elements = <Element>[];

  final _formKey = GlobalKey<FormState>();
  TextEditingController _field1Controller = TextEditingController();
  TextEditingController _field2Controller = TextEditingController();
  TextEditingController _field3Controller = TextEditingController();
  TextEditingController _field4Controller = TextEditingController();
  final String imagePath = "assets/images/grey.jpg";

  Map<String, dynamic> formValues = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
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
                                "Change Price easily!",
                                style: MyTextSample.title(context)!.copyWith(
                                  color: MyColorsSample.grey_80,
                                ),
                              ),
                              // Add some spacing between the title and the subtitle
                              Container(height: 5),
                              // Add a subtitle widget

                              // Add some spacing between the subtitle and the text
                              Container(height: 10),
                              // Add a text widget to display some text
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: form = GSForm.singleSection(
                    style: GSFormStyle(
                        titleStyle: const TextStyle(
                            color: Colors.black87, fontSize: 16.0)),
                    context,
                    fields: [
                      GSField.mobile(
                        value: formValues['UNLEADED'] ?? '0',
                        tag: 'UNLEADED',
                        title: 'UNLEADED',
                        weight: 6,
                        required: true,
                      ),
                      GSField.mobile(
                        value:formValues['DIESEL'] ?? '0',
                        tag: 'DIESEL',
                        title: 'DIESEL',
                        weight: 6,
                        required: true,
                      ),
                      GSField.mobile(
                        value: formValues['KEROSENE'] ?? '0',
                        tag: 'KEROSENE',
                        title: 'KEROSENE',
                        weight: 12,
                        required: true,
                      ),
                      GSField.mobile(
                        value: formValues['CNG'] ?? '0',
                        tag: 'CNG',
                        title: 'CNG',
                        weight: 6,
                        required: true,
                      ),

                      // GSField.datePicker(
                      //   prefixWidget:Text(
                      //     fromDate != null && fromTime != null
                      //         ? '${fromDate!.toString()} ${fromTime!.format(context)}'
                      //         : 'Select Start Date and Time',
                      //   ),
                      //   tag: 'licenceExpireDate',
                      //   title: 'Start date',
                      //   weight: 12,
                      //   required: true,
                      //   postfixWidget: new IconButton(
                      //     icon: new Icon(Icons.calendar_month),
                      //     color: Color(0xff676767),
                      //     onPressed: () {
                      //       _selectFromDate(context);
                      //     },
                      //     // color: Color(0xff676767),
                      //   ),
                      //   displayDateType: GSDateFormatType.numeric,
                      //   calendarType: GSCalendarType.gregorian,
                      // ),
                      //
                      // GSField.datePicker(
                      //   prefixWidget:Text(
                      //     toDate != null && toTime != null
                      //         ? '${toDate!.toString()} ${toTime!.format(context)}'
                      //         : 'Select End Date and Time',
                      //   ),
                      //   tag: 'licenceExpireDate',
                      //   title: 'End date',
                      //   weight: 12,
                      //   required: true,
                      //   postfixWidget: new IconButton(
                      //     icon: new Icon(Icons.calendar_month),
                      //     color: Color(0xff676767),
                      //     onPressed: () {
                      //       _selectToDate(context);
                      //     },
                      //     // color: Color(0xff676767),
                      //   ),
                      //   displayDateType: GSDateFormatType.numeric,
                      //   calendarType: GSCalendarType.gregorian,
                      // ),
                    ],
                  ),
                  // child: Form(
                  //   key: _formKey,
                  //   child: Column(
                  //     children: [
                  //       Container(
                  //         decoration: BoxDecoration(
                  //           color: Colors.white.withOpacity(0.8),
                  //           borderRadius: BorderRadius.circular(8.0),
                  //         ),
                  //         child: TextFormField(
                  //           controller: _field1Controller,
                  //           decoration: InputDecoration(
                  //             labelText: 'UNLEADED',
                  //             border: OutlineInputBorder(),
                  //           ),
                  //           validator: (value) {
                  //             if (value!.isEmpty) {
                  //               return 'Please enter a value';
                  //             }
                  //             return null;
                  //           },
                  //         ),
                  //       ),
                  //       SizedBox(height: 8.0),
                  //       Container(
                  //         decoration: BoxDecoration(
                  //           color: Colors.white.withOpacity(0.8),
                  //           borderRadius: BorderRadius.circular(8.0),
                  //         ),
                  //         child: TextFormField(
                  //           controller: _field2Controller,
                  //           decoration: InputDecoration(
                  //             labelText: 'DIESEL',
                  //             border: OutlineInputBorder(),
                  //           ),
                  //           validator: (value) {
                  //             if (value!.isEmpty) {
                  //               return 'Please enter a value';
                  //             }
                  //             return null;
                  //           },
                  //         ),
                  //       ),
                  //       SizedBox(height: 8.0),
                  //       Container(
                  //         decoration: BoxDecoration(
                  //           color: Colors.white.withOpacity(0.8),
                  //           borderRadius: BorderRadius.circular(8.0),
                  //         ),
                  //         child: TextFormField(
                  //           controller: _field3Controller,
                  //           decoration: InputDecoration(
                  //             labelText: 'KEROSENE',
                  //             border: OutlineInputBorder(),
                  //           ),
                  //           validator: (value) {
                  //             if (value!.isEmpty) {
                  //               return 'Please enter a value';
                  //             }
                  //             return null;
                  //           },
                  //         ),
                  //       ),
                  //       SizedBox(height: 8.0),
                  //       Container(
                  //         decoration: BoxDecoration(
                  //           color: Colors.white.withOpacity(0.8),
                  //           borderRadius: BorderRadius.circular(8.0),
                  //         ),
                  //         child: TextFormField(
                  //           controller: _field4Controller,
                  //           decoration: InputDecoration(
                  //             labelText: 'CNG',
                  //             border: OutlineInputBorder(),
                  //           ),
                  //           validator: (value) {
                  //             if (value!.isEmpty) {
                  //               return 'Please enter a value';
                  //             }
                  //             return null;
                  //           },
                  //         ),
                  //       ),
                  //       SizedBox(height: 16.0),
                  //       ElevatedButton(
                  //         onPressed: () {
                  //           if (_formKey.currentState!.validate()) {
                  //             // All fields are valid, perform your submission logic here
                  //             String field1 = _field1Controller.text;
                  //             String field2 = _field2Controller.text;
                  //             String field3 = _field3Controller.text;
                  //             String field4 = _field4Controller.text;
                  //             changePrice1(field1, field2, field3, field4);
                  //           }
                  //         },
                  //         style: ButtonStyle(
                  //           backgroundColor:
                  //           MaterialStateProperty.all<Color>(
                  //               Colors.green),
                  //         ),
                  //         child: Text('Submit'),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black45, // Background color
                      ),
                      onPressed: () {
                        // _submitForm();
                        Map<String, dynamic> map = form.onSubmit();
                        // debugPrint(isValid.toString());
                        var unleaded = map['UNLEADED'].toString();
                        var diesel = map['DIESEL'].toString();
                        var kerosene = map['KEROSENE'].toString();
                        var CNG = map['CNG'].toString();

                        if (unleaded == '' ||
                            kerosene == '' ||
                            diesel == '' ||
                            CNG == '') {
                          //  Pass the dialog prompt:
                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.error,
                            title: 'Oops...',
                            text: 'Kindly fill all fields\n Please',
                            loopAnimation: false,
                          );
                        }else if(double.tryParse(unleaded) == null||
                            double.tryParse(kerosene) == null ||
                            double.tryParse(diesel) == null ||
                            double.tryParse(CNG) == null){

                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.error,
                            title: 'Oops...',
                            text: 'All values should be numbers!\n Please',
                            loopAnimation: false,
                          );
                        } else {
                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.confirm,
                            title: 'Info!',
                            text: 'You are about to change Price',
                            loopAnimation: false,
                            confirmBtnText: 'Confirm',
                            cancelBtnText: 'No',
                            onConfirmBtnTap: () {
                              _onConfirmButtonTap(unleaded,diesel,kerosene, CNG);
                              Navigator.of(context).pop();
                            },
                          );
                        }

                        //  check if any fiels is empty:::
                      },
                      child: const Text('Submit',
                          style: TextStyle(
                          color: Colors.white
                      )
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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

  void changePrice1(unleaded, diesel, kerosene, cng) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username');
    var password = prefs.getString('user_password');
    var userId = prefs.getString('user_id');

    //getting the auth key:::
    String auth = await authentication(username!, password.toString());

    print('auth: ' + auth);
    //call receipt api:::
    changePrice2(
      auth,
      unleaded,
      diesel,
      kerosene,
      cng,
    );

    print(unleaded);
    //  show message:::
    CoolAlert.show(
      context: context,
      type: CoolAlertType.success,
      title: 'Success...',
      text: 'Price updated successfully',
      loopAnimation: false,
      onConfirmBtnTap: () {
        //clearing the textfields:::
      },
    );
  
    //getting the station names:::
  }

 _onConfirmButtonTap(unleaded,diesel,kerosene,CNG) {
    print('changing the price::');
    changePrice1(unleaded, diesel, kerosene, CNG);
    // Add your logic here for when the Okay button is tapped
    CoolAlert.show(
      context: context,
      type: CoolAlertType.success,
      title: 'Success...',
      text: 'Price updated successfully',
      loopAnimation: false,

    );

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

class MyTextSample {
  static TextStyle? display4(BuildContext context) {
    return Theme.of(context).textTheme.displayLarge;
  }

  static TextStyle? display3(BuildContext context) {
    return Theme.of(context).textTheme.displayMedium;
  }

  static TextStyle? display2(BuildContext context) {
    return Theme.of(context).textTheme.displaySmall;
  }

  static TextStyle? display1(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium;
  }

  static TextStyle? headline(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall;
  }

  static TextStyle? title(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge;
  }

  static TextStyle medium(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium!.copyWith(
          fontSize: 18,
        );
  }

  static TextStyle? subhead(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium;
  }

  static TextStyle? body2(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge;
  }

  static TextStyle? body1(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium;
  }

  static TextStyle? caption(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall;
  }

  static TextStyle? button(BuildContext context) {
    return Theme.of(context).textTheme.labelLarge!.copyWith(letterSpacing: 1);
  }

  static TextStyle? subtitle(BuildContext context) {
    return Theme.of(context).textTheme.titleSmall;
  }

  static TextStyle? overline(BuildContext context) {
    return Theme.of(context).textTheme.labelSmall;
  }
}

class ImgSample {
  static String get(String name) {
    return 'assets/images/change_price.jpg';
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the employee which will be rendered in datagrid.
class Employee {
  /// Creates the employee class with required details.
  Employee(
    this.id,
    this.name,
    this.designation,
    this.qty,
    this.amount,
  );

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
      }).toList(),
    );
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
