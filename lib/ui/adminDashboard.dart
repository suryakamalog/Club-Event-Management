import 'package:event/ui/adminPostPage.dart';
import 'package:event/utils/eventPost.dart';
import '../utils/eventDatabase.dart';
import 'package:flutter/material.dart';
import 'postInfoCard.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminDashboard extends StatefulWidget {
  final User user;
  AdminDashboard(this.user);
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
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

  void onClicked() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AdminPostPage(this.newPost)));
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
      floatingActionButton: FloatingActionButton(
        onPressed: this.onClicked,
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
