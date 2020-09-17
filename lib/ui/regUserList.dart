import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/ui/attendeeCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegUserList extends StatefulWidget {
  final dynamic eventID;
  final List<dynamic> userRegistered;

  //List<dynamic> x = userRegistered.toList();
  RegUserList(this.eventID, this.userRegistered);

  @override
  _RegUserListState createState() => _RegUserListState();
}

class _RegUserListState extends State<RegUserList> {
  String text, qrCodeResult = "Not Yet Scanned";

  Future<void> addToFound() async {
    var list = [qrCodeResult];

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
  }

  Future _scan() async {
    text = await FlutterBarcodeScanner.scanBarcode(
        "#000000", "Cancel", true, ScanMode.QR);

    setState(() {
      qrCodeResult = text;
    });
    print(qrCodeResult);

    if (widget.userRegistered.contains(qrCodeResult)) {
      addToFound();

      Fluttertoast.showToast(
          msg: "Approved",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "User Not Found!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff028090),
        title: Text('Attendees'),
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: this.widget.userRegistered.length,
            itemBuilder: (context, index) {
              dynamic attendee = this.widget.userRegistered[index];
              return AttendeeCard(attendee, widget.eventID);
            },
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: _scan,
        child: Icon(Icons.settings_overscan),
        backgroundColor: Colors.green,
      ),
    );
  }
}
