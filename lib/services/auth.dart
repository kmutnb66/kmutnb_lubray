import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kmutnb_lubray/environment.dart';
import 'package:kmutnb_package/kmutnb_package.dart';
import 'package:kmutnb_package/model/patron.dart';
import 'package:kmutnb_package/model/patronInfo.dart';
import 'package:kmutnb_package/model/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

ApiServiceModel apiService = KmutnbService.apiService(env: Environment.data);

class AuthService {

  Future setUser(String id, String token) async {
    PatronInfoModel? user;
    try {
      EasyLoading.show();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var res = await apiService.patronInfo.list(convertUsername(id));
      if (res.statusCode == 200) {
        user = PatronInfoModel.fromJson(res.body);
      }
      if (user != null && user.patron_record != null) {
        var data = user.patron_record!.last;
        if (data.barcode != null) prefs.setString('barcode', data.barcode!);
        if (data.patron_record_id != null)
          prefs.setString('patron_record_id', data.patron_record_id!);
        if (data.ptype_code != null)
          prefs.setString('ptype_code', data.ptype_code.toString());
        prefs.setString('token', token);
      }
      EasyLoading.showSuccess("ยินดีต้อนรับ");
    } on HttpException catch (err) {
      EasyLoading.showError(err.message);
    } on SocketException catch (err) {
      EasyLoading.showError(err.message);
    } catch (err) {
      EasyLoading.showError("เกิดข้อผิดพลาด");
    }
  }

  static get removeUser async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? regis_id = await FirebaseMessaging.instance.getToken();
    await apiService.patronInfo.logout(regis: regis_id!);
    prefs.clear();
  }

  Future<UserModel?> getUser({bool loading = false}) async {
    UserModel? user;
    try {
      if (loading) EasyLoading.show();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var img = await apiService.patronInfo
          .image(query: {"stdcode": prefs.getString('barcode')});
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String outputFilePath = '$appDocPath/std.jpg';
      File image = File(outputFilePath);
      var res =
          await apiService.patron.list(convertBarcode(prefs.getString('barcode')!));
      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);
        List<PatronModel> patron = [];
        body.map((item) => patron.add(PatronModel.fromMap(item))).toList();
        user = UserModel(
            image: await image.writeAsBytes(img.bodyBytes),
            token: prefs.getString('token'),
            patron: patron.last,
            patronInfo: PatronInfoList(
                barcode: prefs.getString('barcode'),
                patron_record_id: prefs.getString('patron_record_id'),
                ptype_code: double.parse(prefs.getString('ptype_code')!)));
      }
      if (loading) EasyLoading.dismiss();
    } on HttpException catch (err) {
      EasyLoading.showError(err.message);
    } on SocketException catch (err) {
      EasyLoading.showError(err.message);
    } catch (err) {
      if (loading) EasyLoading.dismiss();
    }
    return user;
  }

  String convertUsername(String id) {
    return id.replaceAll('s', '');
  }

  String convertBarcode(String id) {
    return 's$id';
  }
}
