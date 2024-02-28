

import 'package:kmutnb_package/model/room.dart';
import 'package:kmutnb_package/model/room_booking.dart';

class RoomService {
  List<RoomModel>? formatDataRoom(Map<String, dynamic> data) {
    List<RoomModel> rooms = [];
    try {
      data.forEach((key,value) {
        value.forEach((_key, _value) {
          rooms.add(RoomModel(
            date: key,
            room_id:_value['room_id'].toInt(),
            room_name: _value['room_name'],
            room_description: _value['room_description'],
            full: checkFulltime(_value['time']),
            time: formatTime(_value['time'])
          ));
        });
      });
      return rooms;
    } catch (err) {
      return null;
    }
  }

   List<RoomBookingModel>? formatDataBooking(Map<String, dynamic> data) {
    List<RoomBookingModel> rooms = [];
    try {
      data.forEach((key,value) {
        value.forEach((_key, _value) {
          _value.forEach((time,room_number){
            rooms.add(RoomBookingModel(
            id: _key,
            date: key,
            time: time,
            room_number: room_number
          ));
          });
        });
      });
      return rooms;
    } catch (err) {
      return null;
    }
  }

  bool checkFulltime(dynamic time){
    try{
      if(time == "Full"){
        return true;
      }else{
        return false;
      }
    }catch(err){
      return false;
    }
  }

  Map<String,dynamic> formatTime(dynamic time){
    try{
      return time;
    }catch(err){
      return {};
    }
  }

}
