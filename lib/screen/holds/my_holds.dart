import 'package:flutter/material.dart';
import 'package:kmutnb_lubray/model/circulation.dart';
import 'package:kmutnb_lubray/provider/hold.dart';
import 'package:kmutnb_lubray/provider/tab_booking.dart';
import 'package:kmutnb_lubray/provider/user.dart';
import 'package:kmutnb_lubray/screen/books/my_booking.dart';
import 'package:kmutnb_lubray/widgets/datepicker.dart';
import 'package:kmutnb_package/model/checkoutItem.dart';
import 'package:kmutnb_package/model/overdueItem.dart';
import 'package:provider/provider.dart';

class MyHoldsView extends StatefulWidget {
  int? tab = 1;
  MyHoldsView({this.tab});

  @override
  State<MyHoldsView> createState() => _MyHoldsViewState();
}

class _MyHoldsViewState extends State<MyHoldsView>
    with SingleTickerProviderStateMixin {
  TabController? controller;

  @override
  void initState() {
    controller =
        TabController(length: 4, vsync: this, initialIndex: widget.tab!);
    controller!.addListener(() {
      if (controller!.indexIsChanging)
        TabBookingProvider.init(context: context, tab: controller!.index);
      ;
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  Widget itemCard(
      {String? barcode,
      String? title,
      String? checkout,
      String? num_day_late,
      String? late}) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, width: 1)),
      child: ListTile(
        title: Text("หนังสือที่ยืม: $title"),
        subtitle: Text(
            'วันยืมออก: $checkout\nวันกำหนดส่ง: $num_day_late '),

        // trailing: Icon(Icons.remove_red_eye,color: Colors.orange,),
      ),
    );
  }

  Widget checkoutAll() {
    return Consumer(builder: (_, HoldProvider provider, Widget? child) {
      List<CirculationModel>? items =
          provider.checkout_item != null ? provider.checkout_item : [];
      return items!.length < 1
          ? Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/icon/sucess.png',
                    width: 200,
                  ),
                  Text("ไม่พบรายการคืน")
                ],
              ),
            )
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            for (var item in items)
              itemCard(
                  title: item.best_author,
                  checkout: dateform(DateTime.parse(item.checkout_gmt!)),
                  num_day_late:
                      dateform(DateTime.parse(item.last_checkin_gmt!)),
                  late: '-'),
          ]),
        ),
      );
    });
  }

  Widget hold() {
    return Consumer(builder: (_, HoldProvider provider, Widget? child) {
      List<CirculationModel>? items =
          provider.hold_item != null ? provider.hold_item : [];
      return items!.length < 1
          ? Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/icon/hold.png',
                    width: 200,
                  ),
                  Text("ไม่พบรายการยืม")
                ],
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  for (var item in items)
                    itemCard(
                        title: item.bib!.title,
                        checkout: dateform(DateTime.parse(item.outDate!)),
                        num_day_late:
                            dateform(DateTime.parse(item.dueDate!)),
                        late: '-'),
                ]),
              ),
            );
    });
  }

  Widget overdueItem() {
    return Consumer(builder: (_, HoldProvider provider, Widget? child) {
      List<OverdueItemList> items = provider.overdue_item != null
          ? provider.overdue_item!.overdueItem!
          : [];
      return items.length < 1
          ? Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/icon/over.png',
                    width: 200,
                  ),
                  Text("ไม่พบรายการเกินกำหนด")
                ],
              ),
            )
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            for (var item in items)
              itemCard(
                  barcode: item.barcode,
                  title: item.title,
                  checkout: dateform(DateTime.parse(item.checkout_gmt!)),
                  num_day_late: dateform(DateTime.parse(item.due_gmt!)),
                  late: item.num_day_late),
          ]),
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
              Tab(text: 'จองอยู่'),
              Tab(text: 'ยืมอยู่'),
              Tab(text: 'คืนแล้ว/สำเร็จ'),
              Tab(text: 'เกินกำหนดการคืน')
            ],
            controller: controller,
          )),
      body: Padding(
        padding: const EdgeInsets.only(top: 17),
        child: TabBarView(
          children: [BookingView(), hold(), checkoutAll(), overdueItem()],
          controller: controller,
        ),
      ),
    );
  }
}
