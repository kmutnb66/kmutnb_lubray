

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kmutnb_lubray/provider/book.dart';
import 'package:kmutnb_lubray/provider/hold.dart';
import 'package:kmutnb_lubray/provider/user.dart';
import 'package:provider/provider.dart';

class TabBookingProvider{
  static init({required BuildContext context,int tab = 1}) async{
    HoldProvider holdProvider = Provider.of(context,listen: false);
    BookProvider bookProvider = Provider.of(context,listen: false);
    UserProvider auth = Provider.of(context,listen: false);
    switch(tab){
      case 0:
       EasyLoading.show();
       await bookProvider.getItemMybooking(patron_id: auth.user!.patronInfo!.patron_id!);
      break;
      case 1:
       await holdProvider.getHold(auth.user!.patronInfo!.patron_id);
      break;
      case 2:
       await holdProvider.getCheckOut(auth.user!.patronInfo!.patron_id);
      break;
      case 3:
       await holdProvider.getOverdue(auth.user!.patronInfo!.patron_id!);
      break;
    }
  }
}