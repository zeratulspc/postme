import 'package:flutter/material.dart';
import 'package:postme/postpage.dart';
import 'package:postme/loading.dart';
import 'package:postme/setting.dart';
import 'package:postme/edit.dart';

import 'package:http/http.dart' as http;


final routes = {
  '/login': (BuildContext context) => LoginPage(),
  '/home': (BuildContext context) => HomePage(),
  '/Loading': (BuildContext context) => Loading(),
  '/checkPage': (BuildContext context) => SplashScreen(),
  '/setting' : (BuildContext context) => Setting(),
  '/edit' : (BuildContext context ) => EditPage(),
};

void main() {
        fetchPosts(http.Client());
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

