import 'package:flutter/material.dart';
import 'package:postme/postpage.dart';

class DropDownButton extends StatefulWidget {
  @override
  _DropDownButtonState createState() => _DropDownButtonState();
}

class _DropDownButtonState extends State<DropDownButton> {
  var _value = "0";

  DropdownButton _normalDown() => DropdownButton<String>(
    items: [
      dropItem('0', '???'),
      dropItem('1', 'user1'),
      dropItem('2', 'user2'),
      dropItem('3', 'user3'),
      dropItem('4', 'user4'),
      dropItem('5', 'user5'),
      dropItem('6', 'user6'),
      dropItem('7', 'user7'),
      dropItem('8', 'user8'),
      dropItem('9', 'user9'),
      dropItem('10', 'user10'),
    ],
    onChanged: (value) {
      setState(() {
        _value = value;
      });
      if(int.parse(_value)>0) {
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
          content: Text('Do you want to start PostME! with User'+_value+'?',),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PostPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }



  dropItem(String value, String text) {
    return DropdownMenuItem<String>(

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


}