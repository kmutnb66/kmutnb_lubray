import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:kmutnb_lubray/provider/news.dart';
import 'package:kmutnb_lubray/screen/news/new.dart';
import 'package:kmutnb_lubray/widgets/widget-images.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsView extends StatelessWidget {
  const NewsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, NewsProvider provider, Widget? child) {
      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    margin: EdgeInsets.only(left: 20, top: 12, bottom: 12),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'ข่าวมาแรง',
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    )),
                CarouselSlider.builder(
                    itemCount: provider.items_newhot == null
                        ? 0
                        : provider.items_newhot!.length,
                    itemBuilder: (BuildContext context, int itemIndex,
                        int pageViewIndex) {
                      var item = provider.items_newhot![itemIndex];
                      return InkWell(
                        onTap: () async {
                          try {
                            await launch(Uri.parse(item.nhot_url!).toString());
                          } catch (err) {
                            EasyLoading.showInfo("เกิดข้้อผิดพลาด");
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            imagesNf(
                                width: double.infinity,
                                height: 300,
                                fit: BoxFit.fill,
                                path: item.nhot_img),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              item.nhot_title!,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                                "${DateFormat('dd MMMM yyyy HH:mm น.').format(DateTime.parse(item.nhot_create!))}")
                          ],
                        ),
                      );
                    },
                    options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 0.9,
                      height: 400,
                    )),
                StickyHeader(
                  header: Container(
                    height: 50.0,
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.centerLeft,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (var type in provider.types!)
                          InkWell(
                            onTap: () async {
                              EasyLoading.show();
                              await provider.getItemsNews(cate: type.nt_id);
                              EasyLoading.dismiss();
                            },
                            child: Container(
                              padding: EdgeInsets.all(12),
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  color: provider.s_cate == type.nt_id
                                      ? Colors.orange
                                      : Colors.white,
                                  border: Border.all(
                                      width: 1,
                                      color: provider.s_cate == type.nt_id
                                          ? Colors.orange
                                          : Colors.black),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Text(
                                type.nt_name!,
                                style: TextStyle(
                                    color: provider.s_cate == type.nt_id
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                  content: Container(
                    margin: EdgeInsets.only(top: 12),
                    child: Wrap(
                      runSpacing: 12,
                      spacing: 12,
                      children: [
                        if (provider.items_new == null ||
                            provider.items_new!.length <= 0)
                          Center(
                            child: Container(
                                margin: EdgeInsets.only(top: 60),
                                child: Text('ไม่พบเนื้อหาข่าว')),
                          ),
                        if (provider.items_new != null ||
                            provider.items_new!.length >= 0)
                          for (var item in provider.items_new!)
                            InkWell(
                              onTap: () {
                                provider.selectItem(item);
                                MaterialPageRoute route = MaterialPageRoute(
                                    builder: (_) => NewDetailview());
                                Navigator.push(context, route);
                              },
                              child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  child: Column(
                                    children: [
                                      imagesNf(
                                          width: double.infinity,
                                          height: 100,
                                          radius: 0,
                                          path: item.n_img),
                                      Html(data: item.n_title,
                                      // style:{
                                      //   "*":Style(
                                      //     maxLines: 2,
                                      //     textOverflow: TextOverflow.ellipsis
                                      //   )
                                      // },
                                      )
                                    ],
                                  )),
                            )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
