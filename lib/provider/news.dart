import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kmutnb_lubray/environment.dart';
import 'package:kmutnb_package/kmutnb_package.dart';
import 'package:kmutnb_package/model/new_type.dart';
import 'package:kmutnb_package/model/news.dart';

class NewsProvider with ChangeNotifier {
  ApiServiceModel apiService = KmutnbService.apiService(env: Environment.data);

  List<NewsModel>? items_new;
  List<NewsHotModel>? items_newhot;

  NewsModel? s_item;
  String s_cate = '1';
  List<NewTypeModel>? types;

  Future init() async {
    await getItemsNewHot();
    await getItemsNewType();
    await getItemsNews();
  }

  Future getItemsNews({String? cate, String username = ""}) async {
    if (cate != null) {
      s_cate = cate;
    }
    items_new = [];
    try {
      var res = await apiService.news.list(cate: s_cate);
      var body = jsonDecode(res.body);
      body.map((data) => items_new!.add(NewsModel.fromMap(data))).toList();
    } on HttpException catch (err) {
      EasyLoading.showError(err.message);
    } on SocketException catch (err) {
      EasyLoading.showError(err.message);
    } catch (err) {
      EasyLoading.showError('ไม่พบเนื้อหาข่าว');
    }
    notifyListeners();
  }

  Future getItemsNewHot() async {
    items_newhot = [];
    try {
      var res = await apiService.newsHot.list();
      var body = jsonDecode(res.body);
      body
          .map((data) => items_newhot!.add(NewsHotModel.fromMap(data)))
          .toList();
    } on HttpException catch (err) {
      EasyLoading.showError(err.message);
    } on SocketException catch (err) {
      EasyLoading.showError(err.message);
    } catch (err) {
      EasyLoading.showError('ไม่พบเนื้อหาข่าวมาแรง');
    }
    notifyListeners();
  }

  Future getItemsNewType() async {
    types = [];
    try {
      var res = await apiService.newsTypes.list();
      var body = jsonDecode(res.body);
      body.map((data) => types!.add(NewTypeModel.fromMap(data))).toList();
    } on HttpException catch (err) {
      EasyLoading.showError(err.message);
    } on SocketException catch (err) {
      EasyLoading.showError(err.message);
    } catch (err) {
      EasyLoading.showError('ไม่พบประเภทข่าว');
    }
    notifyListeners();
  }

  selectItem(NewsModel? item) {
    s_item = item;
    notifyListeners();
  }
}
