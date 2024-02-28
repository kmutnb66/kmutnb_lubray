import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:kmutnb_lubray/provider/user.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CardFrontView extends StatelessWidget {
  final String? cardNumber;
  final String? cardHolderName;
  final String? cardExpiry;

  CardFrontView(
      {Key? key, this.cardNumber, this.cardHolderName, this.cardExpiry});

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, UserProvider provider, Widget? child) {
      var user = provider.user;
      return Container(
        height: 204,
        margin: EdgeInsets.symmetric(horizontal: 35),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.asset('assets/images/card.png'),
            ),
            Positioned(
              left: 17,
              top: 52,
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 70,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.red, width: 1),
                        image: DecorationImage(
                          image: FileImage(user!.image!),
                          fit: BoxFit.contain,
                          onError: (exception, stackTrace) {},
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Stack(
                      children: [
                        QrImage(
                          data: user.patronInfo!.barcode!,
                          version: QrVersions.auto,
                          size: 200.0,
                        ),
                        Positioned(
                          bottom: 3,
                          left: 1,
                          child: Text(
                            "(ใช้สแกนเพื่อเข้าห้องสมุด)",
                            style: TextStyle(fontSize: 5),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                left: 90,
                top: 70,
                child: Text(
                  'ชื่อ-สกุล ${user.patron!.DisplayName}\nรหัสสมาชิก ${user.patronInfo!.barcode}',
                  style: TextStyle(fontSize: 10),
                )),
            Positioned(
                right: 17,
                top: 55,
                child: new RotatedBox(
                    quarterTurns: 3,
                    child: BarcodeWidget(
                      barcode: Barcode.code128(),
                      width: 129,
                      height: 57,
                      style: TextStyle(fontSize: 8),
                      backgroundColor: Colors.white,
                      data: user.patronInfo!.barcode!,
                      errorBuilder: (context, error) =>
                          Center(child: Text(error)),
                    )))
          ],
        ),
      );
    });
  }
}
