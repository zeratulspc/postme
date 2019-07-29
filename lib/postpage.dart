import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:postme/comments.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {

  Future<List<User>> _getUsers() async {
    var data = await http.get("https://jsonplaceholder.typicode.com/posts");
    var jsonData = json.decode(data.body);
    List<User> users = [];
    for(var u in jsonData){
      User user = User(u["userId"], u["id"], u["title"], u["body"], );
      users.add(user);
    }
    print(users.length);
    return users;
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text('Posts'),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getUsers(),
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
                  return ListTile(
                    leading: Text('User'+snapshot.data[index].userId.toString()),
                    title: Text(snapshot.data[index].title),
                    subtitle: Text(snapshot.data[index].body),
                    onTap: (){

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => DetailPage(snapshot.data[index]))
                      );

                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}


class DetailPage extends StatelessWidget {

  final User user;
  DetailPage(this.user);

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
    return Scaffold(
        appBar: AppBar(
          title: Text('Detail'),
        ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Text(user.title, style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child:  Text(user.body, style: TextStyle(fontSize: 16,),),

            ),
          ],
        ),
      ),
    );
  }

}


class User {
  final int userId;
  final int id;
  final String title;
  final String body;

  User(this.userId, this.id, this.title, this.body);

}