import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kmutnb_lubray/environment.dart';
import 'package:kmutnb_lubray/firebase/firebase-message.dart';
import 'package:kmutnb_lubray/provider/news.dart';
import 'package:kmutnb_lubray/provider/noti.dart';
import 'package:kmutnb_lubray/provider/user.dart';
import 'package:kmutnb_lubray/screen/auth/login.dart';
import 'package:kmutnb_lubray/screen/main_screen.dart';
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
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorColor = Colors.red
      ..backgroundColor = Color.fromRGBO(255, 255, 255, 0)
      ..maskType = EasyLoadingMaskType.custom
      ..maskColor = Colors.white.withOpacity(.8)
      ..boxShadow = []
      ..textColor = Colors.black
      ..indicatorWidget = Image.asset('assets/images/loadding2.gif')
      ..textPadding = EdgeInsets.zero;
    Future.delayed(Duration.zero, () {
      message.setNotiLocalInstance();
      message.onmessage(context);
      checkuser();
    });
  }

  checkuser() async {
    UserProvider provider = Provider.of(context, listen: false);
    try {
      await provider.getUser(loading: true);
      if (provider.user != null) {
        NewsProvider news = Provider.of(context, listen: false);
        NotiProvider notiProvider = Provider.of(context, listen: false);
        await news.init();
        await notiProvider.getItems(patron_barcode: provider.user!.patronInfo!.barcode!,reflash: true);
        MaterialPageRoute route =
            MaterialPageRoute(builder: (_) => MainScreen());
        Navigator.pushAndRemoveUntil(context, route, (route) => false);
      } else {
        MaterialPageRoute route = MaterialPageRoute(builder: (_) => Login());
        Navigator.pushAndRemoveUntil(context, route, (route) => false);
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [],
        )));
  }
}
