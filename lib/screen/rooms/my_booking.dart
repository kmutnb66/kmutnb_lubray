import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:kmutnb_lubray/model/smartroom.dart';
import 'package:kmutnb_lubray/provider/room.dart';
import 'package:kmutnb_lubray/provider/user.dart';
import 'package:kmutnb_package/model/room_booking.dart';
import 'package:provider/provider.dart';

class RoomBookingView extends StatelessWidget {
  RoomBookingView();

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, RoomProvider provider, Widget? child) {
      List<SmartRoomModel>? items = provider.room_booking;
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
                    'รายการจองห้องติว',
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
                if (items == null)
                  Center(
                    child: Column(
                      children: [Icon(Icons.list_alt), Text("ไม่พบการจอง")],
                    ),
                  ),
                if (items != null)
                  Expanded(
                      child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (var item in items)
                          Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Colors.grey.shade300, width: 1)),
                            child: ListTile(
                              title: Text(
                                  "เลขที่ห้อง :${item.room_name}\nวันที่ :${DateFormat('dd MMMM yyyy').format(DateTime.parse(item.bookroom_date!))}\nเวลา :${item.timecode_name}\nสถานะ :${provider.status[item.status]}"),
                              trailing: item.status != '1' ? null : Wrap(
                                children: [
                                  RaisedButton(
                                    child: Text('ยกเลิกการจอง',style: TextStyle(color: Colors.white),),
                                    color: Colors.red,
                                    onPressed: () {
                                      UserProvider auth = Provider.of(context,listen: false);
                                      showDialog(context: context, builder: (_){
                                        return AlertDialog(
                                          content: Container(child: Text('ต้องการยกเลิกการจอง\n${item.room_name}?'),),
                                          actions: [
                                            TextButton(onPressed: ()=>Navigator.pop(context), child: Text('ยกเลิก')),
                                            TextButton(onPressed: ()async{
                                              EasyLoading.show();
                                              UserProvider auth = Provider.of(context,listen: false);
                                              await provider.cancel(bookroom_id: item.bookroom_id!, username: auth.user!.patron!.UserName!);
                                              await provider.roomBooking(username: auth.user!.patron!.UserName);
                                              EasyLoading.showSuccess('สำเร็จ');
                                              Navigator.pop(context);
                                            }, child: Text('ตกลง',style: TextStyle(color: Colors.red),))
                                          ],
                                        );
                                      });
                                  })
                                ],
                              ),
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
