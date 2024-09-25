import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kmutnb_lubray/provider/hold.dart';
import 'package:kmutnb_lubray/screen/holds/book.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanBooking extends StatefulWidget {
  bool? booking;
  ScanBooking({this.booking});

  @override
  State<StatefulWidget> createState() => _ScanBookingState();
}

class _ScanBookingState extends State<ScanBooking> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildQrView(context),
          Positioned(
              bottom: 40,
              right: 30,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                    borderRadius: BorderRadius.circular(100)),
                child: IconButton(
                    onPressed: () async {
                      await controller?.toggleFlash();
                      setState(() {});
                    },
                    icon: FutureBuilder(
                      future: controller?.getFlashStatus(),
                      builder: (context, snapshot) {
                        bool status = snapshot.data as bool;
                        return Icon(
                          status ? Icons.flash_on : Icons.flash_off,
                          color: Colors.white,
                        );
                      },
                    )),
              )),
          Positioned(
            bottom: 150,
            child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'สแกนบาร์โค้ดที่หนังสือเพื่อทำการยืม',
                  style: TextStyle(color: Colors.white),
                )),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      result = scanData;
      await controller.pauseCamera();
      if (result != null) {
        HoldProvider provider = Provider.of(context, listen: false);
        EasyLoading.show();
        bool? status = await provider.getMoreitem(result!.code!);
        result = null;
        if(status == null){
            await controller.resumeCamera();
        }
        if (status != null || status!) {
          if(widget.booking == null){
              MaterialPageRoute route =
              MaterialPageRoute(builder: (_) => BookDetailView());
          Navigator.push(context, route)
              .then((value) async => await controller.resumeCamera());
          EasyLoading.dismiss();
          }else{
            Navigator.pop(context,status);
          }
        }
      }
      setState(() {});
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
