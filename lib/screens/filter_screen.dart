import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/app_button.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/styles/colors.dart';
import 'package:dropdown_button2/src/dropdown_button2.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';


List _elements = [
  {'name': 'John', 'group': 'Station'},
  {'name': 'Will', 'group': 'Station'},
  {'name': 'Beth', 'group': 'Station'},
  {'name': 'John', 'group': 'Station'},
  {'name': 'Will', 'group': 'Station'},
];

List<String> items = ['Option 1', 'Option 2', 'Option 3'];

class FilterScreen extends StatefulWidget {
  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
    'Item7',
    'Item8',
  ];

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            child: Icon(
              Icons.close,
              color: Colors.black,
            ),
          ),
        ),
        title: AppText(
          text: "Filters",
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(
              color: Color(0xFFF2F3F2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getLabel("Stations"),

                //create logic to fetch stations:::
                DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    isExpanded: true,
                    hint: Row(
                      children: const [
                        Icon(
                          Icons.list,
                          size: 16,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: Text(
                            'Select Item',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    items: items
                        .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                        .toList(),
                    value: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value as String;
                      });
                    },
                    buttonStyleData: ButtonStyleData(
                      height: 50,
                      width: 160,
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.black26,
                        ),
                        color: Colors.green,
                      ),
                      elevation: 2,
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                      iconSize: 14,
                      iconEnabledColor: Colors.yellow,
                      iconDisabledColor: Colors.grey,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 200,
                      width: 200,
                      padding: null,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.green,
                      ),
                      elevation: 8,
                      offset: const Offset(-20, 0),
                      scrollbarTheme: ScrollbarThemeData(
                        radius: const Radius.circular(40),
                        thickness: MaterialStateProperty.all<double>(6),
                        thumbVisibility: MaterialStateProperty.all<bool>(true),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                      padding: EdgeInsets.only(left: 14, right: 14),
                    ),
                  ),
                ),
                SizedBox(height: 30),

                getLabel("Date"),

                //date comes here:::
                SizedBox(height: 15),
                // date_picker.DayPicker.single(
                //   selectedDate: DateTime.now(),
                //   onChanged: (date) {
                //     // handle the selected date
                //   },
                //   firstDate: DateTime(2020),
                //   lastDate: DateTime(2030),
                // ),

                Spacer(),
                AppButton(
                  label: "Apply Filter",
                  fontWeight: FontWeight.w600,
                  onPressed: () {
                    _saveFilterValues(selectedValue);
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getLabel(String text) {
    return Text(
      text,
      style: TextStyle(
          color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Future<void> _saveFilterValues(String? selectedValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedValue', selectedValue ?? '');
  }
}

class OptionItem extends StatefulWidget {
  final String text;

  const OptionItem({Key? key, required this.text}) : super(key: key);

  @override
  _OptionItemState createState() => _OptionItemState();
}

class _OptionItemState extends State<OptionItem> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          checked = !checked;
        });
      },
      child: Container(
        child: Row(
          children: [
            getCheckBox(),
            SizedBox(
              width: 12,
            ),
            getTextWidget(),
          ],
        ),
      ),
    );
  }

  Widget getTextWidget() {
    return Text(
      widget.text,
      style: TextStyle(
        color: checked ? AppColors.primaryColor : Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget getCheckBox() {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      child: SizedBox(
        width: 25,
        height: 25,
        child: Container(
          decoration: new BoxDecoration(
              border: Border.all(
                  width: checked ? 0 : 1.5, color: Color(0xffB1B1B1)),
              borderRadius: new BorderRadius.circular(8),
              color: checked ? AppColors.primaryColor : Colors.transparent),
          child: Theme(
            data: ThemeData(
              unselectedWidgetColor: Colors.transparent,
            ),
            child: Checkbox(
              value: checked,
              onChanged: (state) => setState(() => checked = !checked),
              activeColor: Colors.transparent,
              checkColor: Colors.white,
              materialTapTargetSize: MaterialTapTargetSize.padded,
            ),
          ),
        ),
      ),
    );
  }
}
