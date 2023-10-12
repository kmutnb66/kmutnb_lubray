import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kmutnb_lubray/provider/room.dart';
import 'package:kmutnb_package/model/room_booking.dart';
import 'package:provider/provider.dart';

class RoomBookingView extends StatelessWidget {
  RoomBookingView();

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, RoomProvider provider, Widget? child) {
      List<RoomBookingModel>? items = provider.room_booking;
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
                          margin: EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1,color: Colors.black)
                          ),
                          child: ListTile(
                            title: Text("เลขที่ห้อง :${item.room_number}\nวันที่ :${DateFormat('dd MMMM yyyy').format(DateTime.parse(item.date!))}\nเวลา :${item.time}"),
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
