import 'package:event/ui/regUserList.dart';
import 'package:event/utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/eventPost.dart';
import 'package:firebase_auth/firebase_auth.dart';

const textStyle = TextStyle(
  fontSize: 16,
);

class PostInfo extends StatefulWidget {
  final List<EventPost> listItems;
  final User user;

  PostInfo(this.listItems, this.user);

  @override
  _PostInfoState createState() => _PostInfoState();
}

class _PostInfoState extends State<PostInfo> {
  // var post;
  void attend(Function callBack) {
    this.setState(() {
      callBack();
    });
  }

  String _role;
  shared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _role = prefs.getString(Constants.loggedInUserRole);
    });
  }

  @override
  void initState() {
    super.initState();
    shared();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: this.widget.listItems.length,
        itemBuilder: (context, index) {
          var post = this.widget.listItems[index];

          return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 6.0,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        //'change $date'
                        'WorkshopName: ${post.name}',
                        style: textStyle,
                      ),
                      Text(
                        'Date: ${post.date}',
                        style: textStyle,
                      ),
                      Text(
                        'Time: ${post.time}',
                        style: textStyle,
                      ),
                      Text(
                        'Venue: ${post.venue}',
                        style: textStyle,
                      ),
                      Wrap(
                        children: <Widget>[
                          Text(
                            'Details: ${post.detail}',
                            //overflow: TextOverflow.ellipsis,
                            style: textStyle,
                          ),
                        ],
                      ),
                      SizedBox(
                        //Use of SizedBox
                        height: 10,
                      ),
                      Center(
                          child: FlatButton(
                        color: _role == "admin"
                            ? Colors.blue
                            : (post.userRegistered.contains(widget.user.uid)
                                ? Colors.grey
                                : Colors.blue),
                        textColor: Colors.white,
                        padding: EdgeInsets.all(8.0),
                        splashColor: Colors.grey,
                        onPressed: () {
                          if (_role == 'admin') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegUserList(
                                        post.currentEventID(),
                                        post.userRegistered.toList())));
                          } else {
                            print("in this");
                            this.attend(() => post.attendEvent(widget.user));
                          }
                        },
                        child: Text(
                          _role == "admin" ? "See attendees" : "Register",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ))
                    ]),
              ));
        });
  }
}
