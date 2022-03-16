import 'package:game/src/models/user.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageController extends GetxController {
  RxString token = ''.obs;
  Rx user = Object().obs;

  setLoggedInUser({required String token, required User user}) async {
    print(token);
    print(user.id);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('token', token);
    this.token.value = token;
    this.user.value = user;
  }

  Future<String> getLoggedInUserToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    print(token == null);
    if (token == null || token.isEmpty) {
      return 'N/A';
    } else {
      this.token.value = token;
      return token;
    }
  }

  removeToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('token');
  }

  changeUserData({required User user}) {
    this.user.value = user;
  }
}
