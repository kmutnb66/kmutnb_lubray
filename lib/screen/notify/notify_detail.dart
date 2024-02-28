import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:kmutnb_lubray/provider/noti.dart';
import 'package:kmutnb_lubray/provider/user.dart';
import 'package:kmutnb_package/model/noti.dart';
import 'package:provider/provider.dart';

class NotifyDetailView extends StatelessWidget {
  const NotifyDetailView();

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, NotiProvider provider, Widget? child) {
      NotiModel? item = provider.item;
      return Scaffold(
          body: SafeArea(
              child: Container(
                  alignment: Alignment.topCenter,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Center(
                            child: Text(
                              'แจ้งเตือน',
                              style: TextStyle(fontSize: 28),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal:20),
                          child: Divider(
                            height: 0,
                            thickness: 2,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Expanded(
                            child: SingleChildScrollView(
                                child: Column(children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                 ),
                              child: Text("${item!.Mesg}"),
                              ),
                        ])))
                      ]))));
    });
  }
}
