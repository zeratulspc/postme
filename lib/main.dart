import 'package:flutter/material.dart';
import 'package:postme/postpage.dart';
import 'package:postme/loading.dart';
import 'package:postme/setting.dart';

final routes = {
  '/login': (BuildContext context) => LoginPage(),
  '/home': (BuildContext context) => HomePage(),
  '/Loading': (BuildContext context) => Loading(),
  '/checkPage': (BuildContext context) => SplashScreen(),
  '/setting' : (BuildContext context) => Setting(),
};

void main() async {

        runApp(MaterialApp(
          title: 'Post ME!',
          theme: ThemeData(
              primarySwatch: Colors.purple,
              primaryColor: Colors.purple
          ),
          home: SplashScreen(),
          routes: routes,
        )

        );
}

