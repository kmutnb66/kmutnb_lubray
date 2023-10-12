import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:kmutnb_lubray/services/auth.dart';
import 'package:kmutnb_package/model/user.dart';

class UserProvider with ChangeNotifier {
  AuthService authService = AuthService();
  UserModel? user;
  List<bool> toggle = [true, false];

  Future getUser({bool loading = false}) async {
    user = await authService.getUser(loading: loading);
    notifyListeners();
  }

  Future logout() async {
    await AuthService.removeUser;
    user = null;
    notifyListeners();
  }

  toggleFn(int index) {
      for (int buttonIndex = 0; buttonIndex < toggle.length; buttonIndex++) {
        if (buttonIndex == index) {
          toggle[buttonIndex] = true;
        } else {
          toggle[buttonIndex] = false;
        }
      }
    notifyListeners();
  }
}
