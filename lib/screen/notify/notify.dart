import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:kmutnb_lubray/provider/noti.dart';
import 'package:kmutnb_lubray/provider/user.dart';
import 'package:kmutnb_lubray/screen/notify/notify_detail.dart';
import 'package:kmutnb_package/model/noti.dart';
import 'package:provider/provider.dart';

class NotifyView extends StatelessWidget {
  const NotifyView();

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, NotiProvider provider, Widget? child) {
      List<NotiModel>? items = provider.items;
      return Scaffold(
          body: SafeArea(
              child: Container(
                  alignment: Alignment.topCenter,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Center(
                            child: Text(
                              'รายการแจ้งเตือน',
                              style: TextStyle(fontSize: 28),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal:20),
                          child: Divider(
                            height: 0,
                            thickness: 2,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Expanded(
                            child: SingleChildScrollView(
                                child: Column(children: [
                          for (NotiModel item in items!)
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.grey.shade300, width: 1)),
                              child: ListTile(
                                onTap: () async{
                                  UserProvider auth = Provider.of(context,listen: false);
                                  if(item.Status == '1'){
                                     EasyLoading.show();
                                     await provider.read(notifyRecId: item.TransacetionRecId!);
                                     await provider.getItems(reflash: true,patron_barcode: auth.user!.patronInfo!.barcode!);
                                     EasyLoading.dismiss();
                                  }
                                  MaterialPageRoute route = MaterialPageRoute(builder: (_)=>NotifyDetailView());
                                  Navigator.push(context, route);
                                },
                                title: Text("${item.Mesg}",maxLines: 1,overflow: TextOverflow.ellipsis,),
                                focusColor: item.Status == '1' ? Colors.orange : null,
                                subtitle: Text('${DateFormat("dd/MM/yyyy HH:mm").format(DateTime.parse(item.UpdateDT!))}'),
                              ),
                            )
                        ])))
                      ]))));
    });
  }
}
