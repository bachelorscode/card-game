import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:game/src/controller/apiController.dart';
import 'package:game/src/controller/httpException.dart';
import 'package:game/src/controller/storageController.dart';
import 'package:get/get.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    changeScreen();
  }

  void changeScreen() async {
    StorageController storageController = Get.find<StorageController>();
    ApiController apiController = Get.find<ApiController>();
    try {
      String isFound = await storageController.getLoggedInUserToken();
      print(isFound);
      if (isFound != 'N/A') {
        await checkAuth(
          apiController: apiController,
          storageController: storageController,
          token: isFound,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Login please',
          gravity: ToastGravity.CENTER,
        );
        Get.offAllNamed('/login');
      }
    } catch (e) {
      Get.offAllNamed('/login');
    }
  }

  checkAuth({
    required ApiController apiController,
    required StorageController storageController,
    required String token,
  }) async {
    try {
      await apiController.getProfile(token: token);
      Get.offAndToNamed('/home');
    } on HttpException catch (e) {
      print(e.message);
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Error !'),
            content: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.error,
                      size: 30,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(e.message),
                  )
                ],
              ),
            ),
            actions: [
              RaisedButton(
                onPressed: () {
                  storageController.removeToken();
                  Get.offAndToNamed('/login');
                },
                child: Text('Logout'),
              ),
              RaisedButton(
                onPressed: () {
                  checkAuth(
                    apiController: apiController,
                    storageController: storageController,
                    token: token,
                  );
                  Navigator.of(context).pop();
                },
                child: Text('Retry'),
              )
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Error !'),
            content: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.error,
                      size: 30,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(e.toString()),
                  )
                ],
              ),
            ),
            actions: [
              RaisedButton(
                onPressed: () {
                  storageController.removeToken();
                  Get.offAndToNamed('/login');
                },
                child: Text('Logout'),
              ),
              RaisedButton(
                onPressed: () {
                  checkAuth(
                    apiController: apiController,
                    token: token,
                    storageController: storageController,
                  );
                  Navigator.of(context).pop();
                },
                child: Text('Retry'),
              )
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
