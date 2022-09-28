import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:game/src/controller/home.controller.dart';
import 'package:game/src/controller/httpException.dart';
import 'package:game/src/controller/rtc_controller.dart';
import 'package:game/src/controller/storageController.dart';
import 'package:game/src/screen/widget/custom_timer.dart';
import 'package:game/src/screen/widget/drawer.dart';
import 'package:game/src/screen/widget/gameItem.dart';
import 'package:game/src/utils/constrance.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Future<void> _refresh() async {}
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAuth();
  }

  registerEvent(RTCController rtcController, String token, String id) {
    HomeController homeController = Get.find<HomeController>();
    rtcController.connect(token: token);
    rtcController.suspendGame(calllback: (data) {
      homeController.setSuspended(value: true);
    });
    rtcController.unsuspendGame(callback: (data) {
      homeController.setSuspended(value: false);
    });
    homeController.suspendOnDisconnectServer(registerEvent: registerEvent);
    homeController.reciveAmountUpdate(id: id);
    homeController.recieveWinnerEvent();
  }

  checkAuth() async {
    setState(() {
      isLoading = true;
    });
    HomeController loginController = Get.find<HomeController>();
    try {
      bool isLoggedIn =
          await loginController.checkAuth(callback: registerEvent);
      setState(() {
        isLoading = false;
      });
      if (!isLoggedIn) Get.offAndToNamed('/login');
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
                  child: Text('Logout'),
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
                  child: Text('Logout'),
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

  logout() async {
    HomeController homeController = Get.find<HomeController>();
    try {
      await homeController.logout();
      Get.offAllNamed('/login');
    } on HttpException catch (e) {
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    StorageController storage = Get.find<StorageController>();

    return isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: secondaryColor,
                leading: IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: FaIcon(FontAwesomeIcons.gamepad),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: bgColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.wallet,
                              size: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Obx(() {
                                return Text(
                                  storage.user.value.inBetting.toString() == '0'
                                      ? '0'
                                      : storage.user.value.inBetting.toString(),
                                  style: GoogleFonts.firaSans(),
                                );
                              }),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.pink,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.moneyBill,
                              size: 15,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Obx(() {
                                return Text(
                                  storage.user.value.amount.toString() == '0'
                                      ? '0'
                                      : storage.user.value.amount.toString(),
                                  style: GoogleFonts.firaSans(),
                                );
                              }),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      logout();
                    },
                    icon: const Icon(Icons.logout),
                  )
                ],
              ),
              body: RefreshIndicator(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 200,
                          width: double.infinity,
                          color: secondaryColor,
                          child: GetX<HomeController>(builder: (home) {
                            return home.cardUrl.value == 'LOADING'
                                ? const Center(
                                    child: Text('Loading game'),
                                  )
                                : home.cardUrl.value == 'BIDDING'
                                    ? Stack(
                                        children: [
                                          const Center(
                                            child: Text('PLACE BET'),
                                          ),
                                          Container(
                                            alignment: Alignment.bottomRight,
                                            child: CustomTimer(),
                                          )
                                        ],
                                      )
                                    : SvgPicture.asset(
                                        "assets/" + home.cardUrl.value);
                          }),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: GameItem(
                            id: 'HIGH_LOW',
                            code: 'HIGH/LOW',
                            investedA: '0.0',
                            investedB: '0.0',
                            sideA: 'HIGH',
                            sideB: 'LOW',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: GameItem(
                            id: 'RED_BLACK',
                            code: 'RED/BLACK',
                            investedA: '0.0',
                            investedB: '0.0',
                            sideA: 'RED',
                            sideB: 'BLACK',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: GameItem(
                            id: 'ODD_EVEN',
                            code: 'ODD/EVEN',
                            investedA: '0.0',
                            investedB: '0.0',
                            sideA: 'ODD',
                            sideB: 'EVEN',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                onRefresh: _refresh,
              ),
              drawer: const CustomDrawer(),
            ),
          );
  }
}
