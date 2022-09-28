import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:game/src/controller/home.controller.dart';
import 'package:game/src/controller/httpException.dart';
import 'package:game/src/screen/widget/bet_form.dart';
import 'package:game/src/utils/constrance.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class GameItem extends StatefulWidget {
  GameItem({
    Key? key,
    required this.id,
    required this.code,
    required this.sideA,
    required this.sideB,
    required this.investedA,
    required this.investedB,
  }) : super(key: key);
  String id;
  String code;
  String sideA;
  String investedA;
  String investedB;
  String sideB;

  @override
  State<GameItem> createState() => _GameItemState();
}

class _GameItemState extends State<GameItem> {
  bool isFirstOpen = false;
  bool isSecondOpen = false;

  changeIsFirstopen() {
    setState(() {
      isFirstOpen = !isFirstOpen;
    });
  }

  changeIsSecondopen() {
    setState(() {
      isSecondOpen = !isSecondOpen;
    });
  }

  betting(
      {required HomeController homeController,
      required String gameCode,
      required String gameSide,
      required String amount}) async {
    try {
      await homeController.bidToGame(
          gameCode: gameCode, gameSide: gameSide, amount: amount);
      Fluttertoast.showToast(msg: 'Betting success');
      if (gameSide == widget.sideA) {
        changeIsFirstopen();
      } else {
        changeIsSecondopen();
      }
    } on HttpException catch (e) {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text('error'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.error,
                      size: 30,
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: Text(e.message))
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OKAY'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    betting(
                      homeController: homeController,
                      gameCode: gameCode,
                      gameSide: gameSide,
                      amount: amount,
                    );
                  },
                  child: Text('Re try'),
                )
              ],
            );
          });
    } catch (e) {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text('error'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.error,
                      size: 30,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
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
                  child: Text('OKAY'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    betting(
                      homeController: homeController,
                      gameCode: gameCode,
                      gameSide: gameSide,
                      amount: amount,
                    );
                  },
                  child: Text('Re try'),
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(builder: (home) {
      return Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Column(
              children: [
                Container(
                  height: 25,
                  color: Colors.blue,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(
                    left: 5,
                  ),
                  child: Text(
                    widget.code,
                    style: GoogleFonts.firaSans(),
                  ),
                ),
                SizedBox(
                  height: 60,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 10,
                        child: Column(
                          children: [
                            Container(
                              height: 30,
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.only(top: 5, left: 9),
                                child: Text(
                                  widget.sideA,
                                  style: GoogleFonts.firaSans(),
                                ),
                              ),
                            ),
                            Container(
                              height: 30,
                              alignment: Alignment.topLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Icon(
                                    Icons.arrow_right,
                                    color: Colors.white,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text('00.00'),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          onTap: () {
                            changeIsFirstopen();
                          },
                          child: Container(
                            color: Colors.green,
                            child: Column(
                              children: [
                                Container(
                                  height: 30,
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 5, left: 9),
                                    child: Text(
                                      '2',
                                      style: GoogleFonts.firaSans(),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  alignment: Alignment.topCenter,
                                  child: Text(widget.investedA),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                isFirstOpen && home.suspended.isFalse
                    ? BetForm(
                        onTap: (value) {
                          // print(value);
                          // print(widget.id);
                          // print(widget.sideA);
                          betting(
                            homeController: home,
                            gameCode: widget.id,
                            gameSide: widget.sideA,
                            amount: value,
                          );
                        },
                      )
                    : Container(),
                SizedBox(
                  height: 60,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 10,
                        child: Column(
                          children: [
                            Container(
                              height: 30,
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.only(top: 5, left: 9),
                                child: Text(
                                  widget.sideB,
                                  style: GoogleFonts.firaSans(),
                                ),
                              ),
                            ),
                            Container(
                              height: 30,
                              alignment: Alignment.topLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.arrow_right,
                                    color: Colors.white,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(widget.investedB),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          onTap: () {
                            changeIsSecondopen();
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(8)),
                              color: Colors.green,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 30,
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 5, left: 9),
                                    child: Text(
                                      '2',
                                      style: GoogleFonts.firaSans(),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  alignment: Alignment.topCenter,
                                  child: Text(widget.investedB),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                isSecondOpen && home.suspended.isFalse
                    ? BetForm(
                        onTap: (value) {
                          betting(
                            homeController: home,
                            gameCode: widget.id,
                            gameSide: widget.sideB,
                            amount: value,
                          );
                        },
                      )
                    : Container(),
              ],
            ),
          ),
          home.suspended.isTrue
              ? InkWell(
                  onTap: () {
                    Fluttertoast.showToast(
                      msg: 'Game in running state please wait',
                      gravity: ToastGravity.CENTER,
                    );
                  },
                  child: Container(
                    height: 150,
                    alignment: Alignment.center,
                    child: const Text(
                      'SUSPENDED',
                      style: TextStyle(color: Colors.red, fontSize: 30),
                    ),
                  ),
                )
              : Container(),
        ],
      );
    });
  }
}
