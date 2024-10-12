import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kmutnb_lubray/provider/hold.dart';
import 'package:kmutnb_lubray/provider/user.dart';
import 'package:kmutnb_lubray/screen/home.dart';
import 'package:kmutnb_lubray/screen/main_screen.dart';
import 'package:kmutnb_lubray/widgets/widget-images.dart';
import 'package:provider/provider.dart';

class BookDetailView extends StatelessWidget {
  BookDetailView();

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

    return Consumer(builder: (context, HoldProvider provider, Widget? child) {
      var item = provider.more_item!.more_item_info!.last;
      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'ยืมหนังสือ',
                      style: TextStyle(fontSize: 32),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        imagesNf(
                            width: 100,
                            height: 120,
                            fit: BoxFit.contain,
                            iconImageEmpty: 'book-empty.png',
                            radius: 5,
                            path: item.images!.CoverURL!.length > 0
                                ? item.images!.CoverURL!.first.cover_url!
                                : ''),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              text(head: 'หนังสือ', txt: '${item.title}'),
                              text(
                                  head: 'ปี',
                                  txt:
                                      '${item.publish_year == null ? '-' : item.publish_year!.toInt()}'),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
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
                                      'หนังสือ ${item.title == null ? '-' : item.title}\nปีที่พิมพ์: ${item.publish_year == null ? '-' : item.publish_year!.toInt()}'),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
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
                                          await provider.hold(
                                              barcode: auth
                                                  .user!.patronInfo!.barcode!,
                                              patron_id: auth.user!.patronInfo!
                                                  .patron_record_id);
                                          MaterialPageRoute route =
                                              MaterialPageRoute(
                                                  builder: (_) => MainScreen(
                                                      // myHolds: true,
                                                      ));
                                          Navigator.pushAndRemoveUntil(
                                              context, route, (route) => false);
                                          EasyLoading.dismiss();
                                        },
                                        child: Text(
                                          'ยืนยัน',
                                          style: TextStyle(color: Colors.green),
                                        ))
                                  ],
                                );
                              });
                        },
                        child: Text('ยืนยัน'),
                      ),
                      SizedBox(width: 25),
                      RaisedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('ยกเลิก'),
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
