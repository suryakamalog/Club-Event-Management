import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

final databaseReference = FirebaseDatabase.instance.reference();

class UserEventRegCard extends StatefulWidget {
  final dynamic eventID;
  UserEventRegCard(this.eventID);
  @override
  _UserEventRegCardState createState() => _UserEventRegCardState();
}

class _UserEventRegCardState extends State<UserEventRegCard> {
  String name = "Loading...";
  Future<void> getParticularPost(dynamic eventID) async {
    var d = (await databaseReference
            .child('eventPosts/' + widget.eventID.toString())
            .once())
        .value;
    setState(() {
      name = d['name'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getParticularPost(widget.eventID);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 6.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Name: $name'),
            Text('EventID: ${widget.eventID}')
          ],
        ),
      ),
    );
  }
}
