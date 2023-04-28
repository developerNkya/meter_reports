import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/app_button.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/screens/explore_screen.dart';
import 'package:grocery_app/screens/station_cartegories.dart';
import 'package:grocery_app/widgets/item_counter_widget.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

import '../home/cartegories_station.dart';
import 'favourite_toggle_icon_widget.dart';


List _elements = [
  {'name': 'John', 'group': 'Station'},
  {'name': 'Will', 'group': 'Station'},
  {'name': 'Beth', 'group': 'Station'},
  {'name': 'John', 'group': 'Station'},
  {'name': 'Will', 'group': 'Station'},


];

class view_stations_page extends StatefulWidget {
  final GroceryItem groceryItem;
  final String? heroSuffix;

  const view_stations_page(this.groceryItem, {this.heroSuffix});

  @override
  _view_stations_pageState createState() => _view_stations_pageState();
}

class _view_stations_pageState extends State<view_stations_page> {
  int amount = 1;

  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  getImageHeaderWidget(),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal:25),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              widget.groceryItem.name,
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            subtitle: AppText(
                              text: widget.groceryItem.description,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff7C7C7C),
                            ),
                          ),
                          AnimSearchBar(
                            width: 400,
                            textController: textController,
                            onSuffixTap: () {
                              setState(() {
                                textController.clear();
                              });
                            }, onSubmitted: (String ) {
                              print('pressed');
                          },
                          ),
                          // Spacer(),

                          //return list view here::::




                          //
                          // Spacer(),

                        ],
                      ),
                    ),
                  ),
                //  here
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(
                          height:MediaQuery.of(context).size.height,
                          child: GroupedListView<dynamic, String>(
                            elements: _elements,
                            groupBy: (element) => element['group'],
                            groupComparator: (value1, value2) => value2.compareTo(value1),
                            itemComparator: (item1, item2) =>
                                item1['name'].compareTo(item2['name']),
                            order: GroupedListOrder.DESC,
                            useStickyGroupSeparators: true,
                            groupSeparatorBuilder: (String value) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                value,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            itemBuilder: (c, element) {
                              return InkWell(
                                //Move to the station directory::::
                                onTap:(){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            cartegories_station()
                                    ),
                                  );
                                },
                                child: Card(
                                  elevation: 8.0,
                                  margin:
                                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                                  child: SizedBox(
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 10.0),
                                      leading: const Icon(Icons.local_gas_station),
                                      title: Text(element['name']),
                                      trailing: const Icon(Icons.arrow_forward),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),


    );
  }

  Widget getImageHeaderWidget() {
    return Container(
      height: 250,
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        gradient: new LinearGradient(
            colors: [
              const Color(0xFF3366FF).withOpacity(0.1),
              const Color(0xFF3366FF).withOpacity(0.09),
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Hero(
        tag: "GroceryItem:" +
            widget.groceryItem.name +
            "-" +
            (widget.heroSuffix ?? ""),
        child: Image(
          image: AssetImage(widget.groceryItem.imagePath),
        ),
      ),
    );
  }

  Widget getProductDataRowWidget(String label, {Widget? customWidget}) {
    return Container(
      margin: EdgeInsets.only(
        top: 20,
        bottom: 20,
      ),
      child: Row(
        children: [
          AppText(text: label, fontWeight: FontWeight.w600, fontSize: 16),
          Spacer(),
          if (customWidget != null) ...[
            customWidget,
            SizedBox(
              width: 20,
            )
          ],
          Icon(
            Icons.arrow_forward_ios,
            size: 20,
          )
        ],
      ),
    );
  }

  Widget nutritionWidget() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color(0xffEBEBEB),
        borderRadius: BorderRadius.circular(5),
      ),
      child: AppText(
        text: "100gm",
        fontWeight: FontWeight.w600,
        fontSize: 12,
        color: Color(0xff7C7C7C),
      ),
    );
  }

  Widget ratingWidget() {
    Widget starIcon() {
      return Icon(
        Icons.star,
        color: Color(0xffF3603F),
        size: 20,
      );
    }

    return Row(
      children: [
        starIcon(),
        starIcon(),
        starIcon(),
        starIcon(),
        starIcon(),
      ],
    );
  }


}
