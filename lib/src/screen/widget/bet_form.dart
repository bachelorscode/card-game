import 'package:flutter/material.dart';
import 'package:game/src/screen/widget/customInput.dart';
import 'package:game/src/utils/constrance.dart';
import 'package:google_fonts/google_fonts.dart';

class BetForm extends StatelessWidget {
  BetForm({
    Key? key,
    required this.onTap,
  }) : super(key: key);
  TextEditingController textEditingController = TextEditingController();
  Function onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1)),
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(bottom: 5, top: 5, right: 21),
                    child: Container(
                      color: Colors.white12,
                      alignment: Alignment.center,
                      child: Text(
                        '2',
                        style: GoogleFonts.firaSans(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: CustomInput(
                    controller: textEditingController,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    textEditingController.text = '100';
                  },
                  child: Text('100'),
                ),
                ElevatedButton(
                  onPressed: () {
                    textEditingController.text = '500';
                  },
                  child: Text('500'),
                ),
                ElevatedButton(
                  onPressed: () {
                    textEditingController.text = '1000';
                  },
                  child: Text('1000'),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    textEditingController.text = '10000';
                  },
                  child: Text('10000'),
                ),
                ElevatedButton(
                  onPressed: () {
                    textEditingController.text = '20000';
                  },
                  child: Text('20000'),
                ),
                ElevatedButton(
                  onPressed: () {
                    textEditingController.text = '50000';
                  },
                  child: Text('50000'),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5, top: 5),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(2)),
                      alignment: Alignment.center,
                      child: Text('CANCEL'),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5, top: 5),
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(2)),
                        alignment: Alignment.center,
                        child: Text('PLACE BET'),
                      ),
                      onTap: () {
                        onTap(textEditingController.text);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
