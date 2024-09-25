import 'dart:convert';

class SmartRoomModel {
  String? bookroom_id;
  String? room_name;
  String? bookroom_date;
  String? timecode_name;
  String? status;
  SmartRoomModel({
    this.bookroom_id,
    this.room_name,
    this.bookroom_date,
    this.timecode_name,
    this.status,
  });
  

  SmartRoomModel copyWith({
    String? bookroom_id,
    String? room_name,
    String? bookroom_date,
    String? timecode_name,
    String? status,
  }) {
    return SmartRoomModel(
      bookroom_id: bookroom_id ?? this.bookroom_id,
      room_name: room_name ?? this.room_name,
      bookroom_date: bookroom_date ?? this.bookroom_date,
      timecode_name: timecode_name ?? this.timecode_name,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookroom_id': bookroom_id,
      'room_name': room_name,
      'bookroom_date': bookroom_date,
      'timecode_name': timecode_name,
      'status': status,
    };
  }

  factory SmartRoomModel.fromMap(Map<String, dynamic> map) {
    return SmartRoomModel(
      bookroom_id: map['bookroom_id'],
      room_name: map['room_name'],
      bookroom_date: map['bookroom_date'],
      timecode_name: map['timecode_name'],
      status: map['status'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SmartRoomModel.fromJson(String source) => SmartRoomModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SmartRoomModel(bookroom_id: $bookroom_id, room_name: $room_name, bookroom_date: $bookroom_date, timecode_name: $timecode_name, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is SmartRoomModel &&
      other.bookroom_id == bookroom_id &&
      other.room_name == room_name &&
      other.bookroom_date == bookroom_date &&
      other.timecode_name == timecode_name &&
      other.status == status;
  }

  @override
  int get hashCode {
    return bookroom_id.hashCode ^
      room_name.hashCode ^
      bookroom_date.hashCode ^
      timecode_name.hashCode ^
      status.hashCode;
  }
}
