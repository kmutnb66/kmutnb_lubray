import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kmutnb_lubray/environment.dart';
import 'package:kmutnb_package/kmutnb_package.dart';
import 'package:kmutnb_package/model/checkoutItem.dart';
import 'package:kmutnb_package/model/more_item_info.dart';
import 'package:kmutnb_package/model/overdueItem.dart';

class HoldProvider with ChangeNotifier {
  ApiServiceModel apiService = KmutnbService.apiService(env: Environment.data);
  MoreItemInfoModel? more_item;
  CheckoutItemModel? checkout_item;
  OverdueItemModel? overdue_item;

  Future<bool?> getMoreitem(String id) async {
    try {
      var res = await apiService.moreItemInfo.object(barcode: id);
      more_item = MoreItemInfoModel.fromJson(res.body);
      notifyListeners();
      if (more_item!.more_item_info == null ||
          more_item!.more_item_info!.length == 0) {
        return throw 'err';
      } else {
        return true;
      }
    } on HttpException catch (err) {
      EasyLoading.showError(err.message);
    } on SocketException catch (err) {
      EasyLoading.showError(err.message);
    } catch (err) {
      EasyLoading.showError('ไม่พบหนังสือ');
      notifyListeners();
    }
  }

  Future getCheckOut(id) async {
    EasyLoading.show();
    try {
      var res = await apiService.checkoutItem.list(patron_record_id: id);
      checkout_item = CheckoutItemModel.fromJson(res.body);
      EasyLoading.dismiss();
    } on HttpException catch (err) {
      EasyLoading.showError(err.message);
    } on SocketException catch (err) {
      EasyLoading.showError(err.message);
    } catch (err) {
      EasyLoading.showError('เกิดข้อผิดพลาด');
    }
    notifyListeners();
  }

  Future getOverdue(String id) async {
    EasyLoading.show();
    try {
      var res = await apiService.overdueItem.list(patron_record_id: id);
      overdue_item = OverdueItemModel.fromJson(res.body);
      EasyLoading.dismiss();
    } on HttpException catch (err) {
      EasyLoading.showError(err.message);
    } on SocketException catch (err) {
      EasyLoading.showError(err.message);
    } catch (err) {
      EasyLoading.showError('เกิดข้อผิดพลาด');
    }
    notifyListeners();
  }

  hold({required String barcode, String? patron_id}) async {
    try {
      var res = await apiService.hold.create(data: {
        "patronBarcode": barcode,
        "itemBarcode": more_item!.more_item_info!.last.barcode
      });
      await getCheckOut(patron_id);
    } on HttpException catch (err) {
      EasyLoading.showError(err.message);
    } on SocketException catch (err) {
      EasyLoading.showError(err.message);
    } catch (err) {
      EasyLoading.showError("ยืมหนังสือไม่สำเร็จ");
    }
  }
}
