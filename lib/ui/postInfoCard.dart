import 'package:event/ui/attendForm.dart';
import 'package:flutter/material.dart';
import '../utils/eventPost.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/CommonData.dart';
import '../utils/userData.dart';

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
  bool _isButtonDisabled;
  void attend(Function callBack) {
    this.setState(() {
      callBack();
    });
  }

  void click() {
    print("button clicked");
    //EventPost.attendEvent(widget.user);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AttendForm()));
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
                        color: post.userRegistered.contains(widget.user.uid)
                            ? Colors.grey
                            : Colors.blue,
                        textColor: Colors.white,
                        padding: EdgeInsets.all(8.0),
                        splashColor: Colors.grey,
                        onPressed: () =>
                            this.attend(() => post.attendEvent(widget.user)),
                        child: Text(
                          "Attend",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ))
                    ]),
              ));
        });
  }
}
