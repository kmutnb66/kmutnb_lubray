
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kmutnb_lubray/environment.dart';
import 'package:kmutnb_package/kmutnb_package.dart';
import 'package:kmutnb_package/model/itemList.dart';


class ItemListProvider with ChangeNotifier{
  ApiServiceModel apiService = KmutnbService.apiService(env: Environment.data);
  ItemListModel? items;
 

    Future getItems(String id)async{
      EasyLoading.show();
      try{
        var res = await apiService.itemList.object(bib_id: id);
        switch (res.statusCode) {
          case 200:
            items = ItemListModel.fromJson(res.body);
            EasyLoading.dismiss();
            break;
          case 204:
            EasyLoading.showError('ไม่พบข้อมูล');
            break;
          default:
            EasyLoading.showError('เกิดข้อผิดพลาด');
            break;
        }
      }catch(err){
        EasyLoading.showError('เกิดข้อผิดพลาด');
      }
      notifyListeners();
    }


}