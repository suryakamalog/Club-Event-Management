import 'package:firebase_database/firebase_database.dart';

class UserData {
  String key;
  String name;
  String status;
  String phone;

  UserData(this.name, this.status, this.phone);

  UserData.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        name = snapshot.value["name"],
        status = snapshot.value["status"],
        phone = snapshot.value["phone"];

  toJson() {
    return {"name": name, "status": status, "phone": phone};
  }
}
