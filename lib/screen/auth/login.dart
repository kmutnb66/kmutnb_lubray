import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kmutnb_lubray/environment.dart';
import 'package:kmutnb_lubray/provider/news.dart';
import 'package:kmutnb_lubray/provider/noti.dart';
import 'package:kmutnb_lubray/provider/user.dart';
import 'package:kmutnb_lubray/screen/home.dart';
import 'package:kmutnb_lubray/screen/main_screen.dart';
import 'package:kmutnb_lubray/services/auth.dart';
import 'package:kmutnb_package/model/enviroment.dart';
import 'package:provider/provider.dart';

import 'package:flutter_web_auth/flutter_web_auth.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final callbackUrlScheme = 'com.app.kmutnb';
  var environment = Environment.data;
  AuthService authService = AuthService();

  Future<bool> loginIcit() async {
    String? regis_id = await FirebaseMessaging.instance.getToken();
    final url = Uri.https(environment.apiUrls[ApiName.udom], '/2FA/rlogin.php',
        {'token': '90fe437ae235592a2a1cfe1f9f055ecb', 'regis_id': regis_id});

    final result = await FlutterWebAuth.authenticate(
        url: url.toString(), callbackUrlScheme: callbackUrlScheme);

    final code = Uri.parse(result).queryParameters;
    bool status = await authService.setUser(code['data2']!, code['data1']!);
    return status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/icon/logo.png',
                width: 200,
              ),
              Image.asset(
                'assets/images/bg.jpg',
                width: 200,
              ),
              SizedBox(
                height: 50,
              ),
              InkWell(
                onTap: () async {
                  try {
                    bool status = await loginIcit();
                    if (status) {
                      UserProvider provider =
                          Provider.of(context, listen: false);
                      NotiProvider notiProvider = Provider.of(context, listen: false);
                      await provider.getUser();
                      await notiProvider.getItems(patron_barcode: provider.user!.patronInfo!.barcode!,reflash: true);
                      NewsProvider news = Provider.of(context,listen: false);
                      await news.init();
                      MaterialPageRoute route =
                          MaterialPageRoute(builder: (_) => MainScreen());
                      Navigator.pushAndRemoveUntil(
                          context, route, (route) => false);
                    }
                  } catch (e) {}
                },
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    padding: EdgeInsets.all(15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.orange, width: 1),
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            margin: EdgeInsets.only(right: 5),
                            child: Image.asset(
                              'assets/icon/icit.png',
                              width: 40,
                            )),
                        Text('Sign In With ICIT ACCOUNT'),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
