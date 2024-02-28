import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:kmutnb_lubray/provider/user.dart';
import 'package:kmutnb_lubray/screen/auth/login.dart';
import 'package:kmutnb_lubray/widgets/widget-images.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AccountView extends StatelessWidget {
  const AccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, UserProvider provider, Widget? child) {
      var item = provider.user;
      return Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.only(top: 20),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Text(
                    //   'บัญชีผู้ใช้',
                    //   style: TextStyle(fontSize: 24),
                    // ),
                    // Container(
                    //     margin: EdgeInsets.only(top: 20, bottom: 12),
                    //     alignment: Alignment.bottomCenter,
                    //     width: 150,
                    //     height: 150,
                    //     decoration: BoxDecoration(
                    //          image: DecorationImage(
                    //         image: imageProvider(file: item!.image!),
                    //         fit: BoxFit.cover,
                    //         onError: (exception, stackTrace) => Container(),
                    //       ))),
                    // Text(
                    //   "ชื่อ-สกุล : ${item.patron!.DisplayName}\nรหัสนักศึกษา : ${item.patronInfo!.barcode}",
                    //   textAlign: TextAlign.center,
                    // ),
                    // SizedBox(
                    //   height: 12,
                    // ),
                    ToggleButtons(
                      isSelected: provider.toggle,
                      onPressed: (int index) {
                        provider.toggleFn(index);
                      },
                      children: const <Widget>[
                        Icon(Icons.document_scanner_outlined),
                        Icon(Icons.qr_code),
                      ],
                    ),
                    if(provider.toggle[0])
                    Container(
                      width: 300,
                      margin: EdgeInsets.only(top: 12, bottom: 5),
                      child: BarcodeWidget(
                        barcode: Barcode.code128(),
                        data: item!.patronInfo!.barcode!,
                        errorBuilder: (context, error) =>
                            Center(child: Text(error)),
                      ),
                    ),
                    if(provider.toggle[1])
                    QrImage(
                      data: item!.patronInfo!.barcode!,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                    Text(
                      "(ใช้สแกนเพื่อเข้าห้องสมุด)",
                      style: TextStyle(fontSize: 12),
                    ),
                    // Container(
                    //   margin: EdgeInsets.only(top: 12),
                    //   width: double.infinity,
                    //   child: RaisedButton(
                    //     child: Text('ออกจากระบบ'),
                    //     onPressed: () {
                    //       showDialog(
                    //           context: context,
                    //           builder: (_) {
                    //             return AlertDialog(
                    //               title: Text('ต้องการออกจากระบบ?'),
                    //               actions: [
                    //                 TextButton(
                    //                     onPressed: () => Navigator.pop(context),
                    //                     child: Text('กลับ')),
                    //                 TextButton(
                    //                     onPressed: () {
                    //                       provider.logout();
                    //                       MaterialPageRoute route =
                    //                           MaterialPageRoute(
                    //                               builder: (_) => Login());
                    //                       Navigator.pushAndRemoveUntil(
                    //                           context, route, (route) => false);
                    //                     },
                    //                     child: Text(
                    //                       'ออกจากระบบ',
                    //                       style: TextStyle(color: Colors.red),
                    //                     )),
                    //               ],
                    //             );
                    //           });
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
