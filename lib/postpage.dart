import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:postme/comments.dart';
import 'package:postme/edit.dart';

import 'package:shared_preferences/shared_preferences.dart';




int userValuePost;

Future<List<Posts>> _getUsers() async {
  var postData = await http.get("https://jsonplaceholder.typicode.com/posts");
  var jsonData = json.decode(postData.body);


  List<Posts> users = [];

  if(titleStr != null) {
    Posts added = Posts(userValuePost, 1, titleStr, bodyStr);
    users.add(added);
  }

  for(var u in jsonData){
    Posts user = Posts(u["userId"], u["id"], u["title"], u["body"], );
    users.add(user);
  }


  print('users.length:'+users.length.toString());
  return users;
}


  List<Posts> posts = [];






class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    getValue();
    super.initState();
    print('HomePage');
  }


  SharedPreferences sharedPreferences;
  getValue() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userValuePost = sharedPreferences.getInt("value") ?? 0;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text('Posts'),
          actions: <Widget>[
            IconButton(
            icon: Icon(Icons.border_color),
            onPressed: () {
                Navigator.of(context).pushNamed('/edit');
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).pushNamed('/setting');
              },
            ),
          ],
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
                    leading: Column(
                      children: <Widget>[
                        Icon(Icons.person,),
                        Text('User'+snapshot.data[index].userId.toString()),
                        Text('User'+users.data[index].userId.toString()),
                      ],
                    ),
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

  final Posts user;
  DetailPage(this.user);


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
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Comments(),
            ),
          ],
        ),
      ),
    );
  }

}


class Posts {
  final int userId;
  final int id;
  final String title;
  final String body;

  Posts(this.userId, this.id, this.title, this.body);

}

