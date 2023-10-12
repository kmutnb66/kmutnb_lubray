import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kmutnb_lubray/environment.dart';
import 'package:kmutnb_lubray/firebase/firebase-message.dart';
import 'package:kmutnb_lubray/provider/user.dart';
import 'package:kmutnb_lubray/screen/auth/login.dart';
import 'package:kmutnb_lubray/screen/home.dart';
import 'package:kmutnb_package/model/enviroment.dart';
import 'package:provider/provider.dart';

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  EnvironmentModel environment = Environment.data;
  Message message = Message();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      message.setNotiLocalInstance();
      message.onmessage();
      checkuser();
    });
  }

  checkuser() async {
    UserProvider provider = Provider.of(context, listen: false);
    await provider.getUser(loading: true);
    if (provider.user != null) {
      MaterialPageRoute route = MaterialPageRoute(builder: (_) => HomeView());
      Navigator.pushAndRemoveUntil(context, route, (route) => false);
    } else {
      MaterialPageRoute route = MaterialPageRoute(builder: (_) => Login());
      Navigator.pushAndRemoveUntil(context, route, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/icon/logo.png',
              width: 200,
            )
          ],
        )));
  }
}
