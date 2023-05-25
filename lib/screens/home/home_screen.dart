import 'dart:convert';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:grocery_app/APIS/authentication.dart';
import 'package:grocery_app/APIS/userStations.dart';
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
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

// HomeScreen
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Element> _elements = <Element>[];
  List<String> imageList = [
    'https://images.unsplash.com/photo-1591768793355-74d04bb6608f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=872&q=80',
    'https://images.unsplash.com/photo-1649728424169-cac7ae0157b2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=870&q=80',
     'https://images.unsplash.com/photo-1678903434882-d8bc7782b953?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=870&q=80'    // Add more image URLs here
  ];

  @override
  void initState() {
    super.initState();
    fetchStations();
  }

  void fetchStations() async {
    var username = await FlutterSession().get('username');
    var password = await FlutterSession().get('user_password');
    var user_id = await FlutterSession().get('user_id');

    //getting the auth key:::
    String auth = await authentication(username, password.toString());

    if (auth != null) {
      String userStations1 = await userStations(auth, user_id.toString());
      Map<String, dynamic> response = jsonDecode(userStations1);
      List<dynamic> stations = response['stations'];

      List<String> stationNames =
      stations.map((station) => station['name'].toString()).toList();

      print(stationNames);

      //  adding to element:::

      setState(() {
        //Your code
        for (String stationName in stationNames) {
          _elements.add(Element(stationName, Icons.local_gas_station));
        }
      });
    }

    //getting the station names:::
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 32,
              ),
              padded(HomeBanner()),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 16),
                  Expanded(
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 200, // Adjust the height as per your needs
                        autoPlay: true, // Enable automatic slide transition
                        enlargeCenterPage: true, // Increase the size of the center image
                        aspectRatio: 16 / 9, // Adjust the aspect ratio as per your images
                        autoPlayCurve: Curves.fastOutSlowIn, // Animation curve
                        enableInfiniteScroll: true, // Allow infinite scrolling
                        autoPlayInterval: Duration(seconds: 3), // Duration between slide transitions
                        autoPlayAnimationDuration: Duration(milliseconds: 800), // Animation duration
                        viewportFraction: 0.8, // Fraction of the viewport to occupy
                      ),
                      items: imageList.map((imageUrl) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                              ),
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              padded(subTitle("Your Stations")),
              Expanded(
                child: groupList(),
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
          onTap: () async {
            print(element.name);
            // move to the selected station
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => cartegories_station()),
            );
          },
        ),
      ),
    );
  }

  groupList() {
    if (_elements.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return StickyGroupedListView<Element, DateTime>(
        elements: _elements,
        order: StickyGroupedListOrder.ASC,
        groupBy: (Element element) => DateTime.now(),
        groupComparator: (DateTime value1, DateTime value2) =>
            value2.compareTo(value1),
        itemComparator: (Element element1, Element element2) =>
            element1.name.compareTo(element2.name),
        floatingHeader: true,
        groupSeparatorBuilder: _getGroupSeparator,
        itemBuilder: _getItem,
      );
    }
  }

  Future<dynamic> _fetchname() async {
    dynamic username = await FlutterSession().get('username');
    return username;
  }
}

class Element {
  String name;
  IconData icon;

  Element(this.name, this.icon);
}
