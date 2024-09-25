import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:kmutnb_lubray/environment.dart';
import 'package:kmutnb_lubray/model/smartroom.dart';
import 'package:kmutnb_lubray/services/room.dart';
import 'package:kmutnb_package/exception/error.dart';
import 'package:kmutnb_package/kmutnb_package.dart';
import 'package:kmutnb_package/model/default.dart';
import 'package:kmutnb_package/model/enviroment.dart';
import 'package:kmutnb_package/model/room.dart';
import 'package:kmutnb_package/model/room_booking.dart';

class RoomProvider with ChangeNotifier {
  ApiServiceModel apiService = KmutnbService.apiService(env: Environment.data);
  int step = 1;
  RoomModel? s_item;
  DefaultModel? s_time;
  List<RoomModel>? items;
  List<SmartRoomModel>? room_booking;
  DateTime s_date = DateTime.now();
  Map status = {
    '1' : 'จอง',
    '2' : 'เข้าใช้' ,
    '3' : 'walk-in (เข้่าใช้โดยไม่ได้จองล่วงหน้า)',
    '6' : 'not access จองแล้วไม่มาใช้งาน'
  };

  Future getItems({DateTime? date, String username = ""}) async {
    if (date != null) {
      s_date = date;
    }
    changeStep(index: 1);
    try {
      var res = await apiService.room.list(query: {
        "username": username,
        "date": DateFormat('yyyy-MM-dd').format(s_date)
      });
      Map<String, dynamic> body = jsonDecode(res.body);
      if (body['roomInfo']['data'] == null) {
        throw ErrorExceptionCustom(code: body['roomInfo']['status'].toString(),message: body['roomInfo']['massage']);
      }
      items = RoomService().formatDataRoom(body['roomInfo']['data']);
    } on ErrorExceptionCustom catch (err) {
      EasyLoading.showInfo(err.message,duration: Duration(seconds: 2));
    } on HttpException catch (err) {
      EasyLoading.showError(err.message,duration: Duration(seconds: 2));
    } on SocketException catch (err) {
      EasyLoading.showError(err.message,duration: Duration(seconds: 2));
    } catch (err) {
      EasyLoading.showError('เกิดข้อผิดพลาด');
    }
    notifyListeners();
  }

  booking({String? user_id}) async {
    try {
      var res = await apiService.room.create(query: {
        "timecode_id": s_time!.id,
        "room_id": s_item!.room_id.toString(),
        "bookroom_date": DateFormat("yyyy-MM-dd").format(s_date),
        "user_id": user_id
      });
      var body = jsonDecode(res.body);
      if(body['BookroomInfo'] != null){
        throw ErrorExceptionCustom(code: "204", message: "${body['BookroomInfo']['massage']}");
      }
      EasyLoading.showSuccess("สำเร็จ");
    } on ErrorExceptionCustom catch (err) {
      EasyLoading.showInfo(err.message, duration: Duration(seconds: 2));
    } on HttpException catch (err) {
      EasyLoading.showError(err.message);
    } on SocketException catch (err) {
      EasyLoading.showError(err.message);
    } catch (err) {
      EasyLoading.showError("จองไม่สำเร็จ");
    }
  }

  roomBooking({String? username}) async {
    try {
      var res = await apiService.customService.list('/LibMobile/v1/SmartRoom/History/$username',appName: ApiName.smartapp);
      print(res.request);
      Map<String, dynamic> body = jsonDecode(res.body);
      if(body['total'] < 1){
        room_booking = [];
        throw ErrorExceptionCustom(code: "204", message: "ไม่พบรายการจอง");
      }
      room_booking = [];
      body['entries'].map((data)=>room_booking!.add(SmartRoomModel.fromMap(data))).toList();
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

  Future cancel({required String bookroom_id,required String username}) async {
    try {
      await apiService.roomBooking.cancel(query: {
        "bookroom_id":bookroom_id,
        "username":username   
      });
    } on ErrorExceptionCustom catch (err) {
      EasyLoading.showError(err.message,duration: Duration(seconds: 2));
    } on HttpException catch (err) {
      EasyLoading.showError(err.message,duration: Duration(seconds: 2));
    } on SocketException catch (err) {
      EasyLoading.showError(err.message,duration: Duration(seconds: 2));
    } catch (err) {
      EasyLoading.showError('เกิดข้อผิดพลาด');
    }
    notifyListeners();
  }

  changeStep({int index = 1, RoomModel? item, DefaultModel? time}) {
    step = index;
    s_item = item;
    s_time = time;
    notifyListeners();
  }
}
