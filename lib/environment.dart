import 'package:flutter/foundation.dart';
import 'package:kmutnb_package/model/enviroment.dart';

class Environment { 
  static EnvironmentModel get data {
    if (kReleaseMode) {
      return EnvironmentModel(
          apiUrls: [
            "202.28.17.35",
            "udom.lib.kmutnb.ac.th",
            "smartapp.lib.kmutnb.ac.th",
            "smartroom.lib.kmutnb.ac.th",
            "app.lib.kmutnb.ac.th",
            "202.28.17.14"
          ],
          appName: 'KMUTNB Library',
          product: true,
          url:"https://food-storage.ap-south-1.linodeobjects.com/My App/Kmutnb/app-release.apk",
          version: "1.9.4");
    } else {
      return EnvironmentModel(apiUrls: [
        "202.28.17.35",
        "udom.lib.kmutnb.ac.th",
        "smartapp.lib.kmutnb.ac.th",
        "smartroom.lib.kmutnb.ac.th",
        "app.lib.kmutnb.ac.th",
        "202.28.17.14"
      ], appName: 'KMUTNB Library Dev', product: false, version: "1.0");
    }
  }
}
