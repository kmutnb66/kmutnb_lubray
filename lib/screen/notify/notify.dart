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
      List<NotiModel>? items = provider.items != null ? provider.items : [];
      var num_noti = items!.where((element) => element.Status =='1').length;
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
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'รายการแจ้งเตือน',
                                  style: TextStyle(fontSize: 28),
                                ),
                                if(num_noti > 0)
                                Container(alignment: Alignment.center,margin: EdgeInsets.only(top:5,left: 5),padding: EdgeInsets.all(6),decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(100)),child: Text('$num_noti',style: TextStyle(color: Colors.white,fontSize: 12),))
                              ],
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
                          for (NotiModel item in items)
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  // color: Colors.white,
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
                                  }else{
                                    provider.openMessage(notifyRecId: item.TransacetionRecId!);
                                  }
                                  MaterialPageRoute route = MaterialPageRoute(builder: (_)=>NotifyDetailView());
                                  Navigator.push(context, route).then((value) => {provider.getItems(patron_barcode: auth.user!.patronInfo!.barcode!)});
                                },
                                leading: item.Status == '1' ? Container(margin: EdgeInsets.only(top: 12),width: 10,height: 10,decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(100)),) : null,
                                minLeadingWidth: 10,
                                title: Text("${item.Mesg}",maxLines: 1,overflow: TextOverflow.ellipsis,),
                                // focusColor: item.Status == '1' ? Colors.orange : null,
                                subtitle: Text('${DateFormat("dd/MM/yyyy HH:mm").format(DateTime.parse(item.EnterDT!))}'),
                              ),
                            )
                        ])))
                      ]))));
    });
  }
}
