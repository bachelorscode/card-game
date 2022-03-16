import 'package:game/src/controller/apiController.dart';
import 'package:game/src/controller/httpException.dart';
import 'package:game/src/controller/storageController.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  late ApiController _apiController;
  late StorageController _storageController;

  LoginController() {
    _apiController = Get.find<ApiController>();
    _storageController = Get.find<StorageController>();
  }

  Future<bool> checkAuth() async {
    try {
      String token = await _storageController.getLoggedInUserToken();
      print(token);
      if (token == 'N/A') return false;
      await _apiController.getProfile(token: token);
      return true;
    } on HttpException catch (e) {
      throw HttpException(e.message);
    } catch (e) {
      rethrow;
    }
  }

  loginUser({required String user, required String password}) async {
    try {
      await _apiController.login(username: user, password: password);
    } on HttpException catch (e) {
      throw HttpException(e.message);
    } catch (e) {
      rethrow;
    }
  }
}
