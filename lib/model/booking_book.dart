import 'dart:convert';


class BookingBookModel {
  String? TransactionRecId;
  String? PatronId;
  String? BibId;
  String? DateEnter;
  String? PickupLocation;
  String? NotUseAfter;
  String? Result;
  BookingBookModel({
    this.TransactionRecId,
    this.PatronId,
    this.BibId,
    this.DateEnter,
    this.PickupLocation,
    this.NotUseAfter,
    this.Result,
  });

  BookingBookModel copyWith({
    String? TransactionRecId,
    String? PatronId,
    String? BibId,
    String? DateEnter,
    String? PickupLocation,
    String? NotUseAfter,
    String? Result,
  }) {
    return BookingBookModel(
      TransactionRecId: TransactionRecId ?? this.TransactionRecId,
      PatronId: PatronId ?? this.PatronId,
      BibId: BibId ?? this.BibId,
      DateEnter: DateEnter ?? this.DateEnter,
      PickupLocation: PickupLocation ?? this.PickupLocation,
      NotUseAfter: NotUseAfter ?? this.NotUseAfter,
      Result: Result ?? this.Result,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'TransactionRecId': TransactionRecId,
      'PatronId': PatronId,
      'BibId': BibId,
      'DateEnter': DateEnter,
      'PickupLocation': PickupLocation,
      'NotUseAfter': NotUseAfter,
      'Result': Result,
    };
  }

  factory BookingBookModel.fromMap(Map<String, dynamic> map) {
    return BookingBookModel(
      TransactionRecId: map['TransactionRecId'],
      PatronId: map['PatronId'],
      BibId: map['BibId'],
      DateEnter: map['DateEnter'],
      PickupLocation: map['PickupLocation'],
      NotUseAfter: map['NotUseAfter'],
      Result: map['Result'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BookingBookModel.fromJson(String source) => BookingBookModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BookingBookModel(TransactionRecId: $TransactionRecId, PatronId: $PatronId, BibId: $BibId, DateEnter: $DateEnter, PickupLocation: $PickupLocation, NotUseAfter: $NotUseAfter, Result: $Result)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is BookingBookModel &&
      other.TransactionRecId == TransactionRecId &&
      other.PatronId == PatronId &&
      other.BibId == BibId &&
      other.DateEnter == DateEnter &&
      other.PickupLocation == PickupLocation &&
      other.NotUseAfter == NotUseAfter &&
      other.Result == Result;
  }

  @override
  int get hashCode {
    return TransactionRecId.hashCode ^
      PatronId.hashCode ^
      BibId.hashCode ^
      DateEnter.hashCode ^
      PickupLocation.hashCode ^
      NotUseAfter.hashCode ^
      Result.hashCode;
  }
}
