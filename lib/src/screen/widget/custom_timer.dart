import 'dart:async';

import 'package:flutter/material.dart';
import 'package:circular_countdown/circular_countdown.dart';
import 'package:game/src/utils/constrance.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTimer extends StatefulWidget {
  const CustomTimer({Key? key}) : super(key: key);

  @override
  _CustomTimerState createState() => _CustomTimerState();
}

class _CustomTimerState extends State<CustomTimer> {
  int _time = 30;
  late Timer _timer;
  bool showTimer = false;
  void startTimer() {
    _time = 30;
    setState(() {
      showTimer = true;
    });
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      if (_time == 0) {
        setState(() {
          showTimer = false;
          _timer.cancel();
        });
      } else {
        setState(() {
          _time--;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: CircularCountdown(
        countdownTotalColor: bgColor,
        countdownRemainingColor: primaryColor,
        textStyle: GoogleFonts.firaSans(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
        strokeWidth: 10,
        diameter: 50,
        countdownTotal: 30,
        countdownRemaining: _time,
        isClockwise: true,
      ),
    );
  }
}
