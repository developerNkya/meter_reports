import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:name2/name2.dart';
import 'package:flutter_session/flutter_session.dart';

class HomePage extends StatelessWidget {
  Future<dynamic> _getUsername() async {
    dynamic username = await FlutterSession().get('username');
    return username;
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
          child: FutureBuilder(
            future: _getUsername(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final username = snapshot.data;
                return Column(
                  children: [
                    SizedBox(
                      height: 32,
                    ),
                    padded(HomeBanner()),
                    SizedBox(
                      height: 67,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AvatarGlow(
                          glowColor: Colors.blue,
                          endRadius: 60.0,
                          duration: Duration(milliseconds: 2000),
                          repeat: true,
                          showTwoGlows: true,
                          repeatPauseDuration: Duration(milliseconds: 100),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Name(
                          username,
                          textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
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
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
