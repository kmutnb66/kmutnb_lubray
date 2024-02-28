
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kmutnb_lubray/provider/ebok.dart';
import 'package:kmutnb_lubray/screen/auth/account.dart';
import 'package:kmutnb_lubray/screen/documents/documents.dart';
import 'package:kmutnb_lubray/screen/home.dart';
import 'package:kmutnb_lubray/screen/menu.dart';
import 'package:kmutnb_lubray/screen/setting.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  int? page;
  int inpage;
  MainScreen({this.page, this.inpage = -1});
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController? _pageController;
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: <Widget>[HomeView(), DocumentsView(),AccountView(),MensuView(),SettingView()],
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          child: Container(
            height: 60,
            child: Stack(
              clipBehavior: Clip.none,
              overflow: Overflow.visible,
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 122, 0, .35),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5))),
                  width: double.infinity,
                  height: 38,
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: InkWell(
                    child: Image.asset(
                      'assets/icon/home.png',
                      width: 60,
                    ),
                    onTap: () => _pageController?.jumpToPage(0),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 90,
                  child: InkWell(
                    child: Image.asset(
                      'assets/icon/ebok.png',
                      width: 60,
                    ),
                    onTap: () => _pageController?.jumpToPage(1),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  child: InkWell(
                    child: Image.asset(
                      'assets/icon/scan_me.png',
                      width: 80,
                    ),
                    onTap: () => _pageController?.jumpToPage(2),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 90,
                  child: InkWell(
                    child: Image.asset(
                      'assets/icon/list.png',
                      width: 65,
                    ),
                    onTap: () => _pageController?.jumpToPage(3),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: InkWell(
                    child: Image.asset(
                      'assets/icon/setting.png',
                      width: 60,
                    ),
                    onTap: () => _pageController?.jumpToPage(4),
                  ),
                )
              ],
            ),
          ),
          color: Color.fromRGBO(0, 0, 0, 0),
          // shape: CircularNotchedRectangle(),
        ),
      ),
    );
  }

  void navigationTapped(int page) {
    _pageController?.jumpToPage(page);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController?.dispose();
  }

  void onPageChanged(int page) async {
    setState(() {
      this._page = page;
    });
    if (page == 1) {
      EasyLoading.show();
      EBookProvider provider = Provider.of(context, listen: false);
      await provider.getItems(reflash: true);
      EasyLoading.dismiss();
    }
  }
}
