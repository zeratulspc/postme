import 'package:flutter/material.dart';
import 'package:postme/postpage.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';


Future<bool> createPost(String url, {Map body}) async {
  Map<String, String> headers = {"Content-type": "application/json"};
  return http.post(url, body: body.toString(), headers: headers).then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      return false;
    }
    print("statusCode : $statusCode");
    print("addedbody : $body");

    return true;
  });
}

Future<bool> editPost(String index, {Map body}) async {
  Map<String, String> headers = {"Content-type": "application/json"};
  return http.put("https://jsonplaceholder.typicode.com/posts/1", body: body.toString(), headers: headers).then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      return false;
    }

    print("statusCode : $statusCode");
    print("addedbody : $body");
      return true;
  });
}

Future<bool> deletePost(String index) async {
  return http.delete("https://jsonplaceholder.typicode.com/posts/"+index,).then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      return false;
    }

    print("statusCode : $statusCode");
    return true;
  });
}


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


  void _checkEdit(BuildContext scaffoldContext) {
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
              onPressed: () async {
                Navigator.of(context).pop();
                Posts newPost =  Posts(
                    userId: userValuePost, id: 0, title: titleController.text, body: bodyController.text);
                bool isEdited = await editPost(index.toString(),
                    body: newPost.toMap());
                if(isEdited){
                  editThis(titleController.text, bodyController.text, index);
                  Navigator.pop(scaffoldContext, editedPosts);
                } else{
                 print('Edit failed');
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _checkAdd(BuildContext scaffoldContext) {
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
              onPressed: () async {
                Navigator.of(context).pop();
                Posts newPost =  Posts(
                    userId: userValuePost ?? 0, id: 0, title: titleController.text ?? '0', body: bodyController.text ?? '0');
                bool isCreated = await createPost("https://jsonplaceholder.typicode.com/posts",
                    body: newPost.toMap());
                print("Post was created ? $isCreated");
                if(isCreated){
                  submit(titleController.text, bodyController.text);
                  Navigator.pop(scaffoldContext, addedPost);
                } else{
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text('failed to post!')));
                }
              },
            ),
          ],
        );
      },
    );
  }

  void submit(String titleText, String bodyText) {
    addedPost = Posts(userId: userValuePost ?? 1, id: 1, title: titleText, body: bodyText);
    setState(() {
      _titleSubmitted(titleText);
      _bodySubmitted(bodyText);
    });
  }


  Widget caseAppbar(BuildContext context) {
    return callCase == 1 ? AppBar(title: Text('New Post'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          color: Colors.white,
          onPressed: () {
            _checkAdd(context);
          },
        )
      ],
    ) : AppBar(title: Text('New Post'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.border_color),
          color: Colors.white,
          onPressed: () {
            _checkEdit(context);
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
      appBar: caseAppbar(context),
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




  void _titleSubmitted(String titleText) {
    titleController.clear();
  }

  void _bodySubmitted(String bodyText) {
    bodyController.clear();
  }

}
