import 'package:flutter/material.dart';
import 'package:game/src/utils/constrance.dart';

class CustomInput extends StatefulWidget {
  CustomInput({
    Key? key,
    required this.controller,
  }) : super(key: key);
  TextEditingController controller;
  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  int amount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    amount = 0;
    widget.controller.text = amount.toString();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('Disposing controller');
    widget.controller.dispose();
  }

  changeValueOnClick({required bool isMinus}) {
    print(isMinus);
    if (isMinus && amount > 0) {
      amount -= 1;
      widget.controller.text = amount.toString();
    } else if (!isMinus) {
      amount += 1;
      print(amount);
      widget.controller.text = amount.toString();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid operation'),
        ),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 5,
        bottom: 5,
        left: 21,
      ),
      child: Container(
        decoration: const BoxDecoration(color: Colors.white10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                changeValueOnClick(isMinus: true);
              },
              child: Container(
                color: bgColor,
                child: const Icon(
                  Icons.remove,
                  size: 30,
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: TextField(
                  onChanged: (val) {
                    if (val != '') {
                      amount = int.parse(val);
                    } else {
                      widget.controller.text = 0.toString();
                    }
                  },
                  controller: widget.controller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                      bottom: 15,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                changeValueOnClick(isMinus: false);
              },
              child: Container(
                color: bgColor,
                child: const Icon(
                  Icons.add,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
