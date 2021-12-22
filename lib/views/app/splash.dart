import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:myveteran/shared/config/utils.dart';
import 'package:myveteran/views/admin/login.dart';


class SplashState extends StatefulWidget {
  const SplashState({Key? key}) : super(key: key);
  
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<SplashState> with SingleTickerProviderStateMixin {
  final _storage = const FlutterSecureStorage();
  var _visible = true;

  AnimationController? animationController;
  Animation<double>? animation;

  startTime() async {
    var _duration = const Duration(seconds: 3);
    return Timer(_duration, _showPage);
  }

  void _showPage() async {
    String? _langCode = await _storage.read(key: languageCode) ?? languages[0].languageCode!;

    utils.getToken()!.then((String? value) {
      if (value != null) {
        Navigator.of(context).pushNamedAndRemoveUntil(layout, (Route<dynamic> route) => false);
      } else {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginState(
          languageCode: _langCode
        )), (route) => false);
        // Navigator.of(context).pushNamedAndRemoveUntil(login, (Route<dynamic> route) => false);
      }
    }).catchError((onError) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginState(
        languageCode: _langCode
      )), (route) => false);
      // Navigator.of(context).pushNamedAndRemoveUntil(login, (Route<dynamic> route) => false);
    });
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    animation = CurvedAnimation(parent: animationController!, curve: Curves.easeOut);

    animation?.addListener(() => setState(() {}));
    animationController?.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  void dispose() {
    animationController?.dispose();
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
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bglogin.png"),
                  fit: BoxFit.cover,
                ),
              )
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Image.asset(
                        "assets/images/logo.png",
                        width: animation!.value * 100,
                        height: animation!.value * 150,
                      )
                    ),
                    const SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'MyVeteran',
                          style: utils.getTextStyleRegular(color: mainColor, fontSize: 26, weight: FontWeight.w700),
                        ),
                        Text(
                          'Jabatan Hal Ehwal Veteran ATM',
                          style: utils.getTextStyleRegular(color: Colors.black87, fontSize: 13),
                        )
                      ],
                    )
                  ]
                )
                // new Image.asset(
                //   "assets/images/logo.png",
                //   width: animation.value * 250,
                //   height: animation.value * 250,
                // ),
              ],
            )
          ],
        )
      ),
    );
  }
}