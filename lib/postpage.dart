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

  Map toMap() {
    var map = Map<String, dynamic>();
    map['userId'] = userId;
    map['id'] = id;
    map['title'] = '$title';
    map['body'] = '$body';

    return map;
  }

}


class PostsLists extends StatefulWidget {
  @override
  PostsListsState createState() => PostsListsState();

}

class PostsListsState extends State<PostsLists> {
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

  getPostLists() {
    return posts;
  }

  _refreshAction() {
    setState(() {
    });
  }


  SharedPreferences sharedPreferences;
  getValue() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userValuePost = sharedPreferences.getInt("value") ?? 0;
    });
  }

  _openAddPage(BuildContext context) async {
    final Posts receivedPosts = await Navigator.push(
        context , MaterialPageRoute(builder: (context) => EditPage(callCase: 1,))
    );
    posts.insert(0, receivedPosts);
    _refreshAction();
  }
  RandomColor _randomColor = RandomColor();

  @override
  Widget build(BuildContext postListContext) {
    return Scaffold(
      appBar:AppBar(
        title:Text('Posts'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _openAddPage(postListContext);
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.of(postListContext).pushNamed('/setting');
            },
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: posts?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: Column(
                children: <Widget>[
                  Icon(Icons.person,
                    color: _randomColor.randomColor(),),
                  Text('User'+posts[index].userId.toString() ?? "0"),
                ],
              ),
              title: Text(posts[index].title),
              subtitle: Text(posts[index].body),
              onTap: (){
                openDetailPage(context, posts, index);
              },
            );
          }
      ),
    );


}
  openDetailPage(BuildContext openDetailPageContext, List<Posts> post, index) async {
    final indexB = await Navigator.push(openDetailPageContext,
        MaterialPageRoute(builder: (context) => DetailPage(post, index))
    );
    if(indexB != null) {
      post.removeAt(indexB);
    }
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

  PostsListsState postList = PostsListsState();

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
      builder: (BuildContext scaffoldContext) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('Do you want to Delete?',),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: (){
                Navigator.of(scaffoldContext).pop();
              },
            ),
            FlatButton(
              child: Text('CONFIRM'),
              onPressed: () async {
                bool isDeleted = await deletePost(index.toString());
                Navigator.of(scaffoldContext).pop();
                if(isDeleted){
                  post.removeAt(index);
                  Navigator.pop(scaffoldContext);
                } else{
                  Scaffold.of(scaffoldContext).showSnackBar(SnackBar(content: Text('failed to Delete!')));
                }
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
    if (editedPosts != null) {
      setState(() {
        post[index] = editedPosts;
      });
    }
  }

  @override
  Widget build(BuildContext detailPageContext) {
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


