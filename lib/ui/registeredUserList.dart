import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class RegisteredUserList extends StatefulWidget {
  final dynamic eventID;
  final List<dynamic> userRegistered;

  RegisteredUserList(this.eventID, this.userRegistered);
  @override
  _RegisteredUserListState createState() => _RegisteredUserListState();
}

class _RegisteredUserListState extends State<RegisteredUserList> {
  String text, qrCodeResult = "Not Yet Scanned";
  String name = "Loading...";
  List<dynamic> foundUsers = [];
  bool _disposed = false;
  var nameData = new Map();
  Future<void> addToFound(dynamic uid) async {
    var list = [uid];

    final snapshot = await FirebaseFirestore.instance
        .collection("foundUsers")
        .doc(widget.eventID)
        .get();

    if (snapshot == null || !snapshot.exists) {
      FirebaseFirestore.instance
          .collection("foundUsers")
          .doc(widget.eventID)
          .set({
        "foundUsers": [],
      });

      FirebaseFirestore.instance
          .collection("foundUsers")
          .doc(widget.eventID)
          .update({"foundUsers": FieldValue.arrayUnion(list)});
    } else {
      FirebaseFirestore.instance
          .collection("foundUsers")
          .doc(widget.eventID)
          .update({"foundUsers": FieldValue.arrayUnion(list)});
    }
    setState(() {});
  }

  Future _scan() async {
    text = await FlutterBarcodeScanner.scanBarcode(
        "#000000", "Cancel", true, ScanMode.QR);

    qrCodeResult = text;
    print(qrCodeResult);

    if (widget.userRegistered.contains(qrCodeResult)) {
      addToFound(qrCodeResult);

      toast("Approved", Colors.green);
    } else {
      toast("User Not Found!", Colors.red);
    }
    initState();
    setState(() {});
  }

  Future<void> getFoundUsers() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("foundUsers")
        .doc(widget.eventID)
        .get();
    if (snapshot != null && snapshot.exists) {
      await FirebaseFirestore.instance
          .collection('foundUsers')
          .doc(widget.eventID)
          .get()
          .then((DocumentSnapshot ds) async {
        if (!_disposed) {
          setState(() {
            foundUsers = ds.data()['foundUsers'];
          });
        }
      });
    }
  }

  void getAllData() async {
    for (var i = 0; i < widget.userRegistered.length; i++) {
      DocumentSnapshot variable = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userRegistered[i])
          .get();
      name = variable.data()['name'];
      nameData[widget.userRegistered[i]] = name;
      setState(() {});
    }
  }

  @override
  void initState() {
    getFoundUsers();
    getAllData();
    super.initState();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF4747),
        title: Text('Attendees'),
      ),
      body: Column(children: <Widget>[
        Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Checked In: ${foundUsers.length}',
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Total: ${widget.userRegistered.length}',
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: this.widget.userRegistered.length,
            itemBuilder: (context, index) {
              dynamic attendee = this.widget.userRegistered[index];
              String attendeeName = nameData[attendee];
              return Card(
                color: foundUsers.contains(attendee)
                    ? Color(0xFFA3E6CA)
                    : Color(0xFFE6A3A3),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 6.0,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Name: $attendeeName'),
                      Text('UID: $attendee')
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _scan,
        icon: Icon(
          Icons.camera,
          size: 30,
        ),
        label: Text('Scan QR', style: TextStyle(fontSize: 20)),
        backgroundColor: Color(0xFFFFB547),
      ),
    );
  }
}
