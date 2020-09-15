import 'package:firebase_database/firebase_database.dart';

class UserData {
  String key;
  String name;
  String mobile;
  String email;
  String year;
  String branch;

  UserData(this.name, this.mobile, this.email, this.year, this.branch);

  UserData.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        name = snapshot.value["name"],
        mobile = snapshot.value["mobile"],
        email = snapshot.value["email"],
        year = snapshot.value["year"],
        branch = snapshot.value["branch"];

  toJson() {
    return {
      "name": name,
      "mobile": mobile,
      "email": email,
      "year": year,
      "branch": branch
    };
  }
}
