import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kmutnb_lubray/provider/ebok.dart';
import 'package:kmutnb_lubray/provider/user.dart';
import 'package:kmutnb_lubray/screen/books/booked.dart';
import 'package:kmutnb_lubray/widgets/widget-images.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentsView extends StatefulWidget {
  const DocumentsView({Key? key}) : super(key: key);

  @override
  State<DocumentsView> createState() => _DocumentsViewState();
}

class _DocumentsViewState extends State<DocumentsView> {
  final keyword = TextEditingController();
  List<String> filters = ['Doc.Type', 'Creator', 'Date Create'];
  String filter = 'Doc.Type';
  late ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = new ScrollController()..addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, EBookProvider provider, Widget? child) {
      return Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Text(
                  'Ebook',
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
                        onSubmitted: (value) {
                          provider.getItems(search: value, reflash: true);
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
                      onTap: () {
                        provider.getItems(search: keyword.text, reflash: true);
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
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: controller,
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
                            child: ListTile(
                              onTap: () {},
                              leading: imagesNf(width: 50, height: 100,path: '',iconImageEmpty: 'e-book-empty.png',),
                              title: Text(
                                  '${item.Title}\nAuthor : ${item.Author}\nPublishYear :${item.PublishYear}'),
                              subtitle: Row(
                                children: [
                                  Expanded(
                                    child: TextButton.icon(
                                        onPressed: () async {
                                          try {
                                            await launch(
                                                Uri.parse(item.PathToFile!)
                                                    .toString());
                                          } catch (err) {
                                            EasyLoading.showInfo(
                                                "ไม่สามารถเปิดไฟล์ได้");
                                          }
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.grey)),
                                        icon: Icon(
                                          Icons.remove_red_eye_sharp,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                        label: Text('View',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12
                                            ))),
                                  ),
                                  SizedBox(width: 5,),
                                  Expanded(
                                    child: TextButton.icon(
                                        onPressed: () async {
                                          try {
                                            UserProvider auth = Provider.of(
                                                context,
                                                listen: false);
                                            await launch(Uri.parse(
                                                    'https://lam.lib.kmutnb.ac.th/downloadcheck.php?b=${item.BibNumber}&name=http://library.kmutnb.ac.th/ebook2/${item.BibNumber}.pdf&isbn=&RegisID=${auth.user!.patronInfo!.barcode} ')
                                                .toString());
                                          } catch (err) {
                                            EasyLoading.showInfo(
                                                "ไม่สามารถดาวน์โหลดไฟล์ได้");
                                          }
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.orange)),
                                        icon: Icon(
                                          Icons.download,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                        label: Text('Download',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12
                                            ))),
                                  ),
                                ],
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _scrollListener() async {
    EBookProvider provider = Provider.of(context, listen: false);
    if (controller.position.extentAfter < 2 && !provider.loading) {
      EasyLoading.show();
      await provider.getItems(search: keyword.text, next: true);
      EasyLoading.dismiss();
    }
  }
}
