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

  getItemMybooking({required String patron_id}) async {
    try {
      var res = await apiService.book.my(patron_id: patron_id);
      my_item = MyHoldsModel.fromJson(res.body);
      if (my_item!.total == null || my_item!.total == 0) {
        my_item = null;
        throw ErrorExceptionCustom(code: "204", message: "ไม่พบรายการจอง");
      }
      List<MybookingListModel> items = [];
      for (var item in my_item!.entries!) {
        String bib_id = item.record!.split('/').last;
        item.book_detail = BookDetailModel.fromMap(
            await jsonDecode((await apiService.book.oject(id: bib_id)).body));
        if (item.book_detail!.bibIds!.length > 0) {
          item.item_book = BookBibModel.fromMap(await jsonDecode(
              (await apiService.book
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
            code: "204",
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
      EasyLoading.showError('เกิดข้อผิดพลาด');
      return false;
    }
  }

  Future<bool> cancel({required String holdId}) async {
    try {
      var res = await apiService.customService.delete(
          '/LibMobile/v1/patrons/holds',
          holdId,appName: ApiName.smartapp);
      var body = jsonDecode(res.body);
      if(body == null){
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
      print(err);
      EasyLoading.showError('เกิดข้อผิดพลาด');
      return false;
    }
  }

  clear() {
    items = null;
    notifyListeners();
  }
}
