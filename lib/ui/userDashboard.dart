import 'package:event/ui/userEventRegList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
      body: Column(
        children: <Widget>[
          Expanded(child: PostInfo(this.posts, widget.user)),
        ],
      ),
    );
  }
}
