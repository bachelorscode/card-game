import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:game/src/controller/httpException.dart';
import 'package:game/src/controller/loginController.dart';
import 'package:game/src/screen/widget/error.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAuth();
  }

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  checkAuth() async {
    LoginController loginController = Get.find<LoginController>();
    try {
      bool isLoggedIn = await loginController.checkAuth();
      if (isLoggedIn) Get.offAndToNamed('/home');
    } on HttpException catch (e) {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text('Error !'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Icon(Icons.error, size: 30),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(e.message),
                  )
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('exit'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    checkAuth();
                  },
                  child: Text('Try Again'),
                )
              ],
            );
          });
    } catch (e) {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text('Error !'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Icon(Icons.error, size: 30),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(e.toString()),
                  )
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('exit'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    checkAuth();
                  },
                  child: Text('Try Again'),
                )
              ],
            );
          });
    }
  }

  login({required LoginController loginController}) async {
    try {
      if (username.text.isEmpty && password.text.isEmpty) {
        Fluttertoast.showToast(
            msg: 'Invalid Input', gravity: ToastGravity.CENTER);
      } else {
        await loginController.loginUser(
          user: username.text,
          password: password.text,
        );
        Get.offAndToNamed('/home');
      }
    } on HttpException catch (e) {
      Fluttertoast.showToast(msg: e.message, gravity: ToastGravity.CENTER);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString(), gravity: ToastGravity.CENTER);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    LoginController loginController = Get.find<LoginController>();
    return width < 600
        ? Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'LOG',
                          style: GoogleFonts.firaSans(
                              fontSize: 25,
                              fontWeight: FontWeight.w400,
                              color: Colors.pink),
                        ),
                        Text(
                          ' IN',
                          style: GoogleFonts.firaSans(
                            fontSize: 25,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 5, left: 10, right: 10),
                    child: TextField(
                      controller: username,
                      decoration: const InputDecoration(
                        hintText: 'USERNAME',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 5, left: 10, right: 10),
                    child: TextField(
                      controller: password,
                      decoration: const InputDecoration(
                        hintText: 'PASSWORD',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 5, left: 10, right: 10),
                    child: InkWell(
                      onTap: () {
                        login(loginController: loginController);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.pink,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text('LOGIN'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 5, left: 10, right: 10),
                    child: TextButton(
                      onPressed: () {
                        Get.offAndToNamed('/signup');
                      },
                      child: Text(
                        'Don\'t have account ? Create one',
                        style: GoogleFonts.firaSans(),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        : width >= 500 && width < 700
            ? ErrorScreen()
            : ErrorScreen();
  }
}
