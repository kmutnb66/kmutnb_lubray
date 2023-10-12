import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kmutnb_lubray/environment.dart';
import 'package:kmutnb_package/kmutnb_package.dart';
import 'package:kmutnb_package/model/ebook.dart';
import 'package:kmutnb_package/model/page.dart';

class EBookProvider with ChangeNotifier {
  ApiServiceModel apiService = KmutnbService.apiService(env: Environment.data);
  List<EBookModel>? items;
  PageModel page = PageModel(limit: 10, total: 0, pageNumber: 0);
  bool loading = true;

  Future getItems({String search = '',bool reflash = false, bool next = false}) async {
    loading = true;
    if (reflash) {
      page.pageNumber = 0;
      items = [];
    }
    if (next) page.pageNumber += page.limit;
    try {
      var res = await apiService.eBook.list(search: search,page: page);
      var body = jsonDecode(res.body);
      body.map((data) {
        if(items!.where((element) => element.PathToFile == data['PathToFile']).toList().length == 0){
          items!.add(EBookModel.fromMap(data));
        }
      }).toList();
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
}
