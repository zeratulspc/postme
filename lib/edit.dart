import 'package:flutter/material.dart';
import 'package:postme/postpage.dart';


class EditPage extends StatefulWidget {
  final List<Posts> post;
  final callCase;
  final index;
  EditPage({Key key, this.index, this.callCase, this.post}) : super(key: key);

  @override
  EditPageState createState() => EditPageState(callCase:  callCase, index:  index, post:  post);
}

class EditPageState extends State<EditPage> {
  final List<Posts> post;
  final callCase; // 1= add, 2=edit
  final index;
  EditPageState({this.index, this.callCase, this.post});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if(callCase == 1) {
      titleController.text = '';
      bodyController.text = '';
    }
    else {
      titleController.text = post[index].title;
      bodyController.text = post[index].body;
    }
  }


  void _checkEdit() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('Do you want to Edit this Post?',),
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
                editThis(titleController.text, bodyController.text, index);
                Navigator.pop(context, addedPost);
              },
            ),
          ],
        );
      },
    );
  }

  void _checkadd() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('Do you want to add this Post?',),
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
                submit(titleController.text, bodyController.text);
                Navigator.pop(context, addedPost);
              },
            ),
          ],
        );
      },
    );
  }



  Widget caseAppbar() {
    return callCase == 1 ? AppBar(title: Text('New Post'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          color: Colors.white,
          onPressed: () {
            _checkadd();
          },
        )
      ],
    ) : AppBar(title: Text('New Post'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.border_color),
          color: Colors.white,
          onPressed: () {
            _checkEdit();
          },
        )
      ],
    );
  }

  var editedPosts;

  void editThis(String title, String body, index) {
    editedPosts = Posts(userId: post[index].userId, id: post[index].userId, title: title, body: body);
    setState(() {
      post[index] = editedPosts;
      _titleSubmitted(title);
      _bodySubmitted(body);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: caseAppbar(),
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
              ],
            ),
        ),
      ),

      );

  }

  var addedPost;

  void submit(String titleText, String bodyText) {
    addedPost = Posts(userId: userValuePost, id: 1, title: titleText, body: bodyText);
    setState(() {
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
