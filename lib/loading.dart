import 'package:flutter/material.dart';
import 'package:postme/dropdown.dart';
import 'package:postme/postpage.dart';
import 'package:postme/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();


}

class _LoginPageState extends State<LoginPage> {
  String _status = 'no-action';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .primaryColor,
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

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Post me!(loading)'),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() =>  _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Widget defaultHome = Loading();

  int valueForCheck = 0;

  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    getValue();
  }

  @override
  Widget build(BuildContext context) {
    return defaultHome;
  }

  getValue() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      valueForCheck = sharedPreferences.getInt("value") ?? 0;
    });
    if (valueForCheck > 0) {
      Future.delayed(Duration(seconds: 3), (){
        Navigator.of(context).pushReplacementNamed('/home');
      });
    }else {
      defaultHome = LoginPage();
    }
  }
}