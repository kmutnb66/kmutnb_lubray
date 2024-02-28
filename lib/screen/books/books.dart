import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kmutnb_lubray/provider/book.dart';
import 'package:kmutnb_lubray/provider/user.dart';
import 'package:kmutnb_lubray/screen/books/booked.dart';
import 'package:kmutnb_lubray/widgets/widget-images.dart';
import 'package:provider/provider.dart';

class BooksView extends StatelessWidget {
  const BooksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController keyword = TextEditingController();
    return Consumer(
        builder: (BuildContext context, BookProvider provider, Widget? child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(0, 0, 0, 0),
          elevation: 0,
          toolbarHeight: 120,
          automaticallyImplyLeading: false,
          title: Column(
            children: [
              Text(
                'ค้นหาหนังสือ',
                style: TextStyle(fontSize: 32),
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: keyword,
                      autofocus: true,
                      onSubmitted: (value) async {
                        EasyLoading.show();
                        await provider.getItems(search: keyword.text);
                        EasyLoading.dismiss();
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        labelText: 'Keyword',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () async {
                      EasyLoading.show();
                      await provider.getItems(search: keyword.text);
                      EasyLoading.dismiss();
                    },
                    child: Container(
                        child: Icon(
                          Icons.search,
                          size: 30,
                        ),
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(100))),
                  )
                ],
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            alignment: Alignment.topCenter,
            child: provider.items == null || provider.items!.length <= 0
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          provider.items == null
                              ? Icons.search
                              : Icons.hourglass_empty_sharp,
                          color: Colors.orange,
                          size: 120,
                        ),
                        Text(
                          provider.items == null
                              ? 'กดพิมพ์ค้นหาหนังสือที่ต้องการจอง'
                              : 'ไม่พบหนังสือที่ค้นหา',
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 12,
                        ),
                        for (var item in provider.items!)
                          Container(
                            padding: EdgeInsets.all(15),
                            margin: EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1)),
                            child: InkWell(
                              onTap:()async{
                                     UserProvider auth =
                                            Provider.of(context, listen: false);
                                        await provider.selectItem(
                                            patron_id: auth
                                                .user!.patronInfo!.patron_id!,
                                            item: item);
                                        MaterialPageRoute route =
                                            MaterialPageRoute(
                                                builder: (_) => BookedView());
                                        Navigator.push(context, route);
                              },
                              child: Row(
                                children: [
                                  imagesNf(
                                      width: 100,
                                      height: 120,
                                      radius: 2,
                                      fit: BoxFit.contain,
                                      path:
                                          item.bib!.images!.CoverURL!.length ==
                                                  1
                                              ? item.bib!.images!.CoverURL!
                                                  .first.cover_url
                                              : ''),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                    child:  Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
