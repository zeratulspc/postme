import 'package:flutter/material.dart';
import 'package:postme/postpage.dart';

String titleStr;
String bodyStr;


class EditPage extends StatefulWidget {
  @override
  EditPageState createState() => EditPageState();
}

class EditPageState extends State<EditPage> {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Post'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.border_color),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
              submit(titleController.text, bodyController.text);
              print('Title : '+titleStr);
              print('Body : '+bodyStr);
            },
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30.0,),
                Container(
                  width: 380,
                  child: TextField(
                    controller: titleController,
                    maxLines: 5,
                    maxLength: 150,
                    decoration: InputDecoration(
                      labelText: "Title",
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                    onSubmitted: _titleSubmitted,
                  ),
                ),
                SizedBox(height: 5.0,),
                Container(
                  width: 380,
                  child: TextField(
                    controller: bodyController,
                    maxLines: 15,
                    maxLength: 500,
                    decoration: InputDecoration(
                      labelText: "Body",
                      fillColor: Colors.grey[300],
                      filled: true,
                  ),
                    onSubmitted: _bodySubmitted,
                ),
              ),
                Text('Title : $titleStr'),
                Text('Body : $bodyStr'),
              ],
            ),
        ),
      ),

      );

  }

  void submit(String titleText, String bodyText) {

    
    setState(() {
      titleStr = titleText;
      bodyStr = bodyText;
      _titleSubmitted(titleText);
      _bodySubmitted(bodyText);
    });
  }

  void _titleSubmitted(String titleText) {
    titleController.clear();
  }

  void _bodySubmitted(String bodyText) {
    bodyController.clear();
  }

}

class AddedInfo {
  int userId;
  int id;
  String title;
  String body;

  AddedInfo(this.userId, this.id, this.title, this.body);
}