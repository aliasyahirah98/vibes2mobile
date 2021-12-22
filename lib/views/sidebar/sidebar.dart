import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myveteran/core/services/medical/medical_service.dart';
import 'package:myveteran/shared/components/dialog/direct_dialog.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/environment.dart';
import 'package:myveteran/shared/config/utils.dart';
import 'package:myveteran/views/admin/login.dart';
import 'package:myveteran/views/sidebar/qr_attendant/qr_attendant.dart';
import 'package:myveteran/views/sidebar/settings/settings.dart';
import 'package:myveteran/views/web_portal/portal_link/portal_link_direct.dart';
import 'dart:convert';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class SidebarState extends StatefulWidget {
  const SidebarState({Key? key}) : super(key: key);
  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<SidebarState> {
  final _storage = const FlutterSecureStorage();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  String? _token;
  Map<String, dynamic>? _user;
  String? _userType;
  String _scanQrCode = 'Unknown';

  MedicalService? _medicalService;

  @override
  void initState() {
    super.initState();

    _medicalService = MedicalService();

    utils.getToken()!.then((value) {
      _token = value;
      // debugPrint('token $_token');
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        // For Android.
        // Use [light] for white status bar and [dark] for black status bar.
        statusBarIconBrightness: Brightness.dark,
        // For iOS.
        // Use [dark] for white status bar and [light] for black status bar.
        statusBarBrightness: Brightness.light,
      ),
      child: Drawer(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  FutureBuilder<dynamic>(
                    future: _getUserInfo(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        _user = snapshot.data;
                        
                        return Column(
                          children: <Widget>[
                            UserAccountsDrawerHeader(
                              accountName: Text(_user!['fullname'] ?? '-', style: utils.getTextStyleRegular(fontSize: 18, color: secondColor, weight: FontWeight.w700)),
                              accountEmail: Text(_userType == '1' ? utils.getTranslated('veteranPension', context) : utils.getTranslated('dependent', context), style: utils.getTextStyleRegular(fontSize: 14, color: Colors.black)),
                              margin: const EdgeInsets.all(0),
                              currentAccountPicture: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: ClipOval(
                                  child: Image.network(
                                    'https://www.occrp.org/assets/common/staff/male.png',
                                    fit: BoxFit.cover,
                                    width: 90,
                                    height: 90,
                                  ),
                                ),
                              ),
                              decoration: const BoxDecoration(
                                color: Color(0xFFD2D2D2),
                                // image: DecorationImage(
                                //   fit: BoxFit.fill,
                                //   image: NetworkImage('https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')
                                // ),
                              )
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 10,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
                                ),
                                color: const Color(0xFFC2AA92),
                              )
                            )
                          ]
                        );
                      }
                      return Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 180,
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Color(0xFFD2D2D2)
                            ),
                            child: const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(secondColor)))
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 10,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
                              ),
                              color: const Color(0xFFC2AA92),
                            )
                          )
                        ]
                      );
                    }
                  ),
                  // SizedBox(
                  //   height: 130,
                  //   child: DrawerHeader(
                  //     child: Container(
                  //       padding: const EdgeInsets.all(20),
                  //       alignment: Alignment.topRight,
                  //       child: Container(
                  //         height: 60,
                  //         width: 60,
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(100.0),
                  //           border: Border.all(width: 2.0, color: Colors.transparent)
                  //         ),
                  //         child: Material(
                  //           shape: const StadiumBorder(),
                  //           color: Colors.transparent,
                  //           child: InkWell(
                  //             customBorder: const CircleBorder(),
                  //             child: const Icon(CupertinoIcons.xmark, color: secondColor, size: 40),
                  //             onTap: () => {
                  //               Navigator.of(context).pop()
                  //             }
                  //           )
                  //         )
                  //       )
                  //     )
                  //   )
                  // ),
                  _sidebarItem(icon: CupertinoIcons.bell_fill, notif: 2, text: utils.getTranslated('notification', context), onTap: () {
                    Navigator.of(context).pushNamed(notifications);
                  }),
                  _sidebarItem(icon: CupertinoIcons.person_2_square_stack_fill, text: utils.getTranslated('feedbacks', context), onTap: () {
                    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => PortalLinkDirectState(
                      pageName: utils.getTranslated('feedbacks', context), linkUrl: 'https://vibes.jhev.gov.my/portal/aduannnewiframe.asp')
                    ));
                  }),
                  _sidebarItem(icon: CupertinoIcons.chat_bubble_2_fill, text: utils.getTranslated('frequentlyAskedQuestions', context), onTap: () {
                    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => PortalLinkDirectState(
                      pageName: utils.getTranslated('frequentlyAskedQuestions', context), linkUrl: 'https://www.jhev.gov.my/soalan-lazim')
                    ));
                  }),
                  _sidebarItem(icon: CupertinoIcons.calendar_today, text: utils.getTranslated('calendar', context), onTap: () {
                    Navigator.of(context).pushNamed(calendar);
                  }),
                  _sidebarItem(icon: CupertinoIcons.layers_alt_fill, text: utils.getTranslated('heroCampaign', context), onTap: () {
                    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => PortalLinkDirectState(
                      pageName: utils.getTranslated('heroCampaign', context), linkUrl: 'https://tabungpahlawan.jhev.gov.my/')
                    ));
                  }),
                  _sidebarItem(icon: CupertinoIcons.qrcode_viewfinder, text: utils.getTranslated('dialysisCentreCheckIn', context), onTap: () {
                    _scanQR();
                  }),
                  _sidebarItem(icon: CupertinoIcons.gear_alt_fill, text: utils.getTranslated('settings', context), onTap: () async {
                    String? _langCode = await _storage.read(key: languageCode);
                    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => SettingsState(
                      languageCode: _langCode ?? languages[0].languageCode!
                    )));
                  }),
                  _sidebarItem(icon: CupertinoIcons.square_arrow_right_fill, text: utils.getTranslated('logout', context), onTap: () async {
                    String? _langCode = await _storage.read(key: languageCode);
                    await _storage.deleteAll();
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginState(
                      languageCode: _langCode ?? languages[0].languageCode!
                    )), (route) => false);
                    // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => LoginState(
                    //   languageCode: _langCode ?? languages[0].languageCode!
                    // )));
                    // Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(login, (Route<dynamic> route) => false);
                  })  
                ]
              )
            ),
            Container(
              padding: const EdgeInsets.only(left: 10, bottom: 8),
              child: Align(
                alignment: FractionalOffset.bottomLeft,
                child: Text(utils.getTranslated('version', context) + ': 1.0.6 (' + Environment.location + ')', style: utils.getTextStyleRegular(fontSize: 13, color: Colors.black45)) //app_version
              )
            )
          ],
        ),
      )
    );
  }

  Widget _sidebarItem({IconData? icon, String? text, int? notif = 0, GestureTapCallback? onTap}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
        title: Container(
          height: 40,
          alignment: Alignment.center,
          child: Stack(
            children: <Widget>[
              Row(
                children: <Widget>[
                  const SizedBox(width: 20),
                  Icon(icon, color: text == 'Log Keluar' || text == 'Log Out' ? alertColor : secondColor, size: 20),
                  Container(
                    width: 200,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      text!,
                      style: utils.getTextStyleRegular(fontSize: 14, color: text == 'Log Keluar' || text == 'Log Out' ? alertColor : Colors.black87),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
              Positioned(
                left: 30.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: notif != 0 ? const BoxDecoration(
                    color: alertColor,
                    shape: BoxShape.circle,
                  ) : null,
                  child: notif != 0 ? Text(
                    '$notif',
                    style: utils.getTextStyleRegular(fontSize: 10, color: Colors.white),
                  ) : Container(),
                ),
              ),
            ],
          )
        ),
        onTap: onTap,
      )
    );
  }

  // Future<dynamic>? _getUserType() async {
  //   final token = await _storage.read(key: 'type');
  //   return token;
  // }

  // Future<dynamic>? _getUserInfo() async {
  //   final type = await _storage.read(key: 'type');
  //   _userType = type;

  //   final token = await _storage.read(key: 'token');
  //   final result = await _userService!.fetchUserProfile(token: token).then((response) {
  //     return response;
  //   }).catchError((onError) {
  //     debugPrint('onError $onError');
  //   });
  //   return result;
  // }

  Future<dynamic>? _getUserInfo() async {
    final type = await _storage.read(key: 'type');
    _userType = type;

    final userInfo = await _storage.read(key: 'userInfo');
    return json.decode(userInfo!);
  }

  Future<void>? _scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.QR
      );
      debugPrint('barcodeScanRes $barcodeScanRes');

    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanQrCode = barcodeScanRes;
    });

    Map _body = {
      'OrganisationId': _scanQrCode
    };

    utils.showLoadingDialog(context, _keyLoader);
    _medicalService?.applyAttendanceData(token: _token, body: _body).then((response) {
      Navigator.of(_keyLoader.currentContext!).pop();

      // if (response.returnCode == 200) {
        // utils.showSnackBar(context, response.responseMessage!, 'success');
        
        showDialog(
          barrierColor: Colors.transparent.withOpacity(0.3),
          context: context,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () {
                return Future(() => true);
              },
              child: DirectDialogState(
                title: utils.getTranslated('message', context),
                messages: _scanQrCode + ' ' + response.responseMessage!,
                buttonName: 'OK',
                onCallback: () {
                  Navigator.of(context).pop();
                }
              )
            );
          }
        );
      // } else {
      //   utils.showSnackBar(context, response.responseMessage!, 'fail');
      // }
    }).catchError((onError) {
      debugPrint('errrr medical attendance $onError');
      Navigator.of(_keyLoader.currentContext!).pop();
      utils.showSnackBar(context, 'Network server error', 'fail');
    });

    // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => QrAttendantState(
    //   qrValue: _scanQrCode)
    // ));
  }
}