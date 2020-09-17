import 'package:event/ui/userDashboard.dart';
import 'package:event/ui/adminDashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'signUp.dart';
import 'dart:io';

final FirebaseAuth _auth = FirebaseAuth.instance;

const textStyle = TextStyle(
  fontSize: 16,
);

class LoginPage extends StatefulWidget {
  //final User user;
  //LoginPage(this.user);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _name;
  String _role;
  String _mobile;
  String _email;
  String _password;
  String _year;
  String _branch;

  bool validateEmail = false;
  bool validatePassword = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> click() async {
    _email = "${emailController.text}";
    _password = "${passwordController.text}";

    try {
      UserCredential user = await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);

      var d = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.user.uid)
          .get()
          .then((DocumentSnapshot ds) async {
        _name = ds.data()['name'];
        _mobile = ds.data()['mobile'];
        _email = ds.data()['email'];
        _role = ds.data()['role'];
        _year = ds.data()['year'];
        _branch = ds.data()['branch'];
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('loggedInUsername', _name);
      prefs.setString('loggedInRole', _role);

      var curUser = _auth.currentUser;
      print(_role);
      if (_role == "student")
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => UserDashboard(curUser)));
      else if (_role == "admin")
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AdminDashboard(curUser)));
    } catch (e) {
      print(e.message);
    }
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit the App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => exit(0),
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFFFF4747),
            title: Text('Welcome'),
          ),
          body: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
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
                            // Text("Email",
                            //     style: TextStyle(
                            //         fontFamily: "Poppins-Medium",
                            //         fontSize: ScreenUtil().setSp(45))),
                            TextField(
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              onChanged: (value) {
                                setState(() {
                                  value.isEmpty
                                      ? validateEmail = true
                                      : validateEmail = false;
                                });
                              },
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.mail_outline,
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white70,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    borderSide:
                                        BorderSide(color: Colors.red, width: 2),
                                  ),
                                  // errorText: validateEmail
                                  //     ? "Email can\'t be empty"
                                  //     : null,
                                  hintText: "Email",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 15.0)),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(35),
                            ),
                            // Text("Password",
                            //     style: TextStyle(
                            //         fontFamily: "Poppins-Medium",
                            //         fontSize: ScreenUtil().setSp(45))),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    value.isEmpty
                                        ? validatePassword = true
                                        : validatePassword = false;
                                  });
                                },
                                controller: passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Colors.grey,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white70,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      borderSide: BorderSide(color: Colors.red),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
                                    ),
                                    // errorText: validatePassword
                                    //     ? "Password can\'t be empty"
                                    //     : null,
                                    hintText: "Password",
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 15.0)),
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(40),
                            ),
                            Center(
                                child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.red)),
                              color: Colors.red,
                              textColor: Colors.white,
                              padding: EdgeInsets.all(8.0),
                              splashColor: Colors.white,
                              onPressed: this.click,
                              child: Text(
                                "Login",
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                      child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "New User? ",
                                  style: TextStyle(
                                    fontFamily: "Poppins-Medium",
                                    fontSize: 18.0,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                new SignUp()));
                                  },
                                  child: Text("SignUp",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontFamily: "Poppins-Bold",
                                          fontSize: 18.0)),
                                ),
                              ])))
                ],
              )),
        ));
  }
}
