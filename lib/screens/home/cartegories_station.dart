import 'package:flutter/material.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/models/station_list.dart';
import 'package:grocery_app/screens/changePrice.dart';
import 'package:grocery_app/screens/home/home_screen.dart';
import 'package:grocery_app/screens/home/station_list_item_card_widget.dart';
import 'package:grocery_app/screens/home/stations_banner.dart';
import 'package:grocery_app/screens/product_details/product_details_screen.dart';
import 'package:grocery_app/screens/product_details/view_stations_page.dart';
import 'package:grocery_app/screens/summary.dart';
import 'package:grocery_app/screens/z_report.dart';
import 'package:grocery_app/styles/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_app/widgets/grocery_item_card_widget.dart';
import 'package:grocery_app/widgets/search_bar_widget.dart';

import '../receipt_screen/category_items_screen.dart';
import 'grocery_featured_Item_widget.dart';
import 'home_banner_widget.dart';

class cartegories_station extends StatefulWidget {
  @override
  State<cartegories_station> createState() => _cartegories_stationState();
}

class _cartegories_stationState extends State<cartegories_station> {
  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    padded(subTitle("Cartegories")),
                    getHorizontalItemSlider(station_cartegory1),
                    getHorizontalItemSlider(station_cartegory2),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget padded(Widget widget) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: widget,
    );
  }

  Widget getHorizontalItemSlider(List<station_cartegory>items) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      height: 250,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20),
        itemCount: items.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              onItemClicked(context, items[index]);
            },
            child: station_cartegoryWidget(
              item: items[index],
              heroSuffix: "home_screen",
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: 20,
          );
        },
      ),
    );
  }

  void onItemClicked(BuildContext context, station_cartegory station_cartegory) {
    //handle the navigation process depending on the item selectes on the homepage::

    print("The item clicked is:::");
    print(station_cartegory.id);

    var item_chosed = station_cartegory.id;

    if (item_chosed == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
             CategoryItemsScreen()
      ));
    } else if (item_chosed == 2) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ZReport()
          ));
    }else if (item_chosed == 3) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  changePrice()
          ));
    }else if (item_chosed == 4) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Summary()
          ));
    }
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

  Widget locationWidget() {
    String locationIconPath = "assets/icons/location_icon.svg";
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          locationIconPath,
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          "Dashboard",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
