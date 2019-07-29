import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Comments extends StatefulWidget {
  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {

  Future<List<CommentInfo>> _getComments() async {
    var data = await http.get("https://jsonplaceholder.typicode.com/comments");
    var jsonData = json.decode(data.body);
    List<CommentInfo> comments = [];
    for (var c in jsonData) {
      CommentInfo commentInfo = CommentInfo(c["postId"], c["id"], c["name"], c["email"], c["body"]);
      comments.add(commentInfo);
    }
    print(comments.length);
    return comments;
  }

  @override
  Widget build(BuildContext context) {
    return commentPage();
  }


  commentPage() {
    showBottomSheet(context: context,
        builder: (BuildContext context) {
          return Column(
            children: <Widget>[
              Text('Comments', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
              SizedBox(height: 3.0,),
              Container(
                child: FutureBuilder(
                  future: _getComments(),
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    print(snapshot.data);
                    if(snapshot.data == null){
                      return Container(
                          child: Center(
                              child: Text("Loading...")
                          )
                      );
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          //  CommentInfo(this.postId, this.id, this.name, this.email, this.body);
                          return ListTile(
                            leading: Text(snapshot.data[index].name),
                            title: Text(snapshot.data[index].name),
                            subtitle: Text(snapshot.data[index].body),
                            onTap: (){
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          );
        }
    );
  }
}

class CommentInfo {
  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  CommentInfo(this.postId, this.id, this.name, this.email, this.body);

}
