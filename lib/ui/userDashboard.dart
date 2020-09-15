import '../utils/eventPost.dart';
import '../utils/eventDatabase.dart';
import '../ui/userProfilePage.dart';
import 'package:event/loginPage.dart';
import 'postInfoCard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
  List<EventPost> posts = [];
  String _name;
  String _mobile;
  String _email = _auth.currentUser.email;
  String _year;
  String _branch;

  Future<void> profileClick() async {
    var d = await FirebaseFirestore.instance
        .collection('users')
        .doc(_email)
        .get()
        .then((DocumentSnapshot) async {
      _name = DocumentSnapshot.data()['name'];
      _mobile = DocumentSnapshot.data()['mobile'];
      _email = DocumentSnapshot.data()['email'];
      _year = DocumentSnapshot.data()['year'];
      _branch = DocumentSnapshot.data()['branch'];
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

  @override
  void initState() {
    super.initState();
    updatePosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 80,
              child: DrawerHeader(
                child: Text('Welcome'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
            ),
            ListTile(
              title: Text('Profile'),
              onTap: this.profileClick,
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color(0xff028090),
        title: Text('Dashboard'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: PostInfo(this.posts, widget.user)),
        ],
      ),
    );
  }
}
