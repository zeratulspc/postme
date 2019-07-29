import 'package:flutter/material.dart';
import 'package:postme/dropdown.dart';
import 'package:postme/postpage.dart';
import 'package:postme/comments.dart';

void main() => runApp(MyApp());

final routes = {
  '/': (BuildContext context) => MyApp(),
  '/first': (BuildContext context) => PostPage(),
};

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Post ME!',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        primaryColor: Colors.purple
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();


}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Post ME!', style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              ),
            ),
            SizedBox(height: 30.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('You are',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  ),
                ),
                SizedBox(width: 10,),
                DropDownButton(),
              ],
            ),
          ],
        ),
      ),
    );

  }

}
