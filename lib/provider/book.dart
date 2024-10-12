import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kmutnb_lubray/environment.dart';
import 'package:kmutnb_package/exception/error.dart';
import 'package:kmutnb_package/kmutnb_package.dart';
import 'package:kmutnb_package/model/book.dart';
import 'package:kmutnb_package/model/book_detail.dart';
import 'package:kmutnb_package/model/enviroment.dart';
import 'package:kmutnb_package/model/holds_form.dart';
import 'package:kmutnb_package/model/image.dart';
import 'package:kmutnb_package/model/my_holds.dart';
import 'package:kmutnb_package/model/page.dart';
import 'package:kmutnb_package/model/patronHoldPost.dart';
import 'package:kmutnb_package/translate/translate.dart';

class BookProvider with ChangeNotifier {
  ApiServiceModel apiService = KmutnbService.apiService(env: Environment.data);
  PageModel page = PageModel(limit: 10, total: 0, pageNumber: 0);
  List<BookModel>? items;
  MyHoldsModel? my_item;
  HoldsFormModel? form;
  BookModel? s_item;

  Future getItems({String? search}) async {
    Map<String, dynamic> query = Map();
    items = [];
    try {
      var res =
          await apiService.book.list(search: search!, page: page, query: query);
      Map<String, dynamic> body = jsonDecode(res.body);
      if (body['code'] != null) {
        throw ErrorExceptionCustom(
            code: body['code'].toString(),
            message: body['name'] ?? body['name']);
      }
      if (body['total'] == 0) {
        throw ErrorExceptionCustom(code: "204", message: "ไม่พบหนังสือ");
      }
      if (body['entries'] != null) {
        for (var item in body['entries']) {
          item['bib']['images'] = jsonDecode((await apiService.moreItemInfo
                  .cover(bib_record_id: item['bib']['id']))
              .body);
          item['bib']['item'] = jsonDecode(
              (await apiService.book.oject(id: item['bib']['id'])).body);
          items!.add(BookModel.fromMap(item));
        }
      }
    } on ErrorExceptionCustom catch (err) {
      EasyLoading.showError(err.message, duration: Duration(seconds: 2));
    } on HttpException catch (err) {
      EasyLoading.showError(err.message);
    } on SocketException catch (err) {
      EasyLoading.showError(err.message);
    } catch (err) {
      print(err);
      EasyLoading.showError('เกิดข้อผิดพลาด');
    }
    notifyListeners();
  }

  Future<Map<String, dynamic>> holdsAndhistory(
      {required String patron_id}) async {
    Map<String, dynamic> res = Map();
    var res_holds = jsonDecode((await apiService.customService.list(
            '/LibMobile/v1/patron/$patron_id/holds',
            appName: ApiName.smartapp))
        .body);
    if (res_holds['total'] == null) res_holds['total'] = 0;
    
    return res = {
      'total': res_holds['total'] ,
      'start': res_holds['start'],
      'entries':res_holds['entries']
    };
  }

  getItemMybooking({required String patron_id}) async {
    try {
      var res = await holdsAndhistory(patron_id: patron_id);
      my_item =
          MyHoldsModel(total: res['total'], start: res['start'], entries: []);
      if (my_item!.total == null || my_item!.total == 0) {
        my_item = null;
        throw ErrorExceptionCustom(code: "204", message: "ไม่พบรายการจอง");
      }
      res['entries']
          .map((data) => my_item!.entries!.add(MybookingListModel(
              record: (data['record'] as String).split('/').last,
              pickupLocation: LocationModel(
                  code: data['PickupLocation'], name: data['PickupLocation']))))
          .toList();
      List<MybookingListModel> items = [];
      for (var item in my_item!.entries!) {
        String bib_id = item.record!;
        var book_detail =
            jsonDecode((await apiService.book.oject(id: bib_id)).body);
        if (book_detail['code'] != 107)
          item.book_detail = BookDetailModel.fromMap(book_detail);
        if (item.book_detail != null && item.book_detail!.bibIds!.length > 0) {
          item.item_book = BookBibModel.fromMap(jsonDecode((await apiService
                  .book
                  .mydetail(id: item.book_detail!.bibIds!.first))
              .body));
        }
        if (item.item_book != null) {
          item.item_book!.images = ImageModel.fromMap(jsonDecode(
              (await apiService.moreItemInfo
                      .cover(bib_record_id: item.item_book!.id!))
                  .body));
        }
        items.add(item);
      }
      my_item!.entries = items;
    } on ErrorExceptionCustom catch (err) {
      my_item = null;
      // EasyLoading.showError(err.message, duration: Duration(seconds: 2));
    } on HttpException catch (err) {
      EasyLoading.showError(err.message);
    } on SocketException catch (err) {
      EasyLoading.showError(err.message);
    } catch (err) {
      print(err);
      print('kefo');
      EasyLoading.showError('เกิดข้อผิดพลาด');
    }
    EasyLoading.dismiss();
    notifyListeners();
  }

