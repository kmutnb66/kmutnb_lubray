import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:kmutnb_lubray/provider/room.dart';
import 'package:kmutnb_lubray/provider/user.dart';
import 'package:kmutnb_package/model/default.dart';
import 'package:provider/provider.dart';

class RoomsView extends StatefulWidget {
  RoomsView({Key? key}) : super(key: key);

  @override
  State<RoomsView> createState() => _RoomsViewState();
}

class _RoomsViewState extends State<RoomsView> {
  DateTime toDate = DateTime.now();
  List<DateTime> dates = [
    DateTime.now(),
    DateTime.now().add(Duration(days: 1)),
    DateTime.now().add(Duration(days: 2))
  ];
  List<DefaultModel> timeFormatList(Map<String, dynamic>? data) {
    List<DefaultModel> _time = [];
    try {
      data!.forEach((key, value) {
        _time.add(DefaultModel(id: key, value: value));
      });
    } catch (err) {
      return [];
    }
    return _time;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, RoomProvider provider, Widget? child) {
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
                    'Smart Room',
                    style: TextStyle(fontSize: 32),
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
                // step 1 show flor and button
                if (provider.step == 1)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(children: [
                      //  Text('วันที่')
                      for (var date in dates)
                        InkWell(
                          onTap: () async {
                            EasyLoading.show();
                            UserProvider auth =
                                Provider.of(context, listen: false);
                            await provider.getItems(
                                date: date,
                                username: auth.user!.patron!.UserName!);
                            EasyLoading.dismiss();
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 12),
                            alignment: Alignment.center,
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                                color: date.day == provider.s_date.day
                                    ? Colors.orange.shade500
                                    : Colors.white,
                                border: Border.all(
                                  width: 1,
                                  color: date.day == provider.s_date.day
                                      ? Colors.orange.shade500
                                      : Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(12)),
                            child: Text(
                              '${DateFormat('${date.day == toDate.day ? 'วันนี้' : 'E'}\ndd').format(date)}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: date.day == provider.s_date.day
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        )
                    ]),
                  ),
                if (provider.items == null)
                  Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 60),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.room_service_outlined,size: 48,),
                            Text('ไม่พบห้องติว'),
                          ],
                        ),
                      )),
                // step 1 show all room and select time
                if (provider.items != null && provider.step == 1)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (var item in provider.items!)
                            Container(
                              margin: EdgeInsets.only(top: 12),
                              padding: EdgeInsets.all(12),
                              alignment: Alignment.topLeft,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.black),
                                  borderRadius: BorderRadius.circular(19)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Stack(
                                        children: [
                                          Image.asset(
                                            'assets/icon/door.png',
                                            width: 100,
                                          ),
                                          Positioned(
                                              top: 15,
                                              left: 38,
                                              child: Text(item.room_name!))
                                        ],
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Text(
                                          "สถานะห้อง : ${item.full! ? 'เต็ม' : 'ว่าง'}")
                                    ],
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Divider(
                                    thickness: 1,
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Wrap(runSpacing: 12, spacing: 12, children: [
                                    for (var time in timeFormatList(item.time))
                                      InkWell(
                                        onTap: () {
                                          provider.changeStep(
                                              index: 2, item: item, time: time);
                                        },
                                        child: Container(
                                          width: 100,
                                          height: 40,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Text("${time.value}"),
                                        ),
                                      )
                                  ])
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                // step 2 confirm booking room
                if (provider.step == 2)
                  Expanded(
                      child: SingleChildScrollView(
                          child: Column(children: [
                    Container(
                        margin: EdgeInsets.only(top: 12),
                        padding: EdgeInsets.all(12),
                        alignment: Alignment.topLeft,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(19)),
                        child: Column(
                          children: [
                            Center(
                                child: Text(
                              "คุณเลือกจอง",
                              style: TextStyle(fontSize: 24),
                            )),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      right: 12, left: 8, bottom: 10, top: 5),
                                  margin: EdgeInsets.only(right: 12, top: 20),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              width: 2, color: Colors.black))),
                                  child: Text(
                                    'ห้อง',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: 70,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.black),
                                      borderRadius: BorderRadius.circular(19)),
                                  child: Text("${provider.s_item!.room_name}"),
                                ),
                              ],
                            ),
                            Divider(
                              height: 0,
                              thickness: 2,
                              color: Colors.black,
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      right: 12, left: 8, bottom: 10, top: 5),
                                  margin: EdgeInsets.only(right: 12, top: 20),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              width: 2, color: Colors.black))),
                                  child: Text(
                                    'วันที่',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  // width: 70,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.black),
                                      borderRadius: BorderRadius.circular(19)),
                                  child: Text(
                                      '${DateFormat('dd/MM/yyyy').format(provider.s_date)}'),
                                ),
                              ],
                            ),
                            Divider(
                              height: 0,
                              thickness: 2,
                              color: Colors.black,
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      right: 12, left: 8, bottom: 10, top: 5),
                                  margin: EdgeInsets.only(right: 12, top: 20),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              width: 2, color: Colors.black))),
                                  child: Text(
                                    'เวลา',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  // width: 70,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.black),
                                      borderRadius: BorderRadius.circular(19)),
                                  child: Text(provider.s_time!.value!),
                                ),
                              ],
                            ),
                            Divider(
                              height: 0,
                              thickness: 2,
                              color: Colors.black,
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 39,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (modal) {
                                  return AlertDialog(
                                    title: Text("ตรวจสอบรายการ"),
                                    content: Text(
                                        'เลขห้อง: ${provider.s_item!.room_name}\nวันที่: ${DateFormat('dd/MM/yyyy').format(provider.s_date)}\nเวลา: ${provider.s_time!.value}'),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text(
                                            'ยกเลิก',
                                            style: TextStyle(color: Colors.red),
                                          )),
                                      TextButton(
                                          onPressed: () async {
                                            EasyLoading.show();
                                            UserProvider auth = Provider.of(
                                                context,
                                                listen: false);
                                            await provider.booking(
                                                user_id: auth
                                                    .user!.patron!.UserName);
                                            Navigator.pop(modal);
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'ยืนยัน',
                                            style:
                                                TextStyle(color: Colors.green),
                                          ))
                                    ],
                                  );
                                });
                          },
                          child: Text('ยืนยันการจอง'),
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        RaisedButton(
                          onPressed: () {
                            provider.changeStep(index: 1);
                          },
                          child: Text(
                            'ย้อนกลับ',
                          ),
                          color: Colors.red,
                          textColor: Colors.white,
                        ),
                      ],
                    )
                  ]))),
              ],
            ),
          ),
        ),
      );
    });
  }
}
