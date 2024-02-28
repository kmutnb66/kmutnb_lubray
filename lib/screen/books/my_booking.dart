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
                Center(
                  child: Text(
                    'รายการจองหนังสือ',
                    style: TextStyle(fontSize: 28),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Divider(
                  height: 0,
                  thickness: 2,
                  color: Colors.black,
                ),
                SizedBox(
                  height: 12,
                ),
                if (item == null)
                  Center(
                    child: Column(
                      children: [Icon(Icons.list_alt), Text("ไม่พบการจอง")],
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
                                    path: item.item_book!.images!.CoverURL!
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
                                      text(
                                          head: 'ไอดีจอง',
                                          txt: '${item.id!.split('/').last}'),
                                      text(
                                          head: 'ชื่อเรื่อง',
                                          txt: '${item.item_book!.title}'),
                                      text(
                                          head: 'สถานที่รับหนังสือ',
                                          txt: '${item.pickupLocation!.name!}'),
                                      text(
                                          head: 'สถานะ',
                                          txt: '${item.status!.name!}'),
                                                 RaisedButton(
                                    child: Text('ยกเลิกการจอง',style: TextStyle(color: Colors.white),),
                                    color: Colors.red,
                                    onPressed: () {
                                      UserProvider auth = Provider.of(context,listen: false);
                                      showDialog(context: context, builder: (_){
                                        return AlertDialog(
                                          content: Container(child: Text('ต้องการยกเลิกการจอง\n${item.id!.split('/').last}?'),),
                                          actions: [
                                            TextButton(onPressed: ()=>Navigator.pop(context), child: Text('ยกเลิก')),
                                            TextButton(onPressed: ()async{
                                              EasyLoading.show();
                                              Navigator.pop(context);
                                              UserProvider auth = Provider.of(context,listen: false);
                                              await provider.cancel(holdId: '${item.id!.split('/').last}');
                                              await provider.getItemMybooking(patron_id: auth.user!.patronInfo!.patron_id!);
                                            }, child: Text('ตกลง',style: TextStyle(color: Colors.red),))
                                          ],
                                        );
                                      });
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
