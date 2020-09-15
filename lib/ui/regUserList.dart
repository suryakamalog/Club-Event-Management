import 'package:flutter/material.dart';

class RegUserList extends StatefulWidget {
  final dynamic eventID;
  final List<dynamic> userRegistered;

  //List<dynamic> x = userRegistered.toList();
  RegUserList(this.eventID, this.userRegistered);

  @override
  _RegUserListState createState() => _RegUserListState();
}

class _RegUserListState extends State<RegUserList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: this.widget.userRegistered.length,
      itemBuilder: (context, index) {
        var attendees = this.widget.userRegistered[index];

        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 6.0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[Text('UID: ${attendees}')],
            ),
          ),
        );
      },
    );
  }
}
