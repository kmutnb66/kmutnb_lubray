import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kmutnb_lubray/environment.dart';
import 'package:kmutnb_lubray/model/circulation.dart';
import 'package:kmutnb_package/exception/error.dart';
import 'package:kmutnb_package/kmutnb_package.dart';
import 'package:kmutnb_package/model/book.dart';
import 'package:kmutnb_package/model/book_detail.dart';
import 'package:kmutnb_package/model/checkoutItem.dart';
import 'package:kmutnb_package/model/enviroment.dart';
import 'package:kmutnb_package/model/image.dart';
import 'package:kmutnb_package/model/more_item_info.dart';
import 'package:kmutnb_package/model/overdueItem.dart';

class HoldProvider with ChangeNotifier {
  ApiServiceModel apiService = KmutnbService.apiService(env: Environment.data);
  MoreItemInfoModel? more_item;
  List<CirculationModel>? checkout_item;
  List<CirculationModel>? hold_item;
  OverdueItemModel? overdue_item;

  Future<bool?> getMoreitem(String id) async {
    try {
      var res = await apiService.moreItemInfo.object(barcode: id);
      var body = jsonDecode(res.body);
      List<MoreItemInfoList> moreItemInfoList = [];
      body['x_item_info']
          .map((data) => moreItemInfoList.add(MoreItemInfoList.fromMap(data)))
          .toList();
      more_item = MoreItemInfoModel(more_item_info: moreItemInfoList);
      if (more_item!.more_item_info == null ||
          more_item!.more_item_info!.length == 0) {
        notifyListeners();
        return throw 'err';
      } else {
        more_item!.more_item_info!.last.images = ImageModel.fromMap(jsonDecode(
            (await apiService.moreItemInfo.cover(
                    bib_record_id:
                        more_item!.more_item_info!.last.bib_record_id!))
                .body));
        notifyListeners();
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
      var res = await apiService.customService.list(
          '/LibMobile/v1/patron/$id/circulation/history',
          appName: ApiName.smartapp);
      var body = jsonDecode(res.body);
      if (body['total'] < 1) {
        checkout_item = [];
        throw ErrorExceptionCustom(code: "204", message: "ไม่พบรายการยืม");
      }
      checkout_item = [];
      body['entries']
          .map((data) => checkout_item!.add(CirculationModel.fromMap(data)))
          .toList();
    } on ErrorExceptionCustom catch (err) {
      // EasyLoading.showError(err.message, duration: Duration(seconds: 2));
    } on HttpException catch (err) {
      EasyLoading.showError(err.message);
    } on SocketException catch (err) {
      EasyLoading.showError(err.message);
    } catch (err) {
      EasyLoading.showError('เกิดข้อผิดพลาด');
    }
    EasyLoading.dismiss();
    notifyListeners();
  }

  Future getOverdue(String id) async {
    EasyLoading.show();
    try {
      var res = await apiService.overdueItem.list(patron_record_id: id);
      overdue_item = OverdueItemModel.fromJson(res.body);
      if (overdue_item!.overdueItem!.length < 1) {
        await getHold(id);
      }
    } on HttpException catch (err) {
      EasyLoading.showError(err.message);
    } on SocketException catch (err) {
      EasyLoading.showError(err.message);
    } catch (err) {
      EasyLoading.showError('เกิดข้อผิดพลาด');
    }
    EasyLoading.dismiss();
    notifyListeners();
  }

  Future getHold(id) async {
    EasyLoading.show();
    try {
      var res = await apiService.customService.list(
          '/LibMobile/v1/patron/$id/checkouts',
          appName: ApiName.smartapp);
      print(res.request);
      var body = jsonDecode(res.body);
      if (body['total'] < 1) {
        hold_item = [];
        throw ErrorExceptionCustom(code: "204", message: "ไม่พบรายการยืม");
      }
      hold_item = [];
      if (body['entries'] != null) {
        for (var item in body['entries']) {
          var id = item['item'].split('/').last!;
          var res_detail =
              jsonDecode((await apiService.book.oject(id: id)).body);
          CirculationModel circulation = CirculationModel.fromMap(item);
          var now = DateTime.now();
          var dDay = DateTime.parse(circulation.dueDate!);
          if (dDay.difference(now).inDays > 0) {
            BookBibModel? bib;
            BookDetailModel? book_detail;
            if (res_detail['code'] != 107)
              book_detail = BookDetailModel.fromMap(res_detail);
            if (book_detail != null && book_detail.bibIds!.length > 0) {
              bib = BookBibModel.fromJson((await apiService.book
                      .mydetail(id: book_detail.bibIds!.first))
                  .body);
            }
            bib!.images = ImageModel.fromJson(
                (await apiService.moreItemInfo.cover(bib_record_id: id)).body);
            bib.item = BookDetailModel.fromJson(
                (await apiService.book.oject(id: id)).body);
            hold_item!.add(circulation..bib = bib);
          } else {
            BookBibModel? bib;
            BookDetailModel? book_detail;
            if (res_detail['code'] != 107)
              book_detail = BookDetailModel.fromMap(res_detail);
            if (book_detail != null && book_detail.bibIds!.length > 0) {
              bib = BookBibModel.fromJson((await apiService.book
                      .mydetail(id: book_detail.bibIds!.first))
                  .body);
            }
            if (overdue_item == null) {
              overdue_item = OverdueItemModel(overdueItem: []);
            }
            overdue_item!.overdueItem!
                .add(OverdueItemList(title: bib!.title,checkout_gmt: circulation.outDate,due_gmt: circulation.dueDate));
          }
        }
      }
    } on ErrorExceptionCustom catch (err) {
      // EasyLoading.showError(err.message, duration: Duration(seconds: 2));
    } on HttpException catch (err) {
      EasyLoading.showError(err.message);
    } on SocketException catch (err) {
      EasyLoading.showError(err.message);
    } catch (err) {
      print(err);
      EasyLoading.showError('เกิดข้อผิดพลาด');
    }
    EasyLoading.dismiss();
    notifyListeners();
  }

  hold({required String barcode, String? patron_id}) async {
    try {
      var res = await apiService.hold.create(data: {
        "patronBarcode": barcode,
        "itemBarcode": more_item!.more_item_info!.last.barcode
      });
      var body = jsonDecode(res.body);
      if (body['name'] != null) {
        throw ErrorExceptionCustom(
            code: body['code'].toString(), message: body['name']);
      }
      await getCheckOut(patron_id);
    } on ErrorExceptionCustom catch (err) {
      EasyLoading.showInfo(err.message, duration: Duration(seconds: 2));
    } on HttpException catch (err) {
      EasyLoading.showError(err.message);
    } on SocketException catch (err) {
      EasyLoading.showError(err.message);
    } catch (err) {
      EasyLoading.showError("ยืมหนังสือไม่สำเร็จ");
    }
  }

  renew(
      {required String checkoutid,
      String? patron_id,
      bool checkout = true}) async {
    try {
      await apiService.hold.renew(checkoutid: checkoutid);
      if (checkout) {
        await getCheckOut(patron_id);
      } else {
        await getOverdue(patron_id!);
      }
    } on HttpException catch (err) {
      EasyLoading.showError(err.message);
    } on SocketException catch (err) {
      EasyLoading.showError(err.message);
    } catch (err) {
      EasyLoading.showError("ยืมหนังสือไม่สำเร็จ");
    }
  }
}
