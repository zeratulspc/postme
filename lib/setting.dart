import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

int userValue;

class Setting extends StatefulWidget {
  SettingState createState() => SettingState();
}

class SettingState extends State<Setting> {

  SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting',),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            child: Text('User',
              style: TextStyle(fontSize: 18.0,
                  color: Colors.purple),),
          ),
          ListTile(
            title: Text('You are User$userValue'),
            subtitle: Text('Quit'),
            onTap: () {
              _showDialog();
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            child: Text('Information',
              style: TextStyle(fontSize: 18.0,
                  color: Colors.purple),),
          ),
          ListTile(
            title: Text('Developer'),
            subtitle: Text('db'),
            onTap: () {
            },
          ),
          ListTile(
            title: Text('Version'),
            subtitle: Text('1.0.0'),
            onTap: () {
            },
          ),
        ],
      )
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('Do you want to Quit?',),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: (){
                Navigator.of(context).pop();

              },
            ),
            FlatButton(
              child: Text('CONFIRM'),
              onPressed: (){
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                cleanValue();
                Navigator.of(context).pushReplacementNamed('/checkPage');
              },
            ),
          ],
        );
      },
    );
  }

  cleanValue() async {
    sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setInt("value", 0);
  }

}