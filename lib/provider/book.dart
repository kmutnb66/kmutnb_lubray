import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kmutnb_lubray/environment.dart';
import 'package:kmutnb_package/exception/error.dart';
import 'package:kmutnb_package/kmutnb_package.dart';
import 'package:kmutnb_package/model/book.dart';
import 'package:kmutnb_package/model/page.dart';

class BookProvider with ChangeNotifier {
  ApiServiceModel apiService = KmutnbService.apiService(env: Environment.data);
  PageModel page = PageModel(limit: 10, total: 0, pageNumber: 0);
  List<BookModel>? items;
  BookModel? s_item;

  Future getItems({String? search}) async {
    Map<String, dynamic> query = Map();
    items = [];
    try {
      var res = await apiService.book.list(search: search!,page: page,query: query);
      Map<String, dynamic> body = jsonDecode(res.body);
      if (body['code'] != null) {
        throw ErrorExceptionCustom(code: body['code'].toString(),message: body['name'] ?? body['name']);
      }
       if (body['total'] == 0) {
        throw ErrorExceptionCustom(code: "204",message: "ไม่พบหนังสือ");
      }
      body['entries']
          .map((data) => items!.add(BookModel.fromMap(data)))
          .toList();
    } on ErrorExceptionCustom catch (err) {
      EasyLoading.showError(err.message);
    } on HttpException catch (err) {
      EasyLoading.showError(err.message);
    } on SocketException catch (err) {
      EasyLoading.showError(err.message);
    } catch (err) {
      EasyLoading.showError('เกิดข้อผิดพลาด');
    }
    notifyListeners();
  }

  selectItem(BookModel item) {
    s_item = item;
    notifyListeners();
  }

  clear() {
    items = null;
    notifyListeners();
  }
}
