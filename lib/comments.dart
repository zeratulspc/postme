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
    var commentData = await http.get("https://jsonplaceholder.typicode.com/comments");
    var jsonData = json.decode(commentData.body);
    List<CommentInfo> comments = [];
    for (var c in jsonData) {
      CommentInfo commentInfo = CommentInfo(c["postId"], c["id"], c["name"], c["email"], c["body"]);
      comments.add(commentInfo);
    }
    print('CommentsLength'+comments.length.toString());
    return comments;
  }

  @override
  Widget build(BuildContext context) {
    return commentPage();
  }


  Widget commentPage() {
          return Column(
            children: <Widget>[
              Text('Comments', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
              SizedBox(height: 3.0,),
              Container(
                child: Padding(
                  padding: EdgeInsets.all(2.0),
                  child: FutureBuilder(
                    future: _getComments(),
                    builder: (BuildContext context, AsyncSnapshot commentsSnapshot){
                      print("commetdatapart");
                      print(commentsSnapshot.data);
                      if(commentsSnapshot.data == null){
                        return Container(
                            width: 200,
                            height: 200,
                            child: Center(
                                child: Text("Loading...")
                            )
                        );
                      } else {
                        return Container(
                          width: 380,
                          height: 430,
                          child: ListView.builder(
                            itemCount: commentsSnapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                leading: Icon(Icons.person),
                                title: Text(commentsSnapshot.data[index].name),
                                subtitle: Text(commentsSnapshot.data[index].body),
                                onTap: (){
                                },
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
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
