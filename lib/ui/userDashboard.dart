import 'dart:async';

import 'package:event/ui/userEventRegList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/eventPost.dart';
import '../utils/eventDatabase.dart';
import '../ui/userProfilePage.dart';
import 'package:event/loginPage.dart';
import 'postInfoCard.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
const textStyle = TextStyle(
  fontSize: 16,
);

class UserDashboard extends StatefulWidget {
  final User user;
  UserDashboard(this.user);
  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  String currentUsername;
  List<EventPost> posts = [];
  String _name;
  String _mobile;
  String _email;
  String _year;
  String _branch;

  Future<void> profileClick() async {
    var d = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .get()
        .then((DocumentSnapshot ds) async {
      _name = ds.data()['name'];
      _mobile = ds.data()['mobile'];
      _email = ds.data()['email'];
      _year = ds.data()['year'];
      _branch = ds.data()['branch'];
    });

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ProfilePage(_name, _mobile, _email, _year, _branch)));
  }

  void newPost(
      String name, String date, String time, String venue, String detail) {
    var post = new EventPost(name, date, time, venue, detail);
    post.setId(savePost(post));
    this.setState(() {
      posts.add(post);
    });
  }

  void updatePosts() {
    getAllPosts().then((posts) => {
          this.setState(() {
            this.posts = posts;
          })
        });
  }

  getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentUsername = prefs.getString('loggedInUsername');
  }

  Future<void> removeAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    prefs.remove('loggedInUsername');
    prefs.remove('loggedInRole');
    prefs.remove('loggedInUID');
    await FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    super.initState();
    getPref();
    updatePosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFFFF4747),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        onTap: (value) {
          if (value == 0) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserEventRegList(widget.user.uid)));
          } else if (value == 1) {
            this.profileClick();
          } else if (value == 2) {
            removeAll();
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          }
        },
        items: [
          BottomNavigationBarItem(
            title: Text('Registered'),
            icon: Icon(Icons.done),
          ),
          BottomNavigationBarItem(
              title: Text('Profile'), icon: Icon(Icons.person)),
          BottomNavigationBarItem(
            title: Text('Logout'),
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Color(0xFFFF4747),
        title: Text('Home'),
        leading: Icon(Icons.home),
      ),
      body: Center(
        child: DelayedList(this.posts, widget.user),
      ),
    );
  }
}

class DelayedList extends StatefulWidget {
  final User user;
  final List<EventPost> posts;
  DelayedList(this.posts, this.user);

  @override
  _DelayedListState createState() => _DelayedListState();
}

class _DelayedListState extends State<DelayedList> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    Timer timer = Timer(Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
    return isLoading
        ? ShimmerList()
        : Datalist(timer, widget.user, widget.posts);
  }
}

class Datalist extends StatelessWidget {
  final Timer timer;
  final User user;
  final List<EventPost> posts;
  Datalist(this.timer, this.user, this.posts);

  @override
  Widget build(BuildContext context) {
    timer.cancel();
    return Column(
      children: <Widget>[
        Expanded(child: PostInfo(this.posts, this.user)),
      ],
    );
  }
}

class ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int offset = 0;
    int time = 800;

    return SafeArea(
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (BuildContext context, int index) {
          offset += 5;
          time = 800 + offset;
          return Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Shimmer.fromColors(
                highlightColor: Colors.white,
                baseColor: Colors.grey[300],
                child: ShimmerLayout(),
                period: Duration(milliseconds: time),
              ));
        },
      ),
    );
  }
}

class ShimmerLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double containerWidth = 280;
    double containerHeight = 15;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 7.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 100,
            width: 80,
            color: Colors.grey,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: containerHeight,
                width: containerWidth,
                color: Colors.grey,
              ),
              SizedBox(height: 5),
              Container(
                height: containerHeight,
                width: containerWidth,
                color: Colors.grey,
              ),
              SizedBox(height: 5),
              Container(
                height: containerHeight,
                width: containerWidth * 0.75,
                color: Colors.grey,
              )
            ],
          )
        ],
      ),
    );
  }
}
