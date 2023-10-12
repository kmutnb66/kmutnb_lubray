import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:kmutnb_lubray/provider/book.dart';
import 'package:kmutnb_lubray/widgets/datepicker.dart';
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

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, BookProvider provider,Widget? child) {
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
                      child: ListTile(
                        leading: Icon(
                          Icons.book,
                          size: 50,
                          color: Colors.black,
                        ),
                        title: Text(
                            'หนังสือ ${item!.bib!.title}\nผู้แต่ง : ${item.bib!.author !=null || item.bib!.author!.isNotEmpty ? item.bib!.author : '-'}\nปี : ${item.bib!.publishYear == null ? '-' : item.bib!.publishYear!.toInt()}'),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'วันที่ยืม ',
                          style: TextStyle(fontSize: 22),
                        ),
                        Text(start.isEmpty ? 'xx/xx/xxxx ' : dateform(DateFormat('yyyy-MM-dd').parse(start))),
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
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'จำนวน ',
                          style: TextStyle(fontSize: 22),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                if (count > 1) {
                                  count -= 1;
                                }
                              });
                            },
                            icon: Icon(
                              Icons.remove,
                              size: 26,
                            )),
                        Text('$count'),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                count += 1;
                              });
                            },
                            icon: Icon(
                              Icons.add,
                              size: 26,
                            )),
                        Text(
                          'เล่ม ',
                          style: TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'วันที่คืน ',
                          style: TextStyle(fontSize: 22),
                        ),
                        Text(end.isEmpty ? 'xx/xx/xxxx ' : dateform(DateFormat('yyyy-MM-dd').parse(end))),
                        IconButton(
                            onPressed: () {
                             if(start.isEmpty){
                              EasyLoading.showInfo('กรุณาเลือกวันยืม');
                             }else{
                                 datePicker(context, todate: DateTime.now(),step_: 3,back: false,date: DateTime.parse(start))
                                  .then((value) {
                                if (value != null) {
                                  end = value;
                                  setState(() {});
                                }
                              });
                             }
                           
                            },
                            icon: Icon(
                              Icons.calendar_today,
                              size: 26,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                          onPressed: () {},
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
      }
    );
  }
}
