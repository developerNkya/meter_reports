import 'package:flutter/material.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/screens/home/cartegories_station.dart';
import 'package:grocery_app/screens/product_details/product_details_screen.dart';
import 'package:grocery_app/screens/product_details/view_stations_page.dart';
import 'package:grocery_app/styles/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_app/widgets/grocery_item_card_widget.dart';
import 'package:grocery_app/widgets/search_bar_widget.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'grocery_featured_Item_widget.dart';
import 'home_banner_widget.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

List<Element> _elements = <Element>[

  Element(DateTime(2020, 6, 26, 12), 'Lumumba', Icons.local_car_wash),
  Element(DateTime(2020, 6, 26, 12), 'keko', Icons.local_car_wash),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body:Center(
          child: Column(
            children: [
          SizedBox(
                    height: 32,
                  ),
                  padded(HomeBanner()),
                  SizedBox(
                    height: 67,
                  ),
              padded(subTitle("Your Stations")),

              Expanded(
                child: StickyGroupedListView<Element, DateTime>(
                  elements: _elements,
                  order: StickyGroupedListOrder.ASC,
                  groupBy: (Element element) => DateTime(
                    element.date.year,
                    element.date.month,
                    element.date.day,
                  ),
                  groupComparator: (DateTime value1, DateTime value2) =>
                      value2.compareTo(value1),
                  itemComparator: (Element element1, Element element2) =>
                      element1.date.compareTo(element2.date),
                  floatingHeader: true,
                  groupSeparatorBuilder: _getGroupSeparator,
                  itemBuilder: _getItem,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
    Widget subTitle(String text) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget padded(Widget widget) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: widget,
    );
  }

  Widget _getGroupSeparator(Element element) {
    return SizedBox(
      height: 5,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: 120,
        ),
      ),
    );
  }

  Widget _getItem(BuildContext ctx, Element element) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: SizedBox(
        child: ListTile(
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Icon(element.icon),
          title: Text(element.name),
          onTap: (){
               //move on to the station cartegory::
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => cartegories_station()),
            );

               }
        ),
      ),
    );
  }
}

class Element {
  DateTime date;
  String name;
  IconData icon;

  Element(this.date, this.name, this.icon);
}