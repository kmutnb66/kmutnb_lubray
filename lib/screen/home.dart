import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:kmutnb_lubray/provider/news.dart';
import 'package:kmutnb_lubray/provider/noti.dart';
import 'package:kmutnb_lubray/provider/room.dart';
import 'package:kmutnb_lubray/provider/user.dart';
import 'package:kmutnb_lubray/screen/auth/account.dart';
import 'package:kmutnb_lubray/screen/auth/login.dart';
import 'package:kmutnb_lubray/screen/books/books.dart';
import 'package:kmutnb_lubray/screen/holds/scan.dart';
import 'package:kmutnb_lubray/screen/holds/my_holds.dart';
import 'package:kmutnb_lubray/screen/news/news.dart';
import 'package:kmutnb_lubray/screen/notify/notify.dart';
import 'package:kmutnb_lubray/screen/rooms/rooms.dart';
import 'package:kmutnb_lubray/widgets/card_back.dart';
import 'package:kmutnb_lubray/widgets/card_front.dart';
import 'package:kmutnb_lubray/widgets/widget-canvas.dart';
import 'package:kmutnb_package/model/news.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeView extends StatefulWidget {
  bool myHolds;
  HomeView({this.myHolds = false});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  AnimationController? _flipAnimationController;
  Animation<double>? _flipAnimation;
  bool front = true;

  @override
  void initState() {
    super.initState();
    _flipAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 350));
    _flipAnimation =
        Tween<double>(begin: 0, end: 1).animate(_flipAnimationController!)
          ..addListener(() {
            setState(() {});
          });
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
    Widget btnIcon(
        {String? text, required String path, GestureTapCallback? onTap}) {
      return InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            border:
                Border.all(color: Color.fromRGBO(255, 146, 45, 1), width: 2),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Container(
                  width: 36,
                  height: 36,
                  margin: EdgeInsets.only(right: 7),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage(path)))),
              Text(
                text!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              )
            ],
          ),
        ),
      );
    }

    return Consumer(builder: (_, UserProvider provider, Widget? child) {
      var item = provider.user;
      return item == null
          ? Scaffold()
          : Scaffold(
              body: Stack(
              children: [
                Container(
                  width: double.infinity,
                  child: CustomPaint(
                    painter:
                        HeaderCurvedContainer(Color.fromRGBO(255, 146, 45, 1)),
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      AppBar(
                        title: InkWell(
                          onTap: () {
                            MaterialPageRoute route = MaterialPageRoute(
                                builder: (_) => AccountView());
                            Navigator.push(context, route);
                          },
                          child: Row(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: 50.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'assets/icon/logo.png',
                                    ),
                                    alignment: Alignment.center,
                                    scale: 1.4,
                                    onError: (exception, stackTrace) =>
                                        Container(),
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
                                    'สวัสดี',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                  Text(
                                    item.patron!.DisplayName!,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        actions: [
                          Consumer(
                            builder: (_,NotiProvider notiProvider,Widget? child ) {
                              var num_noti = notiProvider.items != null ? notiProvider.items!.where((element) => element.Status =='1').length : 0;
                              return Container(
                                width: 42,
                                margin: EdgeInsets.only(top: 10),
                                child: InkWell(
                                  onTap: () async {
                                    MaterialPageRoute route = MaterialPageRoute(
                                        builder: (_) => NotifyView());
                                    Navigator.push(context, route);
                                  },
                                  child: Stack(
                                    overflow: Overflow.visible,
                                    children: [
                                      Image.asset('assets/icon/chat.png'),
                                      if(num_noti > 0)
                                         Positioned(
                                        top: -8,
                                        right: 0,
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(100)
                                          ),
                                          child: Text('${num_noti > 99 ? '99+' : num_noti}',style: TextStyle(color: Colors.white,fontSize: 9),),
                                        )),
                                    ],
                                  ),
                                ),
                              );
                            }
                          ),
                          Container(
                            width: 35,
                            margin: EdgeInsets.only(right: 8, left: 5),
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return AlertDialog(
                                        title: Text('ต้องการออกจากระบบ?'),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('กลับ')),
                                          TextButton(
                                              onPressed: () {
                                                provider.logout();
                                                MaterialPageRoute route =
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            Login());
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    route,
                                                    (route) => false);
                                              },
                                              child: Text(
                                                'ออกจากระบบ',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              )),
                                        ],
                                      );
                                    });
                              },
                              child: Image.asset('assets/icon/shutdouwn.png'),
                            ),
                          ),
                        ],
                        automaticallyImplyLeading: false,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        child: InkWell(
                          onTap: () {
                            front
                                ? _flipAnimationController!.forward()
                                : _flipAnimationController!.reverse();
                            front = !front;
                            setState(() {});
                          },
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                Transform(
                                  transform: Matrix4.identity()
                                    ..setEntry(3, 2, 0.001)
                                    ..rotateY(math.pi * _flipAnimation!.value),
                                  origin: Offset(
                                      MediaQuery.of(context).size.width / 2, 0),
                                  child: _flipAnimation!.value < 0.5
                                      ? CardFrontView()
                                      : CardBackView(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 18),
                        margin: EdgeInsets.only(top: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            btnIcon(
                                onTap: () {
                                  MaterialPageRoute route = MaterialPageRoute(
                                      builder: (_) => BooksView());
                                  Navigator.push(context, route);
                                },
                                text: 'จอง\nหนังสือ',
                                path: 'assets/icon/book.png'),
                            btnIcon(
                                onTap: () {
                                  MaterialPageRoute route = MaterialPageRoute(
                                      builder: (_) => ScanBooking());
                                  Navigator.push(context, route);
                                },
                                text: 'ยืม\nหนังสือ',
                                path: 'assets/icon/book.png'),
                            btnIcon(
                                onTap: () async {
                                  EasyLoading.show();
                                  RoomProvider provider =
                                      Provider.of(context, listen: false);
                                  await provider.getItems(
                                      username: item.patron!.UserName!);
                                  MaterialPageRoute route = MaterialPageRoute(
                                      builder: (_) => RoomsView());
                                  Navigator.push(context, route);
                                  EasyLoading.dismiss();
                                },
                                text: 'จอง\nห้องติว',
                                path: 'assets/icon/room.png'),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 20, left: 20),
                            padding: EdgeInsets.only(left: 12),
                            decoration: BoxDecoration(
                                border: Border(
                                    left: BorderSide(
                                        width: 6,
                                        color:
                                            Color.fromRGBO(255, 146, 45, 1)))),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'ข่าวสาร',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              EasyLoading.show();
                              NewsProvider provider =
                                  Provider.of(context, listen: false);
                              await provider.init();
                              MaterialPageRoute route =
                                  MaterialPageRoute(builder: (_) => NewsView());
                              Navigator.push(context, route);
                              EasyLoading.dismiss();
                            },
                            child: Container(
                                margin: EdgeInsets.only(top: 20, right: 20),
                                padding: EdgeInsets.only(left: 12),
                                child: Text(
                                  'ดูทั้งหมด',
                                  style: TextStyle(color: Colors.orange),
                                )),
                          ),
                        ],
                      ),
                      Consumer(builder:
                          (_, NewsProvider newsProvider, Widget? child) {
                        List<NewsHotModel>? hotItem = newsProvider.items_newhot;
                        return hotItem == null
                            ? Container()
                            : Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                child: Column(
                                    children:
                                        List.generate(hotItem.length, (index) {
                                  var item = hotItem[index];
                                  return index >= 3
                                      ? Container()
                                      : InkWell(
                                          onTap: () async {
                                            try {
                                              await launch(
                                                  Uri.parse(item.nhot_url!)
                                                      .toString());
                                            } catch (err) {
                                              EasyLoading.showInfo(
                                                  "เกิดข้้อผิดพลาด");
                                            }
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(bottom: 12),
                                            padding: EdgeInsets.all(12),
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1, color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              children: [
                                                item.nhot_img == null
                                                    ? Container()
                                                    : ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                        child: Image.network(
                                                          item.nhot_img!,
                                                          width: 50,
                                                        ),
                                                      ),
                                                SizedBox(
                                                  width: 6,
                                                ),
                                                Text(
                                                  '${item.nhot_title!}\n${DateFormat('dd MMMM yyyy HH:mm น.').format(DateTime.parse(item.nhot_create!))}',
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                })));
                      })
                    ],
                  ),
                ),
              ],
            ));
    });
  }
}
