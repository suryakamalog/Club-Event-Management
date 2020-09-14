import 'package:firebase_database/firebase_database.dart';
import 'eventPost.dart';

final databaseReference = FirebaseDatabase.instance.reference();

DatabaseReference savePost(EventPost post) {
  var id = databaseReference.child('eventPosts/').push();
  id.set(post.toJson());
  return id;
}

void updatePost(EventPost post, DatabaseReference id) {
  id.update(post.toJson());
}

Future<List<EventPost>> getAllPosts() async {
  DataSnapshot dataSnapshot =
      await databaseReference.child('eventPosts/').once();
  List<EventPost> posts = [];
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      EventPost post = createPost(value);
      post.setId(databaseReference.child('eventPosts/' + key));
      posts.add(post);
    });
  }
  return posts;
}
