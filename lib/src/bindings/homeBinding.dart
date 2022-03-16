import 'package:game/src/controller/home.controller.dart';
import 'package:game/src/controller/rtc_controller.dart';
import 'package:get/get.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(RTCController());
    Get.put(HomeController());
  }
}
