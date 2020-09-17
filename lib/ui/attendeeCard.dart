import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendeeCard extends StatefulWidget {
  final dynamic uid;
  final dynamic eventID;
  AttendeeCard(this.uid, this.eventID);
  @override
  _AttendeeCardState createState() => _AttendeeCardState();
}

class _AttendeeCardState extends State<AttendeeCard> {
  String name = "Loading...";

  Future<void> getData(dynamic uid) async {
    var data = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot ds) async {
      setState(() {
        name = ds.data()['name'];
      });
    });
  }

  List<dynamic> foundUsers = [];
  Future<void> getFoundUsers() async {
    var d = await FirebaseFirestore.instance
        .collection('foundUsers')
        .doc(widget.eventID)
        .get()
        .then((DocumentSnapshot ds) async {
      setState(() {
        foundUsers = ds.data()['foundUsers'];
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData(widget.uid);
    getFoundUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: foundUsers.contains(widget.uid)
          ? Color(0xFFA3E6CA)
          : Color(0xFFE6A3A3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 6.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[Text('Name: $name'), Text('UID: ${widget.uid}')],
        ),
      ),
    );
  }
}
