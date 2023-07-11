import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grocery_app/common_widgets/app_button.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/screens/explore_screen.dart';
import 'package:grocery_app/screens/station_cartegories.dart';
import 'package:grocery_app/widgets/item_counter_widget.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

import '../../STATION_LIST/Station.dart';
import '../home/cartegories_station.dart';
import 'favourite_toggle_icon_widget.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class ViewStationsPage extends StatefulWidget {
  final GroceryItem groceryItem;
  final String? heroSuffix;

  const ViewStationsPage(this.groceryItem, {this.heroSuffix});

  @override
  _ViewStationsPageState createState() => _ViewStationsPageState();
}

class _ViewStationsPageState extends State<ViewStationsPage> {
  late String username;
  late String accessToken;
  late int userId;
  int amount = 1;

  TextEditingController textController = TextEditingController();
  late Future<List<Station>> _futureStations;

  @override
  void initState() {
    super.initState();

    // call fetchStations method
    _futureStations = fetchStations();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            getImageHeaderWidget(),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
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
                  ],
                ),
              ),
            ),
            //  here
            FutureBuilder<List<Station>>(
              future: _futureStations,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    height: height,
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final station = snapshot.data![index];

                        return GestureDetector(
                          onTap: () {
                            print('Clicked on station ${station.name}');
                            //  moving into the station::
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => cartegories_station()),
                            );
                          },
                          child: ListTile(
                            title: Text(station.name),
                            subtitle: Text(station.name),
                          ),
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                return CircularProgressIndicator();
              },
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

  Future<List<Station>> fetchStations() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final accessToken = sharedPreferences.getString('access_token');
    final userId = sharedPreferences.getInt('user_id');

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
      'Cookie':
      '_csrf-backend=746607a72cf031411f7c453649c5638b7ca0662237abaac41db371d2ba6b2799a%3A2%3A%7Bi%3A0%3Bs%3A13%3A%22_csrf-backend%22%3Bi%3A1%3Bs%3A32%3A%223KMZ1u9B55vDbbaW9fCkKUQXAYdvVWUe%22%3B%7D'
    };
    var request = http.Request('POST',
        Uri.parse('http://162.250.125.124:8090/fummas_mobile/api/user-stations'));
    request.body = json.encode({
      "user_id": userId
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      List<Station> stations = [];
      var responseJson = jsonDecode(await response.stream.bytesToString());

      for (var stationJson in responseJson['stations']) {
        final station = Station(
          id: stationJson['id'] as int,
          name: stationJson['name'] as String,
        );
        stations.add(station);
      }
      for (final station in stations) {
        print('ID: ${station.id}');
        print('Name: ${station.name}');
      }
      return stations;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}
