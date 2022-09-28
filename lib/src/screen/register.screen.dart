// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:game/src/controller/httpException.dart';
import 'package:game/src/controller/signupController.dart';
import 'package:game/src/screen/widget/error.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController number = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    username.dispose();
    password.dispose();
    number.dispose();
  }

  registerUser({required SignUPController register}) async {
    if (username.text.length > 6 &&
        password.text.length >= 6 &&
        number.text.length >= 10) {
      try {
        await register.register(
          username: username.text,
          password: password.text,
          number: number.text,
        );
        Get.offAndToNamed('/home');
      } on HttpException catch (e) {
        Fluttertoast.showToast(
          msg: e.message,
          gravity: ToastGravity.CENTER,
        );
      } catch (e) {
        Fluttertoast.showToast(
          msg: e.toString(),
          gravity: ToastGravity.CENTER,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: 'Please enter valid data',
        gravity: ToastGravity.CENTER,
      );
    }
  }

  checkAuth() async {
    SignUPController loginController = Get.find<SignUPController>();
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
                    checkAuth();
                  },
                  child: Text('Try Again'),
                )
              ],
            );
          });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GetX<SignUPController>(builder: (register) {
      return width < 600
          ? Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'SIGN',
                            style: GoogleFonts.firaSans(
                                fontSize: 25,
                                fontWeight: FontWeight.w400,
                                color: Colors.pink),
                          ),
                          Text(
                            ' UP',
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
                        decoration: InputDecoration(
                          enabled: !register.isLoading.value,
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
                        decoration: InputDecoration(
                          suffix: InkWell(
                            onTap: () {
                              register.changePassword();
                            },
                            child: register.showPassword.isFalse
                                ? const FaIcon(FontAwesomeIcons.eyeSlash,
                                    color: Colors.white)
                                : const FaIcon(
                                    FontAwesomeIcons.eye,
                                    color: Colors.white,
                                  ),
                          ),
                          enabled: !register.isLoading.value,
                          hintText: 'PASSWORD',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: !register.showPassword.value,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 5, left: 10, right: 10),
                      child: TextField(
                        controller: number,
                        decoration: InputDecoration(
                          enabled: !register.isLoading.value,
                          hintText: 'NUMBER',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 5, left: 10, right: 10),
                      child: register.isLoading.isTrue
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.pink,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                registerUser(register: register);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.pink,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Center(
                                    child: Text('SIGNUP'),
                                  ),
                                ),
                              ),
                            ),
                    ),
                    register.isLoading.isFalse
                        ? Padding(
                            padding: const EdgeInsets.only(
                                top: 20, bottom: 5, left: 10, right: 10),
                            child: TextButton(
                              onPressed: () {
                                Get.offAndToNamed('/login');
                              },
                              child: Text(
                                'Already have an account ? Login Here',
                                style: GoogleFonts.firaSans(),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            )
          : width >= 500 && width < 700
              ? ErrorScreen()
              : ErrorScreen();
    });
  }
}
