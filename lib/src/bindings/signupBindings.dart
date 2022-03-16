import 'package:game/src/controller/signupController.dart';
import 'package:get/get.dart';

class SignupBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(SignUPController());
  }
}
