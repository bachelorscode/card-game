import 'package:flutter/material.dart';
import 'package:game/src/bindings/homeBinding.dart';
import 'package:game/src/bindings/initial.bindings.dart';
import 'package:game/src/bindings/loginBindings.dart';
import 'package:game/src/bindings/signupBindings.dart';
import 'package:game/src/screen/game.screen.dart';
import 'package:game/src/screen/login.screen.dart';
import 'package:game/src/screen/register.screen.dart';
import 'package:game/src/screen/spalsh.dart';
import 'package:game/src/utils/constrance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBindings(),
      title: 'welcome | Game',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme:
            GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).apply(
          bodyColor: Colors.white,
        ),
        canvasColor: secondaryColor,
      ),
      getPages: [
        GetPage(
          name: '/splash',
          page: () => const Splash(),
        ),
        GetPage(
          name: '/home',
          page: () => const GameScreen(),
          binding: HomeBindings(),
        ),
        GetPage(
          name: '/login',
          page: () => LoginScreen(),
          binding: LoginBindings(),
        ),
        GetPage(
          name: '/signup',
          page: () => RegistrationScreen(),
          binding: SignupBindings(),
        ),
      ],
      initialRoute: '/splash',
    );
  }
}
