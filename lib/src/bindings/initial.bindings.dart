import 'package:game/src/controller/apiController.dart';
import 'package:game/src/controller/home.controller.dart';
import 'package:game/src/controller/storageController.dart';
import 'package:get/get.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies

    print('Binding initial controller');
    Get.put(StorageController());
    Get.put(ApiController());
  }
}
