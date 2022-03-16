import 'dart:convert';

import 'package:game/src/config.dart';
import 'package:game/src/controller/httpException.dart';
import 'package:game/src/controller/storageController.dart';
import 'package:game/src/models/user.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ApiController extends GetxController {
  late StorageController _storageController;
  ApiController() {
    _storageController = Get.find<StorageController>();
  }

  login({required String username, required String password}) async {
    try {
      http.Response response =
          await http.post(Uri.parse(Config.url + '/user/login'), body: {
        "username": username,
        "password": password,
      });
      print(response.body);
      if (response.statusCode != 200) throw HttpException(response.body);

      MainUser mainUser = MainUser.fromJson(json.decode(response.body));
      _storageController.setLoggedInUser(
        token: mainUser.jwtToken,
        user: mainUser.user,
      );
    } catch (e) {
      rethrow;
    }
  }

  register({
    required String username,
    required String password,
    required String number,
  }) async {
    try {
      http.Response response =
          await http.post(Uri.parse(Config.url + '/user/signup'), body: {
        "username": username,
        "password": password,
        "mobile": number,
      });
      if (response.statusCode != 201) throw HttpException(response.body);
      MainUser mainUser = MainUser.fromJson(json.decode(response.body));
      _storageController.setLoggedInUser(
          token: mainUser.jwtToken, user: mainUser.user);
    } catch (e) {
      rethrow;
    }
  }

  Future<User> getProfile({required String token}) async {
    try {
      http.Response response =
          await http.get(Uri.parse(Config.url + '/user/profile'), headers: {
        "authorization": "Bearer " + token,
      });

      if (response.statusCode != 200) throw HttpException(response.body);

      User user = User.fromJson(json.decode(response.body));

      _storageController.setLoggedInUser(
        token: _storageController.token.value,
        user: user,
      );

      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> betting({
    required String game_type,
    required String amount,
    required String side,
  }) async {
    try {
      http.Response response = await http
          .post(Uri.parse(Config.url + '/bet?game_type=$game_type'), body: {
        "amount": amount,
        "side": side,
      }, headers: {
        "authorization": "Bearer " + _storageController.token.value,
      });

      if (response.statusCode != 200) throw HttpException(response.body);

      User user = User.fromJson(json.decode(response.body));

      _storageController.changeUserData(user: user);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> logout() async {
    try {
      http.Response response = await http.post(
        Uri.parse(Config.url + '/user/logout'),
        headers: {"authorization": "Bearer " + _storageController.token.value},
      );
      if (response.statusCode != 200) throw HttpException(response.body);
      await _storageController.removeToken();
      return true;
    } catch (e) {
      rethrow;
    }
  }
}





