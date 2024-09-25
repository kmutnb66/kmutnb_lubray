import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kmutnb_lubray/environment.dart';
import 'package:kmutnb_package/kmutnb_package.dart';
import 'package:kmutnb_package/model/noti.dart';
import 'package:kmutnb_package/model/page.dart';

class NotiProvider with ChangeNotifier {
  ApiServiceModel apiService = KmutnbService.apiService(env: Environment.data);
  List<NotiModel>? items;
  NotiModel? item;
  PageModel page = PageModel(limit: 10, total: 0, pageNumber: 0);
  bool loading = true;

  Future getItems({required String patron_barcode,bool reflash = false, bool next = false}) async {
    loading = true;
      page.pageNumber = 0;
      items = [];
    // if (reflash) {
    //   page.pageNumber = 0;
    //   items = [];
    // }
    if (next) page.pageNumber += page.limit;
    try {
      var res = await apiService.notiHttp.list(patron_barcode: patron_barcode);
      print(res.request);
      var body = jsonDecode(res.body);
      body.map((data)=>items!.add(NotiModel.fromMap(data))).toList();
      print(items);
      // print(items!.where((element) => element.Status =='1').length);
    } on HttpException catch (err) {
      EasyLoading.showError(err.message);
    } on SocketException catch (err) {
      EasyLoading.showError(err.message);
    } catch (err) {
      EasyLoading.showError('ไม่พบข้อมูล');
    }
    loading = false;
    notifyListeners();
  }

  Future read({required String notifyRecId}) async {
    try {
      var res = await apiService.notiHttp.read(notifyRecId: notifyRecId);
      print(notifyRecId);
      print(res.request);
      print(res.statusCode);
      item = items!.firstWhere((data) => data.TransacetionRecId == notifyRecId);
      
    } on HttpException catch (err) {
      EasyLoading.showError(err.message);
    } on SocketException catch (err) {
      EasyLoading.showError(err.message);
    } catch (err) {
      EasyLoading.showError('เกิดข้อผิดพลาด');
    }
    notifyListeners();
  }

}
