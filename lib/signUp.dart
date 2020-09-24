import 'package:event/loginPage.dart';
import 'package:event/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  static const yearList = <String>[
    'I',
    'II',
    'III',
    'IV',
  ];
  final List<DropdownMenuItem<String>> _ydropDownMenuItems = yearList
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();
  String _year = 'I';

  static const branchList = <String>[
    'CSE',
    'ISE',
    'ECE',
    'EE',
    'ME',
    'CV',
    'PS'
  ];
  final List<DropdownMenuItem<String>> _bdropDownMenuItems = branchList
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();
  String _branch = 'CSE';

  String _name;
  String _mobile;
  String _email;
  String _password;
  String _confirmPassword;

  bool validateName = false;
  bool validateMobile = false;
  bool validateEmail = false;
  bool validatePassword = false;
  bool validateConfirmPassword = false;
  bool tooSmallPassword = false;
  bool _obscureText = true;
  bool _obscureText1 = true;

  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool checkAllFields() {
    if ("${mobileController.text}".length < 10) {
      toast("Incorrect Mobile number", Colors.red);
      return false;
    }
    if (!(RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch("${emailController.text}"))) {
      toast("Incorrect Email", Colors.red);
      return false;
    }
    if ("${passwordController.text}".length < 6) {
      toast("Password should be at least 6 characters long", Colors.red);
      return false;
    }
    if ("${passwordController.text}" != "${confirmPasswordController.text}") {
      toast("Passwords do not match", Colors.red);
      return false;
    }
    return true;
  }

  Future<void> click() async {
    if (!checkAllFields()) return;

    _name = "${nameController.text}";
    _mobile = "${mobileController.text}";
    _email = "${emailController.text}";
    _password = "${passwordController.text}";
    _confirmPassword = "${confirmPasswordController.text}";
    // print(_email);
    // print(_password);
    print("clicked");
    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password);

      if (result != null) {
        await result.user.sendEmailVerification();
        await _auth.signOut();
      }

      User user = result.user;

      if (user.emailVerified)
        print("YES VERIFIED");
      else
        print("NOT VERIFIED");
      FirebaseFirestore.instance.collection("users").doc(user.uid).set({
        "name": "${nameController.text}",
        "mobile": "${mobileController.text}",
        "email": "${emailController.text}",
        "year": '${_year}',
        "branch": '${_branch}',
        "uid": "${user.uid}",
        "role": "student"
      });
      print("registered the user");
      print(user.uid);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF4747),
        title: Text('Register'),
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
                        Text("Name",
                            style: TextStyle(
                                fontFamily: "Poppins-Medium",
                                fontSize: ScreenUtil().setSp(38))),
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              value.isEmpty
                                  ? validateName = true
                                  : validateName = false;
                            });
                          },
                          controller: nameController,
                          decoration: InputDecoration(
                              errorText:
                                  validateName ? "Name can\'t be empty" : null,
                              hintText: "Name",
                              hintStyle: TextStyle(
                                  color: Colors.grey, fontSize: 12.0)),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(30)),
                        Text("Mobile",
                            style: TextStyle(
                                fontFamily: "Poppins-Medium",
                                fontSize: ScreenUtil().setSp(38))),
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              value.isEmpty || value.length != 10
                                  ? validateMobile = true
                                  : validateMobile = false;
                            });
                          },
                          maxLength: 10,
                          controller: mobileController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              // errorText: validateMobile
                              //     ? "Mobile can\'t be empty"
                              //     : null,
                              hintText: "Mobile",
                              prefixText: '+91-',
                              hintStyle: TextStyle(
                                  color: Colors.grey, fontSize: 12.0)),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(35),
                        ),
                        Text("Email",
                            style: TextStyle(
                                fontFamily: "Poppins-Medium",
                                fontSize: ScreenUtil().setSp(38))),
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
                              errorText: validateEmail
                                  ? "Email can\'t be empty"
                                  : null,
                              hintText: "Email",
                              hintStyle: TextStyle(
                                  color: Colors.grey, fontSize: 12.0)),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(35),
                        ),
                        DropdownButton(
                          isExpanded: true,
                          items: this._ydropDownMenuItems,
                          onChanged: (String newValue) {
                            setState(() {
                              _year = newValue;
                            });
                          },
                          value: _year,
                        ),
                        SizedBox(height: ScreenUtil().setHeight(30)),
                        DropdownButton(
                          isExpanded: true,
                          items: this._bdropDownMenuItems,
                          onChanged: (String newValue) {
                            setState(() {
                              _branch = newValue;
                            });
                          },
                          value: _branch,
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(35),
                        ),
                        Text("Password",
                            style: TextStyle(
                                fontFamily: "Poppins-Medium",
                                fontSize: ScreenUtil().setSp(38))),
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
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                                suffixIcon: new GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  child: new Icon(_obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                ),
                                errorText: validatePassword
                                    ? "Password can\'t be empty"
                                    : null,
                                hintText: "Password",
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 12.0)),
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(40),
                        ),
                        Text("Confirm Password",
                            style: TextStyle(
                                fontFamily: "Poppins-Medium",
                                fontSize: ScreenUtil().setSp(38))),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                value.isEmpty
                                    ? validateConfirmPassword = true
                                    : validateConfirmPassword = false;
                              });
                            },
                            controller: confirmPasswordController,
                            obscureText: _obscureText1,
                            decoration: InputDecoration(
                                suffixIcon: new GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscureText1 = !_obscureText1;
                                    });
                                  },
                                  child: new Icon(_obscureText1
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                ),
                                errorText:
                                    confirmPasswordController.text.isNotEmpty &&
                                            passwordController.text !=
                                                confirmPasswordController.text
                                        ? "Password does not match"
                                        : null,
                                hintText: "Confirm Password",
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 12.0)),
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
                            "SignUp",
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
