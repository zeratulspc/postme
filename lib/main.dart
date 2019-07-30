import 'package:flutter/material.dart';
import 'package:postme/dropdown.dart';
import 'package:postme/postpage.dart';
import 'package:postme/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';


final routes = {
  '/login': (BuildContext context) => LoginPage(),
  '/home': (BuildContext context) => HomePage(),
  '/Loading': (BuildContext context) => Loading(),
  '/checkPage': (BuildContext context) => SplashScreen(),
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

