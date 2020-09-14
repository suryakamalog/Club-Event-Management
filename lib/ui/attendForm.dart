import 'package:event/utils/eventPost.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AttendForm extends StatefulWidget {
  @override
  _AttendFormState createState() => _AttendFormState();
}

class _AttendFormState extends State<AttendForm> {
  String _name;
  String _email;
  String _mobile;
  String _year;
  String _branch;

  bool validateYear = false;
  bool validateBranch = false;

  TextEditingController yearController = TextEditingController();

  void click() {
    print("clicked");
    DataSnapshot snapshot;
    print(snapshot);
    // Map<dynamic, dynamic> data = snapshot.value;
    // print('${data['name']}');
    setState(() {
      print(this._name);
      print("inside setstate");
    });
    Navigator.pop(context);
  }

  int _value = 1; //dropDown value

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff028090),
        title: Text('Fill your details'),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
          child: ListView(
            children: <Widget>[
              Container(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 6.0,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Year",
                            style: TextStyle(
                                fontFamily: "Poppins-Medium",
                                fontSize: ScreenUtil().setSp(38))),
                        DropdownButton(
                            value: _value,
                            items: [
                              DropdownMenuItem(
                                child: Text("I"),
                                value: 1,
                              ),
                              DropdownMenuItem(
                                child: Text("II"),
                                value: 2,
                              ),
                              DropdownMenuItem(child: Text("III"), value: 3),
                              DropdownMenuItem(child: Text("IV"), value: 4),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _value = value;
                              });
                            }),
                        SizedBox(height: ScreenUtil().setHeight(30)),
                        Text("Branch",
                            style: TextStyle(
                                fontFamily: "Poppins-Medium",
                                fontSize: ScreenUtil().setSp(38))),
                        DropdownButton(
                            value: _value,
                            items: [
                              DropdownMenuItem(
                                child: Text("CSE"),
                                value: 1,
                              ),
                              DropdownMenuItem(
                                child: Text("ISE"),
                                value: 2,
                              ),
                              DropdownMenuItem(child: Text("ECE"), value: 3),
                              DropdownMenuItem(child: Text("EE"), value: 4),
                              DropdownMenuItem(child: Text("EI"), value: 5),
                              DropdownMenuItem(child: Text("ME"), value: 6),
                              DropdownMenuItem(child: Text("CV"), value: 7)
                            ],
                            onChanged: (value) {
                              setState(() {
                                _value = value;
                              });
                            }),
                        SizedBox(
                          height: ScreenUtil().setHeight(35),
                        ),
                        Center(
                            child: FlatButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          padding: EdgeInsets.all(8.0),
                          splashColor: Colors.blueAccent,
                          onPressed: this.click,
                          child: Text(
                            "Submit",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
