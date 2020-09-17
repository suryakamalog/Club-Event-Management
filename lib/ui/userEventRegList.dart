import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/ui/userEventRegCard.dart';
import 'package:flutter/material.dart';

class UserEventRegList extends StatefulWidget {
  final dynamic uid;
  UserEventRegList(this.uid);
  @override
  _UserEventRegListState createState() => _UserEventRegListState();
}

class _UserEventRegListState extends State<UserEventRegList> {
  List<dynamic> events = [];
  Future<void> getAllEvents() async {
    var d = await FirebaseFirestore.instance
        .collection('attendedEvents')
        .doc(widget.uid)
        .get()
        .then((DocumentSnapshot ds) async {
      setState(() {
        events = ds.data()['attendedEvents'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF4747),
        title: Text('Registered Events'),
      ),
      body: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: events.length,
          itemBuilder: (context, index) {
            var eventID = events[index];

            return UserEventRegCard(eventID);
          }),
    );
  }
}
