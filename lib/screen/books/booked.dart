import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:kmutnb_lubray/provider/book.dart';
import 'package:kmutnb_lubray/provider/user.dart';
import 'package:kmutnb_lubray/screen/home.dart';
import 'package:kmutnb_lubray/widgets/datepicker.dart';
import 'package:kmutnb_lubray/widgets/widget-images.dart';
import 'package:kmutnb_package/model/patronHoldPost.dart';
import 'package:kmutnb_package/translate/translate.dart';
import 'package:provider/provider.dart';

class BookedView extends StatefulWidget {
  BookedView({Key? key}) : super(key: key);

  @override
  State<BookedView> createState() => _BookedViewState();
}

class _BookedViewState extends State<BookedView> {
  int count = 1;
  String start = '';
  String end = '';
  String location = '';

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, BookProvider provider, Widget? child) {
      var item = provider.s_item;
      return Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'จองหนังสือ',
                    style: TextStyle(fontSize: 32),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1)),
                    child: Row(
                      children: [
                        imagesNf(
                            width: 100,
                            height: 120,
                            radius: 2,
                            fit: BoxFit.contain,
                            path: item!.bib!.images!.CoverURL!.length == 1
                                ? item.bib!.images!.CoverURL!.first.cover_url
                                : ''),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ชื่อเรื่อง ${item.bib!.title}',
                              ),
                              Text(
                                  'ผู้แต่ง : ${item.bib!.author != null || item.bib!.author!.isNotEmpty ? item.bib!.author : '-'}'),
                              Text(
                                  'ปี : ${item.bib!.publishYear == null ? '-' : item.bib!.publishYear!.toInt()}'),
                              Text(
                                  'สถานะ : ${(item.bib!.item!.status == null) ? 'E-Book' : item.bib!.item!.status!.display}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          'เลือกสถานที่',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          ' *',
                          style: TextStyle(fontSize: 18, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  for (var item in provider.form!.holdshelf!.locations!)
                    ListTile(
                      title: Text(
                          "${Translate.get(text: item.code!.trim()) != item.code!.trim() ? Translate.get(text: item.code!.trim()) : item.name}"),
                      leading: Radio<String>(
                        value: item.code!,
                        groupValue: location,
                        onChanged: (String? value) {
                          setState(() {
                            location = value!;
                          });
                        },
                      ),
                    ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'วันที่ต้องการยืม',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              datePicker(context, todate: DateTime.now())
                                  .then((value) {
                                if (value != null) {
                                  start = value;
                                  end = '';
                                  setState(() {});
                                }
                              });
                            },
                            icon: Icon(
                              Icons.calendar_today,
                              size: 26,
                            )),
                        Text(start.isEmpty
                            ? 'xx/xx/xxxx '
                            : dateform(DateFormat('yyyy-MM-dd').parse(start))),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (item.bib!.item != null &&
                          item.bib!.item!.status != null &&
                          item.bib!.item!.status!.code == '-')
                        RaisedButton(
                          onPressed: () async {
                            if (location.isEmpty) {
                              EasyLoading.showInfo('กรุณาเลือกสถานที่');
                              return;
                            }
                            EasyLoading.show();
                            UserProvider auth =
                                Provider.of(context, listen: false);
                            bool status = await provider.booking(
                                patron_id: auth.user!.patronInfo!.patron_id!,
                                data: PatronHoldPostModel(
                                    recordNumber:
                                        int.parse(provider.s_item!.bib!.id!),
                                    neededBy: start,
                                    recordType: 'b',
                                    pickupLocation: location));
                            if (status) {
                              MaterialPageRoute route =
                                  MaterialPageRoute(builder: (_) => HomeView());
                              Navigator.pushAndRemoveUntil(
                                  context, route, (route) => false);
                            }
                          },
                          child: Text('ยืนยัน'),
                        ),
                      if (item.bib!.item != null &&
                          item.bib!.item!.status != null &&
                          item.bib!.item!.status!.code == '-')
                        SizedBox(width: 25),
                      RaisedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('ย้อนกลับ'),
                        color: Colors.red,
                        textColor: Colors.white,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
