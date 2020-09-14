import 'package:flutter/material.dart';
import 'postInfoCard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/eventPost.dart';
import '../utils/eventDatabase.dart';

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
