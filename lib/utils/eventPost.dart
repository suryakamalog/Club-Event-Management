import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'eventDatabase.dart';

class EventPost {
  String name;
  String date;
  String time;
  String venue;
  String detail;
  Set userRegistered = {};

  DatabaseReference _id;

  EventPost(this.name, this.date, this.time, this.venue, this.detail);

  dynamic currentEventID() {
    return this._id.key;
  }

  void attendEvent(User user) {
    //print('${this._id.key}' + " <------ " + '${this.userRegistered}');
    if (this.userRegistered.contains(user.uid)) {
      //this.userRegistered.remove(user.uid);
      Fluttertoast.showToast(
          msg: "Already Registered!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      this.userRegistered.add(user.uid);
      Fluttertoast.showToast(
          msg: "Successfully registered",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    this.update();
  }

  void update() {
    updatePost(this, this._id);
  }

  void setId(DatabaseReference id) {
    this._id = id;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': this.name,
      'date': this.date,
      'time': this.time,
      'venue': this.venue,
      'detail': this.detail,
      'userRegistered': this.userRegistered.toList(),
    };
  }
}

EventPost createPost(record) {
  Map<String, dynamic> attributes = {
    'name': '',
    'date': '',
    'time': '',
    'venue': '',
    'detail': '',
    'userRegistered': [],
  };

  record.forEach((key, value) => {attributes[key] = value});

  EventPost post = new EventPost(attributes['name'], attributes['date'],
      attributes['time'], attributes['venue'], attributes['detail']);
  post.userRegistered = new Set.from(attributes['userRegistered']);
  return post;
}
