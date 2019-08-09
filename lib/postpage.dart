import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:postme/comments.dart';
import 'package:postme/edit.dart';


import 'package:shared_preferences/shared_preferences.dart';
import 'package:random_color/random_color.dart';




int userValuePost;

Future<List<Posts>> fetchPosts(http.Client client) async {
  final response =
  await client.get('https://jsonplaceholder.typicode.com/posts');

  return compute(parsePosts, response.body);
}

List<Posts> parsePosts(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Posts>((json) => Posts.fromJson(json)).toList();
}


class Posts {
  final int userId;
  final int id;
  final String title;
  final String body;

  Posts({this.userId, this.id, this.title, this.body});

  factory Posts.fromJson(Map<String, dynamic> json) {
    return Posts(
      userId : json['userId'] as int,
      id : json['id'] as int,
      title :json['title'] as String,
      body : json['body'] as String,
    );
  }

}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  List<Posts> posts = List();

  @override
  void initState() {
    getValue();
    super.initState();
    print('HomePage');
    fetchPosts(http.Client()).then((list){
      setState((){
        posts.addAll(list);
        print(posts.length);
      });
    });
  }




  SharedPreferences sharedPreferences;
  getValue() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userValuePost = sharedPreferences.getInt("value") ?? 0;
    });
  }

  _openEditPage(BuildContext context) async {
    final Posts receivedPosts = await Navigator.push(
      context , MaterialPageRoute(builder: (context) => EditPage(callCase: 1,))
    );
    posts.insert(0, receivedPosts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text('Posts'),
          actions: <Widget>[
            IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _openEditPage(context);
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
      body: PostsLists(posts: posts,),
    );

  }

}

class PostsLists extends StatefulWidget {
  final posts;
  const PostsLists({ Key key, this.posts}) : super(key : key);

  @override
  PostsListsState createState() => PostsListsState(thePosts: posts);

}

class PostsListsState extends State<PostsLists> {
  List<Posts> thePosts;

  PostsListsState({this.thePosts});

  RandomColor _randomColor = RandomColor();

  _refreshAction() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: thePosts?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
        return ListTile(
            leading: Column(
              children: <Widget>[
                Icon(Icons.person,
                color: _randomColor.randomColor(),),
                Text('User'+thePosts[index].userId.toString()),
              ],
            ),
            title: Text(thePosts[index].title),
            subtitle: Text(thePosts[index].body),
            onTap: (){
              openDetailPage(context, thePosts, index);
            },
          );
        }
    );

}
  openDetailPage(BuildContext context, List<Posts> post, index) async {
    final indexB = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => DetailPage(post, index))
    );
    post.removeAt(indexB);
  }


}

class DetailPage extends StatefulWidget {
  final List<Posts> post;
  final index;

  DetailPage(this.post, this.index);

  @override
  _DetailPage createState() => _DetailPage(post, index);


}


class _DetailPage extends State<DetailPage> {
  final List<Posts> post;
  final index;

  _DetailPage(this.post, this.index);

  //userValuePost

  @override
  void initState() {
    super.initState();
  }

  _refreshAction() {
    setState(() {
    });
  }

  void _checkDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('Do you want to Delete?',),
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
                Navigator.pop(context, index);
              },
            ),
          ],
        );
      },
    );
  }

  Widget caseAppbar() {
    return userValuePost ==  post[index].userId ? AppBar(
      title: Text('Detail'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.edit),
          color: Colors.white,
          onPressed: () {
            openEditPage(context, index);
          },
        ),
        IconButton(
          icon: Icon(Icons.delete),
          color: Colors.white,
          onPressed: () {
            _checkDelete();
          },
        ),
      ],
    ) : AppBar(title: Text('Detail'));
  }

  openEditPage(BuildContext context, index) async {
    final Posts editedPosts = await Navigator.push(context, MaterialPageRoute(
        builder: (context) =>
            EditPage(index: index, callCase: 2, post: post,))).whenComplete(_refreshAction());
    // change edited
    if (editedPosts != null) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: caseAppbar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Text(post[index].title, style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child:  Text(post[index].body, style: TextStyle(fontSize: 16,),),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Comments(),
              ),
            ],
          ),
        ),
      )
    );
  }

}


