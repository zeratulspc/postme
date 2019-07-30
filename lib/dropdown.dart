import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:postme/postpage.dart';
import 'package:postme/loading.dart';

class DropDownButton extends StatefulWidget {

  @override
  _DropDownButtonState createState() => _DropDownButtonState();
}

class _DropDownButtonState extends State<DropDownButton> {
  final items =  List<DropdownMenuItem<int>>();
  var _value = 0;
  SharedPreferences sharedPreferences;


  @override
  void initState() {
    super.initState();
    items.add(dropItem(0, '???'));
    items.addAll(lotOfItem());
    getValue();
  }

  DropdownButton _normalDown() => DropdownButton<int>(
    items: this.items,
    onChanged: (value) {
      setState(() {
        _value = value;
        setValue();
      });
      if(_value >0) {
        _showDialog();
      }
    },
    value: _value,
  );

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('Do you want to start PostME! with User'+_value.toString()+'?',),
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
                Navigator.of(context).pushReplacementNamed('/home');
              },
            ),
          ],
        );
      },
    );
  }

  List<DropdownMenuItem<int>> lotOfItem(){
    List<DropdownMenuItem<int>> list = List();
    for(int i = 1;i <= 10; i++){
      list.add(dropItem(i, 'User'+i.toString()));
    }
    return list;
  }

  dropItem(int value, String text) {
    return DropdownMenuItem<int>(
      value: value,
      child: Text(
        text,
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          //our code.
          Container(
            child: _normalDown(),
          ),
        ],
      ),
    );
  }

  setValue() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.setInt("value", _value);
    });
  }

  getValue() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _value = sharedPreferences.getInt("value") ?? 0;
    });
  }




}