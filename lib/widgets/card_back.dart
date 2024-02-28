import 'dart:math';

import 'package:flutter/material.dart';

class CardBackView extends StatelessWidget {
  final String? cvvNumber;

  CardBackView({this.cvvNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 204,
      margin: EdgeInsets.symmetric(horizontal: 35),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.asset('assets/images/card-back.png'),
      ),
    );
  }
}
