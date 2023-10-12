import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kmutnb_lubray/environment.dart';
import 'package:kmutnb_lubray/provider/ebok.dart';
import 'package:kmutnb_lubray/provider/hold.dart';
import 'package:kmutnb_lubray/provider/news.dart';
import 'package:kmutnb_lubray/provider/room.dart';
import 'package:kmutnb_lubray/provider/user.dart';
import 'package:kmutnb_lubray/screen/auth/account.dart';
import 'package:kmutnb_lubray/screen/books/books.dart';
import 'package:kmutnb_lubray/screen/holds/scan.dart';
import 'package:kmutnb_lubray/screen/holds/my_holds.dart';
import 'package:kmutnb_lubray/screen/news/news.dart';
import 'package:kmutnb_lubray/screen/rooms/my_booking.dart';
import 'package:kmutnb_lubray/screen/rooms/rooms.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'documents/documents.dart';

class HomeView extends StatefulWidget {
  bool myHolds;
  HomeView({this.myHolds = false});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 10), () {
      if (widget.myHolds) {
        MaterialPageRoute route =
            MaterialPageRoute(builder: (_) => MyHoldsView());
        Navigator.push(context, route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget btn({String? text, GestureTapCallback? onTap}) {
      return InkWell(
        onTap: onTap,
        child: Container(
            width: double.infinity,
            height: 80,
            padding: EdgeInsets.all(15),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.orange, width: 1),
                borderRadius: BorderRadius.circular(12)),
            child: Text(
              text!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            )),
      );
    }

    Widget btnIcon({String? text, IconData? icon, GestureTapCallback? onTap}) {
      return InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12)),
                child: Icon(icon)),
            Text(
              text!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            )
          ],
        ),
      );
    }

    modal({required String title, required List<Widget> content}) {
      return showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                  )),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 23),
              backgroundColor: Color.fromRGBO(0, 0, 0, 0),
              elevation: 0,
              content: SingleChildScrollView(
                child: Container(
                  height: 200,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: Wrap(
                    runSpacing: 15,
                    spacing: 15,
                    children: content,
                  ),
                ),
              ),
              contentPadding: EdgeInsets.all(0),
            );
          });
    }

    return Consumer(builder: (_, UserProvider provider, Widget? child) {
      var item = provider.user;
      return item == null
          ? Scaffold()
          : Scaffold(
              appBar: AppBar(
                title: InkWell(
                  onTap: () {
                    MaterialPageRoute route =
                        MaterialPageRoute(builder: (_) => AccountView());
                    Navigator.push(context, route);
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          image: DecorationImage(
                            image: FileImage(item.image!),
                            fit: BoxFit.cover,
                            onError: (exception, stackTrace) => Container(),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.patron!.DisplayName!,
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'กดเพื่อดูข้อมูล',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.notifications),
                    color: Colors.orange,
                  ),
                ],
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/icon/logo.png',
                        width: 200,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: btn(
                                text: 'หนังสือ\nยืม/จอง',
                                onTap: () => modal(title: 'หนังสือ', content: [
                                      btnIcon(
                                          text: 'จองหนังสือ',
                                          icon: Icons.search,
                                          onTap: () {
                                            MaterialPageRoute route =
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        BooksView());
                                            Navigator.push(context, route);
                                          }),
                                      btnIcon(
                                          text: 'ยืมหนังสือ',
                                          icon: Icons.qr_code_scanner,
                                          onTap: () {
                                            MaterialPageRoute route =
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        ScanBooking());
                                            Navigator.push(context, route);
                                          })
                                    ])),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            flex: 1,
                            child: btn(
                                text: 'รายการ\nยืม/จอง',
                                onTap: () => modal(title: 'รายการ', content: [
                                      btnIcon(
                                          text: "ยืมหนังสือ",
                                          icon: Icons.book_online_sharp,
                                          onTap: () async {
                                            HoldProvider provider = Provider.of(
                                                context,
                                                listen: false);
                                            await provider.getCheckOut(item
                                                .patronInfo!.patron_record_id);
                                            MaterialPageRoute route =
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        MyHoldsView());
                                            Navigator.push(context, route);
                                          }),
                                      btnIcon(
                                          text: "จองหนังสือ",
                                          icon: Icons.menu_book_outlined,
                                          onTap: () async {}),
                                      btnIcon(
                                          text: "จองห้องติว",
                                          icon: Icons.bookmark,
                                          onTap: () async {
                                            EasyLoading.show();
                                            RoomProvider provider = Provider.of(
                                                context,
                                                listen: false);
                                            await provider.roomBooking(
                                                username:
                                                    item.patron!.UserName!);
                                            MaterialPageRoute route =
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        RoomBookingView());
                                            Navigator.push(context, route);
                                            EasyLoading.dismiss();
                                          })
                                    ])),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      btn(
                          text: 'Smart Room',
                          onTap: () async {
                            EasyLoading.show();
                            RoomProvider provider =
                                Provider.of(context, listen: false);
                            await provider.getItems(
                                username: item.patron!.UserName!);
                            MaterialPageRoute route =
                                MaterialPageRoute(builder: (_) => RoomsView());
                            Navigator.push(context, route);
                            EasyLoading.dismiss();
                          }),
                      SizedBox(
                        height: 12,
                      ),
                      btn(
                          text: 'ข่าวสาร',
                          onTap: () async {
                            EasyLoading.show();
                            NewsProvider provider =
                                Provider.of(context, listen: false);
                            await provider.init();
                            MaterialPageRoute route =
                                MaterialPageRoute(builder: (_) => NewsView());
                            Navigator.push(context, route);
                            EasyLoading.dismiss();
                          }),
                      SizedBox(
                        height: 12,
                      ),
                      btn(
                          text: 'Electronic Documents',
                          onTap: () async {
                            EasyLoading.show();
                            EBookProvider provider =
                                Provider.of(context, listen: false);
                            await provider.getItems(reflash: true);
                            MaterialPageRoute route = MaterialPageRoute(
                                builder: (_) => DocumentsView());
                            Navigator.push(context, route);
                            EasyLoading.dismiss();
                          }),
                      SizedBox(
                        height: 12,
                      ),
                      btn(
                          text: 'Update Latest.',
                          onTap: () async {
                            try {
                              await launch(
                                  Uri.parse(Environment.data.url!).toString());
                            } catch (err) {
                              EasyLoading.showInfo("อัพเดทไม่ได้");
                            }
                          })
                    ],
                  ),
                ),
              ));
    });
  }
}
