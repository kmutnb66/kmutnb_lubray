import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:kmutnb_lubray/provider/news.dart';
import 'package:kmutnb_lubray/widgets/widget-images.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NewDetailview extends StatelessWidget {
  NewDetailview();

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, NewsProvider provider, Widget? child) {
      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
                child:  Column(
                    children: [
                      imagesNf(
                          width: double.infinity,
                          height: 200,
                          radius: 0,
                          path: provider.s_item!.n_img,
                          fit: BoxFit.cover),
                      SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Html(data: provider.s_item!.n_title),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Html(
                            data: provider.s_item!.n_detail,
                            onLinkTap: (String? url,
                                RenderContext context,
                                Map<String, String> attributes,
                                element) async{
                                  try{
                                    await launch(Uri.parse(url!).toString());
                                  }catch(err){
                                    EasyLoading.showInfo("ไม่สามารถเปิดลิงค์ได้");
                                  }
                            }),
                      )
                    ],
                )
          ),
        ),
      );
    });
  }
}
