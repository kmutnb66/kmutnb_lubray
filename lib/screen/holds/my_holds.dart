
import 'package:flutter/material.dart';
import 'package:kmutnb_lubray/provider/hold.dart';
import 'package:kmutnb_lubray/provider/user.dart';
import 'package:kmutnb_lubray/widgets/datepicker.dart';
import 'package:kmutnb_package/model/checkoutItem.dart';
import 'package:kmutnb_package/model/overdueItem.dart';
import 'package:provider/provider.dart';

class MyHoldsView extends StatefulWidget {
  MyHoldsView();

  @override
  State<MyHoldsView> createState() => _MyHoldsViewState();
}

class _MyHoldsViewState extends State<MyHoldsView>
    with SingleTickerProviderStateMixin {
  TabController? controller;


  @override
  void initState() {
    controller = TabController(length: 2, vsync: this, initialIndex: 0);
    controller!.addListener((){
      UserProvider auth = Provider.of(context,listen: false);
      if(controller!.index == 0){
        HoldProvider provider = Provider.of(context,listen: false);
        provider.getCheckOut(auth.user!.patronInfo!.patron_record_id);
      }
      if(controller!.index == 1){
        HoldProvider provider = Provider.of(context,listen: false);
        provider.getOverdue(auth.user!.patronInfo!.patron_record_id!);
      }
     });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  Widget itemCard({String? barcode,String? title,String? checkout,String? num_day_late,String? late}){
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300,width: 1)
      ),
      child: ListTile(
        title: Text("หนังสือที่ยืม: $title"),
        subtitle: Text('วันยืมออก: $checkout\nวันกำหนดส่ง: $num_day_late \nวันยืมเหลือ: $late วัน'),
        // trailing: Icon(Icons.remove_red_eye,color: Colors.orange,),
      ),
    );
  }

   Widget checkoutAll(){
    return Consumer(builder: (_,HoldProvider provider,Widget? child){
      List<CheckoutItemList> items = provider.checkout_item != null ? provider.checkout_item!.checkoutItem! : [];
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              for(var item in items)
                itemCard(barcode: item.barcode,title: item.title,checkout: dateform(DateTime.parse(item.checkout_gmt!)),num_day_late: dateform(DateTime.parse(item.due_gmt!)),late: item.num_day_late),
            ]
          ),
        ),
      );
    });
  }

  Widget overdueItem(){
    return Consumer(builder: (_,HoldProvider provider,Widget? child){
      List<OverdueItemList> items =  provider.overdue_item != null ? provider.overdue_item!.overdueItem! : [];
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              for(var item in items)
                itemCard(barcode: item.barcode,title: item.title,checkout: dateform(DateTime.parse(item.checkout_gmt!)),num_day_late: dateform(DateTime.parse(item.due_gmt!)),late: item.num_day_late),
            ]
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('รายการยืมออก'),
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black38,
            tabs: <Tab>[
              Tab(text: 'ทั้งหมด'),
              Tab(text: 'รายการเกินกำหนดส่ง'),
            ],
            controller: controller,
          )),
      body: Padding(
        padding: const EdgeInsets.only(top: 17),
        child: TabBarView(
          children: [
            checkoutAll(),
            overdueItem()
          ],
          controller: controller,
        ),
      ),
    );
  }
}
