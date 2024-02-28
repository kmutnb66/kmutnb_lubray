import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kmutnb_lubray/provider/book.dart';
import 'package:kmutnb_lubray/provider/hold.dart';
import 'package:kmutnb_lubray/provider/room.dart';
import 'package:kmutnb_lubray/provider/user.dart';
import 'package:kmutnb_lubray/screen/books/my_booking.dart';
import 'package:kmutnb_lubray/screen/holds/my_holds.dart';
import 'package:kmutnb_lubray/screen/rooms/my_booking.dart';
import 'package:provider/provider.dart';

class MensuView extends StatelessWidget {
  const MensuView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'รายการ ยืม/จอง',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Consumer(builder: (context, UserProvider provider, Widget? child) {
        var item = provider.user;
        return ListView(
          children: [
            InkWell(
              onTap: () async {
                HoldProvider provider = Provider.of(context, listen: false);
                await provider.getCheckOut(item!.patronInfo!.patron_record_id);
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (_) => MyHoldsView());
                Navigator.push(context, route);
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icon/book.png',
                      width: 40,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      'ยืมหนังสือ',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 3,
            ),
            InkWell(
              onTap: () async {
                BookProvider provider = Provider.of(context, listen: false);
                await provider.getItemMybooking(patron_id: item!.patronInfo!.patron_id!);
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (_) => BookingView());
                Navigator.push(context, route);
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icon/book.png',
                      width: 40,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      'จองหนังสือ',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 3,
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
              child: Padding(
                padding: const EdgeInsets.all(20.0),
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
                      'จองห้องติว',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
