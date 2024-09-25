import 'dart:convert';

import 'package:kmutnb_package/model/book.dart';

class CirculationModel {
  String? checkout_gmt;
  String? checkin_gmt;
  String? outDate;
  String? dueDate;
  String? last_checkin_gmt;
  String? last_checkout_gmt;
  String? barcode;
  String? best_title;
  String? best_author;
  String? publish_year;
 BookBibModel? bib;
  CirculationModel({
    this.checkout_gmt,
    this.checkin_gmt,
    this.outDate,
    this.dueDate,
    this.last_checkin_gmt,
    this.last_checkout_gmt,
    this.barcode,
    this.best_title,
    this.best_author,
    this.publish_year,
    this.bib,
  });

  CirculationModel copyWith({
    String? checkout_gmt,
    String? checkin_gmt,
    String? outDate,
    String? dueDate,
    String? last_checkin_gmt,
    String? last_checkout_gmt,
    String? barcode,
    String? best_title,
    String? best_author,
    String? publish_year,
    BookBibModel? bib,
  }) {
    return CirculationModel(
      checkout_gmt: checkout_gmt ?? this.checkout_gmt,
      checkin_gmt: checkin_gmt ?? this.checkin_gmt,
      outDate: outDate ?? this.outDate,
      dueDate: dueDate ?? this.dueDate,
      last_checkin_gmt: last_checkin_gmt ?? this.last_checkin_gmt,
      last_checkout_gmt: last_checkout_gmt ?? this.last_checkout_gmt,
      barcode: barcode ?? this.barcode,
      best_title: best_title ?? this.best_title,
      best_author: best_author ?? this.best_author,
      publish_year: publish_year ?? this.publish_year,
      bib: bib ?? this.bib,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'checkout_gmt': checkout_gmt,
      'checkin_gmt': checkin_gmt,
      'outDate': outDate,
      'dueDate': dueDate,
      'last_checkin_gmt': last_checkin_gmt,
      'last_checkout_gmt': last_checkout_gmt,
      'barcode': barcode,
      'best_title': best_title,
      'best_author': best_author,
      'publish_year': publish_year,
      'bib': bib?.toMap(),
    };
  }

  factory CirculationModel.fromMap(Map<String, dynamic> map) {
    return CirculationModel(
      checkout_gmt: map['checkout_gmt'],
      checkin_gmt: map['checkin_gmt'],
      outDate: map['outDate'],
      dueDate: map['dueDate'],
      last_checkin_gmt: map['last_checkin_gmt'],
      last_checkout_gmt: map['last_checkout_gmt'],
      barcode: map['barcode'],
      best_title: map['best_title'],
      best_author: map['best_author'],
      publish_year: map['publish_year'],
      bib: map['bib'] != null ? BookBibModel.fromMap(map['bib']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CirculationModel.fromJson(String source) => CirculationModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CirculationModel(checkout_gmt: $checkout_gmt, checkin_gmt: $checkin_gmt, outDate: $outDate, dueDate: $dueDate, last_checkin_gmt: $last_checkin_gmt, last_checkout_gmt: $last_checkout_gmt, barcode: $barcode, best_title: $best_title, best_author: $best_author, publish_year: $publish_year, bib: $bib)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CirculationModel &&
      other.checkout_gmt == checkout_gmt &&
      other.checkin_gmt == checkin_gmt &&
      other.outDate == outDate &&
      other.dueDate == dueDate &&
      other.last_checkin_gmt == last_checkin_gmt &&
      other.last_checkout_gmt == last_checkout_gmt &&
      other.barcode == barcode &&
      other.best_title == best_title &&
      other.best_author == best_author &&
      other.publish_year == publish_year &&
      other.bib == bib;
  }

  @override
  int get hashCode {
    return checkout_gmt.hashCode ^
      checkin_gmt.hashCode ^
      outDate.hashCode ^
      dueDate.hashCode ^
      last_checkin_gmt.hashCode ^
      last_checkout_gmt.hashCode ^
      barcode.hashCode ^
      best_title.hashCode ^
      best_author.hashCode ^
      publish_year.hashCode ^
      bib.hashCode;
  }
}
