import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:kmutnb_lubray/environment.dart';
import 'package:kmutnb_lubray/provider/book.dart';
import 'package:kmutnb_lubray/provider/ebok.dart';
import 'package:kmutnb_lubray/provider/hold.dart';
import 'package:kmutnb_lubray/provider/itemList.dart';
import 'package:kmutnb_lubray/provider/news.dart';
import 'package:kmutnb_lubray/provider/noti.dart';
import 'package:kmutnb_lubray/provider/room.dart';
import 'package:kmutnb_lubray/provider/user.dart';
import 'package:kmutnb_lubray/screen/splashscreen.dart';
import 'package:provider/provider.dart';

FirebaseMessaging _messaging = FirebaseMessaging.instance;

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() async{
  Intl.defaultLocale = "th";
  initializeDateFormatting();
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  NotificationSettings settings = await _messaging.requestPermission(
    alert: true,
    badge: true,
    provisional: false,
    sound: true,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            return UserProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return HoldProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return ItemListProvider();
          },
        ),ChangeNotifierProvider(
          create: (context) {
            return RoomProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return BookProvider();
          },
        ), ChangeNotifierProvider(
          create: (context) {
            return NewsProvider();
          },
        ), ChangeNotifierProvider(
          create: (context) {
            return EBookProvider();
          },
        ), ChangeNotifierProvider(
          create: (context) {
            return NotiProvider();
          },
        )
      ],
      child: MaterialApp(
        title: Environment.data.appName,
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          textTheme: TextTheme(

          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primarySwatch: Colors.orange,
        ),
        home: Splashscreen(),
        builder: EasyLoading.init(),
      ),
    );
  }
}

