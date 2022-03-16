import 'package:game/src/controller/apiController.dart';
import 'package:game/src/controller/httpException.dart';
import 'package:game/src/controller/storageController.dart';
import 'package:get/get.dart';

class SignUPController extends GetxController {
  late ApiController _apiController;
  late StorageController _storageController;
  SignUPController() {
    _apiController = Get.find<ApiController>();
    _storageController = Get.find<StorageController>();
  }

  RxBool isLoading = false.obs;
  RxBool showPassword = false.obs;

  Future<bool> checkAuth() async {
    try {
      String token = await _storageController.getLoggedInUserToken();
      if (token == 'N/A') return false;
      await _apiController.getProfile(token: token);
      return true;
    } on HttpException catch (e) {
      throw HttpException(e.message);
    } catch (e) {
      rethrow;
    }
  }

  register({
    required String username,
    required String password,
    required String number,
  }) async {
    isLoading.value = true;
    try {
      await _apiController.register(
        username: username,
        password: password,
        number: number,
      );
      isLoading.value = false;
    } on HttpException catch (e) {
      isLoading.value = false;
      throw HttpException(e.message);
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  changePassword() {
    showPassword.value = !showPassword.value;
  }
}
