import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:postme/Posts.dart';
import 'package:postme/edit.dart';

import 'package:shared_preferences/shared_preferences.dart';



class Posts {
  final int userId;
  final int id;
  final String title;
  final String body;

  Posts(this.userId, this.id, this.title, this.body);

}