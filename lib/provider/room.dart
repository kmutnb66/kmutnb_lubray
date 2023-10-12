import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:kmutnb_lubray/environment.dart';
import 'package:kmutnb_lubray/services/room.dart';
import 'package:kmutnb_package/exception/error.dart';
import 'package:kmutnb_package/kmutnb_package.dart';
import 'package:kmutnb_package/model/default.dart';
import 'package:kmutnb_package/model/room.dart';
import 'package:kmutnb_package/model/room_booking.dart';

class RoomProvider with ChangeNotifier {
  ApiServiceModel apiService = KmutnbService.apiService(env: Environment.data);
  int step = 1;
  RoomModel? s_item;
  DefaultModel? s_time;
  List<RoomModel>? items;
  List<RoomBookingModel>? room_booking;
  DateTime s_date = DateTime.now();

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
      EasyLoading.showInfo(err.message);
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

  booking({String? user_id}) async {
    try {
      var res = await apiService.room.create(query: {
        "timecode_id": s_time!.id,
        "room_id": s_item!.room_id.toString(),
        "bookroom_date": DateFormat("yyyy-MM-dd").format(s_date),
        "user_id": user_id
      });
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
      var res = await apiService.roomBooking.list(query: {
        "username": username,
      });
      Map<String, dynamic> body = jsonDecode(res.body);
      room_booking = RoomService().formatDataBooking(body['MyRoom']);
    } on HttpException catch (err) {
      EasyLoading.showError(err.message);
    } on SocketException catch (err) {
      EasyLoading.showError(err.message);
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