  Future<bool> selectItem({required String patron_id, BookModel? item}) async {
    s_item = item;
    try {
      var res = await apiService.book
          .form(patron_id: patron_id, recordNumber: s_item!.bib!.id!);
      var body = jsonDecode(res.body);
      if (body['description'] != null) {
        throw ErrorExceptionCustom(
            code: "204", message: "${body['code']}\n${body['description']}");
      }
      form = HoldsFormModel.fromMap(body);
      List<LocationModel> locations = [];
      if (item!.bib!.item != null && item.bib!.item!.location != null) {
        for (var location in form!.holdshelf!.locations!) {
          if (item.bib!.item!.location!.code == location.code) {
            locations.add(location);
          }
        }
        form!.holdshelf!.locations = locations;
        if (locations.length == 0) {
          form!.holdshelf!.locations = [item.bib!.item!.location!];
        }
      }
      notifyListeners();
      return true;
    } on ErrorExceptionCustom catch (err) {
      EasyLoading.showError(err.message, duration: Duration(seconds: 2));
      notifyListeners();
      return false;
    } on HttpException catch (err) {
      EasyLoading.showError(err.message);
      return false;
    } on SocketException catch (err) {
      EasyLoading.showError(err.message);
      return false;
    } catch (err) {
      print(err);
      EasyLoading.showError('เกิดข้อผิดพลาด');
      return false;
    }
  }

  Future<bool> booking(
      {required String patron_id, required PatronHoldPostModel data}) async {
    try {
      var res = await apiService.book.create(patron_id: patron_id, data: data);
      var body = jsonDecode(res.body);
      if (body['description'] != null) {
        throw ErrorExceptionCustom(
            code: '${body['code']}',
            message:
                "${Translate.get(text: '${body['code']}') != '${body['code']}' ? Translate.get(text: '${body['code']}') : body['description']}");
      }
      EasyLoading.showSuccess('ทำการจองสำเร็จ');
      return true;
    } on ErrorExceptionCustom catch (err) {
      EasyLoading.showError(err.message, duration: Duration(seconds: 2));
      return false;
    } on HttpException catch (err) {
      EasyLoading.showError(err.message);
      return false;
    } on SocketException catch (err) {
      EasyLoading.showError(err.message);
      return false;
    } catch (err) {
      EasyLoading.showError(Translate.get(text: '132')!);
      return false;
    }
  }

  Future<bool> cancel({required String holdId}) async {
    try {
      var res = await apiService.customService.delete(
          '/LibMobile/v1/patrons/holds', holdId,
          appName: ApiName.smartapp);
      var body = jsonDecode(res.body);
      if (body == null) {
        throw ErrorExceptionCustom(
            code: "204", message: "ยกเลิกการจองไม่สำเร็จ");
      }
      if (body != null && body['description'] != null) {
        throw ErrorExceptionCustom(
            code: "204", message: "${body['code']}\n${body['description']}");
      }
      EasyLoading.showSuccess('ยกเลิกการจองสำเร็จ');
      return true;
    } on ErrorExceptionCustom catch (err) {
      EasyLoading.showError(err.message, duration: Duration(seconds: 2));
      return false;
    } on HttpException catch (err) {
      EasyLoading.showError(err.message);
      return false;
    } on SocketException catch (err) {
      EasyLoading.showError(err.message);
      return false;
    } catch (err) {
      EasyLoading.showError('เกิดข้อผิดพลาด');
      return false;
    }
  }

  clear() {
    items = null;
    notifyListeners();
  }
}
