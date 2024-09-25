import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kmutnb_lubray/provider/room.dart';
import 'package:kmutnb_lubray/provider/tab_booking.dart';
import 'package:kmutnb_lubray/provider/user.dart';
import 'package:kmutnb_lubray/screen/holds/my_holds.dart';
import 'package:kmutnb_lubray/screen/rooms/my_booking.dart';
import 'package:provider/provider.dart';

class MensuView extends StatelessWidget {
  const MensuView();

  Widget button(
    String path,
    String name,
    GestureTapCallback? onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(
            'assets/icon/$path.png',
            width: 75,
          ),
          Text(
            name,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    openBookDetail({int tab = 1}) async {
      await TabBookingProvider.init(context: context, tab: tab);
      MaterialPageRoute route = MaterialPageRoute(
          builder: (_) => MyHoldsView(
                tab: tab,
              ));
      Navigator.push(context, route);
    }

    return Consumer(builder: (context, UserProvider provider, Widget? child) {
      var item = provider.user;
      return Scaffold(
          appBar: AppBar(
            title: Text('รายการยืม/จอง',style: TextStyle(color: Colors.white),),
          ),
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 25, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'รายการหนังสือ',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Image.asset(
                          'assets/icon/t.png',
                          width: 94,
                        ),
                      ],
                    ),
                    InkWell(
                        onTap: () => openBookDetail(tab: 1),
                        child: Text(
                          'ดูทั้งหมด >',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
              Wrap(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                alignment: WrapAlignment.center,
                spacing: 14,
                children: [
                  button('booking', 'ที่ต้องไปรับ/จองแล้ว',
                      () => openBookDetail(tab: 0)),
                  button(
                      'hold', 'รับแล้ว/ยืมอยู่', () => openBookDetail(tab: 1)),
                  button(
                      'sucess', 'คืนแล้ว/สำเร็จ', () => openBookDetail(tab: 2)),
                  button(
                      'over', 'เกินกำหนดการคืน', () => openBookDetail(tab: 3)),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Divider(
                thickness: 10,
              ),
              InkWell(
                onTap: () async {
                  EasyLoading.show();
                  RoomProvider provider = Provider.of(context, listen: false);
                  await provider.roomBooking(username: item!.patron!.UserName!);
                  MaterialPageRoute route =
                      MaterialPageRoute(builder: (_) => RoomBookingView());
                  Navigator.push(context, route);
                  EasyLoading.dismiss();
                },
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(20.0),
                  color: Color.fromRGBO(245, 245, 245, 1),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/icon/room.png',
                        width: 40,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        'รายการจองห้องติว',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ));
    });
  }
}
