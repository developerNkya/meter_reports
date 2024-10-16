import 'package:flutter/material.dart';
import 'package:grocery_app/models/station_list.dart';
import 'package:grocery_app/screens/changePrice.dart';
import 'package:grocery_app/screens/home/home_screen.dart';
import 'package:grocery_app/screens/home/station_list_item_card_widget.dart';
import 'package:grocery_app/screens/shift_management/set_receipts_range.dart';
import 'package:grocery_app/screens/summary/summary.dart';
import 'package:grocery_app/screens/z_report/z_report.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../receipt_screen/category_items_screen.dart';

class cartegories_station extends StatefulWidget {
  @override
  State<cartegories_station> createState() => _cartegories_stationState();
}

class _cartegories_stationState extends State<cartegories_station> {
  final String imagePath = "assets/images/bg3.jpg";
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
        backgroundColor: Colors.white,

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
                    getHorizontalItemSlider(station_cartegory3),
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

  void onItemClicked(BuildContext context, station_cartegory stationCartegory) {
    //handle the navigation process depending on the item selectes on the homepage::

    print("The item clicked is:::");
    print(stationCartegory.id);

    var itemChosed = stationCartegory.id;

    if (itemChosed == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
             CategoryItemsScreen()
      ));
    } else if (itemChosed == 2) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ZReport()
          ));
    }else if (itemChosed == 3) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  changePrice()
          ));
    }else if (itemChosed == 4) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Summary()
          ));
    }
    else if (itemChosed == 5) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ChooseReceiptsDate()
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
