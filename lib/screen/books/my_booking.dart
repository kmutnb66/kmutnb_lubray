import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:kmutnb_lubray/provider/book.dart';
import 'package:kmutnb_lubray/provider/room.dart';
import 'package:kmutnb_lubray/provider/user.dart';
import 'package:kmutnb_lubray/widgets/widget-images.dart';
import 'package:kmutnb_package/model/my_holds.dart';
import 'package:kmutnb_package/model/room_booking.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingView extends StatelessWidget {
  BookingView();

  @override
  Widget build(BuildContext context) {
    Widget text({required String head, required String txt}) {
      return RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: <TextSpan>[
            TextSpan(
                text: '$head:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: ' $txt'),
          ],
        ),
      );
    }

    return Consumer(
        builder: (BuildContext context, BookProvider provider, Widget? child) {
      MyHoldsModel? item = provider.my_item;
      return Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item == null)
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/icon/booking.png',
                          width: 200,
                        ),
                        Text("ไม่พบการจอง")
                      ],
                    ),
                  ),
                if (item != null)
                  Expanded(
                      child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (var item in item.entries!)
                          Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Colors.grey.shade300, width: 1)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                imagesNf(
                                    width: 100,
                                    height: 120,
                                    fit: BoxFit.contain,
                                    radius: 5,
                                    iconImageEmpty: 'book-empty.png',
                                    path: item.item_book != null &&
                                            item.item_book!.images!.CoverURL!
                                                    .length >
                                                0
                                        ? item.item_book!.images!.CoverURL!
                                            .first.cover_url!
                                        : ''),
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // text(
                                      //     head: 'ไอดีจอง',
                                      //     txt: '${item.id!.split('/').last}'),
                                      text(
                                          head: 'ชื่อเรื่อง',
                                          txt:
                                              '${item.item_book != null ? item.item_book!.title : '-'}'),
                                      text(
                                          head: 'สถานที่รับหนังสือ',
                                          txt: '${item.pickupLocation!.name != null ? item.pickupLocation!.name : '-'}'),
                                      text(
                                          head: 'สถานะ',
                                          txt:
                                              '${item.status != null ? item.status!.name : 'จองอยู่'}'),
                                      RaisedButton(
                                          child: Text(
                                            'ยกเลิกการจอง',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          color: Colors.red,
                                          onPressed: () async {
                                            UserProvider auth = Provider.of(
                                                context,
                                                listen: false);
                                            try {
                                              await launch(Uri.parse('https://injan.kmutnb.ac.th/patroninfo').replace(queryParameters: {'name':auth.user!.patron!.DisplayName,'code':auth.user!.patronInfo!.barcode}).toString());
                                            } catch (err) {
                                              EasyLoading.showInfo(
                                                  "เกิดข้้อผิดพลาด");
                                            }
                                          })
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                      ],
                    ),
                  ))
              ],
            ),
          ),
        ),
      );
    });
  }
}
