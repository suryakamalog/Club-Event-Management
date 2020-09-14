import 'package:shared_preferences/shared_preferences.dart';
import 'Constants.dart';

class CommonData {
  static void clearLoggedInUserData() async {
    SharedPreferences removePrefs = await SharedPreferences.getInstance();

    removePrefs.setBool(Constants.isLoggedIn, false);
    removePrefs.setBool(Constants.isLoggedOut, true);

    removePrefs.remove(Constants.loggedInUserMobile);
    removePrefs.remove(Constants.loggedInUserName);
    removePrefs.remove(Constants.loggedInUserRole);
  }
}
