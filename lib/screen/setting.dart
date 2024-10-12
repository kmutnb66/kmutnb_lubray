import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kmutnb_lubray/environment.dart';
import 'package:kmutnb_lubray/provider/user.dart';
import 'package:kmutnb_lubray/screen/auth/login.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingView extends StatefulWidget {
  const SettingView();

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> with WidgetsBindingObserver {
  bool? status_notification;
  FirebaseMessaging _messaging = FirebaseMessaging.instance;
  List krod = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    getStatusPermision();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  getStatusPermision() async {
    PermissionStatus? permissionStatus =
        await Permission.notification.request();
    status_notification = permissionStatus.isGranted;
    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      getStatusPermision();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'ตั้งค่า',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Icon(
                    Icons.notifications,
                    size: 40,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    'การแจ้งเตือน',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Switch.adaptive(
                    value: status_notification == null
                        ? true
                        : status_notification!,
                    onChanged: (newValue) async {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: Text('ขออนุญาติการใช้สิทธิ์'),
                                content: Text(
                                    'คุณต้องการตั้งค่าการแจ้งเตือนหรือไม่\nจะนำพาไปที่หน้าต้งค่า'),
                                actions: [
                                  RaisedButton(
                                    onPressed: () {
                                      openAppSettings();
                                      Navigator.pop(context);
                                    },
                                    color: Colors.orange,
                                    child: Text(
                                      'ตกลง',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('ยกเลิก'),
                                  )
                                ],
                              ));
                    },
                  )
                ],
              ),
            ),
            Divider(
              thickness: 3,
            ),
            InkWell(
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          content: SingleChildScrollView(
                            child: Column(
                              children: [
                                Text(
                                    'AppName: ${Environment.data.appName}\b Version: ${Environment.data.version}\nแอปพลิเคชั่นนี้ จัดทำขึ้นเพื่อเป็นปริญญานิพนธ์ของนักศึกษา สาขาการจัดการเทคโนโลยีการผลิตและสารสนเทศ (IPTM) มหาวิทยาลัยเทคโนโลยีพระจอมเกล้าพระนครเหนือ กรุงเทพฯ')
                              ],
                            ),
                          ),
                        ));
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 40,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      'เกี่ยวกับ',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
                 Divider(
              thickness: 3,
            ),
            InkWell(
              onTap: () async {
                EasyLoading.show();
                try {
                  await launch(Uri.parse(Environment.data.url!).toString());
                  EasyLoading.dismiss();
                } catch (err) {
                  EasyLoading.showInfo("อัพเดทไม่ได้");
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.update,
                      size: 40,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      'อัพเดท',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 3,
            ),
            InkWell(
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text('ต้องการออกจากระบบ?'),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('กลับ')),
                          TextButton(
                              onPressed: () {
                                UserProvider provider =
                                    Provider.of(context, listen: false);
                                provider.logout();
                                MaterialPageRoute route =
                                    MaterialPageRoute(builder: (_) => Login());
                                Navigator.pushAndRemoveUntil(
                                    context, route, (route) => false);
                              },
                              child: Text(
                                'ออกจากระบบ',
                                style: TextStyle(color: Colors.red),
                              )),
                        ],
                      );
                    });
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      size: 40,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      'ออกจากระบบ',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
