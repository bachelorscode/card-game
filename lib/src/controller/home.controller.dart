import 'dart:convert';

import 'package:game/src/controller/apiController.dart';
import 'package:game/src/controller/httpException.dart';
import 'package:game/src/controller/rtc_controller.dart';
import 'package:game/src/controller/storageController.dart';
import 'package:game/src/models/user.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  late StorageController _storageController;
  late ApiController _apiController;
  late RTCController _rtcController;
  RxBool suspended = true.obs;
  RxString cardUrl = 'LOADING'.obs;

  HomeController() {
    _storageController = Get.find<StorageController>();
    _apiController = Get.find<ApiController>();
    _rtcController = Get.find<RTCController>();
  }
  setSuspended({required bool value}) {
    cardUrl.value = 'BIDDING';
    suspended.value = value;
  }

  Future<bool> checkAuth({required Function callback}) async {
    try {
      String token = await _storageController.getLoggedInUserToken();
      if (token == 'N/A') return false;
      User user = await _apiController.getProfile(token: token);
      callback(_rtcController, token, user.id);
      return true;
    } on HttpException catch (e) {
      throw HttpException(e.message);
    } catch (e) {
      rethrow;
    }
  }

  bidToGame({
    required String gameCode,
    required String gameSide,
    required String amount,
  }) async {
    try {
      await _apiController.betting(
        game_type: gameCode,
        amount: amount,
        side: gameSide,
      );
    } on HttpException catch (e) {
      throw HttpException(e.message);
    } catch (e) {
      rethrow;
    }
  }

  suspendOnDisconnectServer({required Function registerEvent}) {
    _rtcController.createEvent(
      eventName: 'disconnect',
      callback: (data) {
        suspended.value = true;
        _rtcController.closeConnection();
        registerEvent(
          _rtcController,
          _storageController.token.value,
          _storageController.user.value.id,
        );
      },
    );
  }

  reciveAmountUpdate({required String id}) {
    _rtcController.createEvent(
      eventName: 'AMOUNT_UPDATED' + id.toString(),
      callback: (data) {
        User user = User.fromJson(json.decode(data));
        if (user.id == _storageController.user.value.id) {
          _storageController.changeUserData(user: user);
        }
      },
    );
  }

  recieveWinnerEvent() {
    _rtcController.createEvent(
      eventName: 'WINNER_ID',
      callback: (data) {
        // print(data);
        cardUrl.value = data;
        _apiController.getProfile(token: _storageController.token.value);
      },
    );
  }

  changeCardUrlValue({required String value}) {
    cardUrl.value = value;
  }

  logout() async {
    try {
      await _apiController.logout();
    } on HttpException catch (e) {
      throw HttpException(e.message);
    } catch (e) {
      rethrow;
    }
  }
}
