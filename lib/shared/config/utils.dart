import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:myveteran/shared/config/app_localization.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:lottie/lottie.dart';

class Utils {
  factory Utils() {
    return _singleton;
  }

  static final Utils _singleton = Utils._internal();
  Utils._internal() {
    // print("Instance created Utils");
  }
  final _storage = const FlutterSecureStorage();

  //Region Screen Size and Proportional according to device
  double _screenHeight = 0;
  double _screenWidth = 0;
  double _latitude = 0;
  double _longitude = 0;
  final String _token = '';
  final String _paymentType = '';
  final String _profileRecord = '';
  
  double get screenHeight => _screenHeight;
  double get screenWidth => _screenWidth;
  double get getLatitude => _latitude;
  double get getLongitude => _longitude;
  String get token => _token;
  String get getPaymentType => _paymentType;
  String get getProfileRecord => _profileRecord;

  final double _refrenceScreenHeight = 640;
  final double _refrenceScreenWidth = 360;

  void updateScreenDimesion({double? width, double? height}) {
    _screenWidth = (width != null) ? width : _screenWidth;
    _screenHeight = (height != null) ? height : _screenHeight;
  }

  double getProportionalHeight({double? height}) {
    if (_screenHeight == 0) return height!;
    return _screenHeight * height! / _refrenceScreenHeight;
  }

  double getProportionalWidth({double? width}) {
    if (_screenWidth == 0) return width!;
    var w = _screenWidth * width! / _refrenceScreenWidth;
    return w.ceilToDouble();
  }

  double getButtonHeight({double? height}) {
    double h = height! / _refrenceScreenHeight * 40;
    return h;
  }

  void updateCurrentLocation({double? latitude, double? longitude}) {
    _latitude = (latitude != null) ? latitude : 0;
    _longitude = (longitude != null) ? longitude : 0;
  }
  //Endregion

  //Region TextStyle
  TextStyle getTextStyleRegular(
    {
      String? fontName,
      int fontSize = 12,
      Color color = Colors.black,
      bool isChangeAccordingToDeviceSize = true,
      double? characterSpacing,
      double? lineSpacing,
      FontWeight weight = FontWeight.normal,
      TextDecoration underline = TextDecoration.none,
      FontStyle? fontStyle,
      Color? bgColor,
      double? height,
    }
  ) 
  {
    double finalFontsize = fontSize.toDouble();
    if (isChangeAccordingToDeviceSize && _screenWidth != 0) {
      finalFontsize = (finalFontsize * _screenWidth) / _refrenceScreenWidth;
    }

    // print("Font size " + finalFontsize.toStringAsFixed(2));
    if (characterSpacing != null) {
      return GoogleFonts.poppins(
        // fontSize: finalFontsize,
        // fontFamily: fontName,
        color: color,
        letterSpacing: characterSpacing,
        fontWeight: weight,
        decoration: underline,
        fontStyle: fontStyle,
        backgroundColor: bgColor
      );
    } else if (lineSpacing != null) {
      return GoogleFonts.poppins(
        // fontSize: finalFontsize,
        // fontFamily: fontName,
        color: color,
        height: lineSpacing,
        fontWeight: weight,
        decoration: underline,
        fontStyle: fontStyle,
        backgroundColor: bgColor
      );
    }
    return GoogleFonts.poppins(fontSize: finalFontsize, color: color, fontWeight: weight, decoration: underline, fontStyle: fontStyle, backgroundColor: bgColor, height: height);
  }

  String getTranslated(String key, BuildContext context) {
    return AppLocalization.of(context)!.translate(key);
  }

  Widget backHeaderButton(BuildContext context, {String? type, IconData? backIcon, VoidCallback? onClick}) {
    String typeMode = type ?? 'back';
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Material(
        shape: const StadiumBorder(),
        color: Colors.white,
        child: InkWell(
          customBorder: const CircleBorder(),
          child: ClipOval(
            child: Icon(typeMode == 'back' ? backIcon ?? Icons.arrow_back_ios_outlined : Icons.close, size: 40, color: secondColor)
          ),
          onTap: () {
            if (onClick == null) {
              Navigator.pop(context, true);
            } else {
              onClick();
              Navigator.pop(context, true);
            }
          }
        )
      )
    );
  }

  Widget cirlceRippleButton(BuildContext context, {required Icon icon, @required VoidCallback? onClick, Color? color, Color? borderColor}) {
    return Container(
      height: icon.size != null ? 20 + (icon.size)! : 45,
      width: icon.size != null ? 20 + (icon.size)! : 45,
      // padding: EdgeInsets.all(7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        border: Border.all(width: 2.0, color: borderColor ?? Colors.transparent)
      ),
      child: Material(
        shape: const StadiumBorder(),
        color: color ?? Colors.grey[200],
        child: InkWell(
          customBorder: const CircleBorder(),
          child: ClipOval(
            child: icon
          ),
          onTap: onClick
        )
      )
    );
  }

  showSnackBar(BuildContext context, String message, String status) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: getTextStyleRegular(color: Colors.white, fontSize: 12)), 
      duration: const Duration(seconds: 3), backgroundColor: status == 'success' ? secondColor : Colors.red)
    );
  }

  Future<String>? getToken() async {
    String? value = await _storage.read(key: 'token');
    return value!;
  }

  Future<String>? getAccountType() async {
    String? value = await _storage.read(key: 'type');
    return value!;
  }

  String? resetToken() {
    return null;
  }

  Future<String>? getCurrentLanguage() async {
    String? value = await _storage.read(key: languageCode);
    return value!;
  }

  Future<String> networkImageToBase64(String imageUrl) async {
    http.Response response = await http.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;
    return (base64Encode(bytes) != '' ? base64Encode(bytes) : '');
  }

  Future<void> showLoadingDialog(BuildContext context, GlobalKey key) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: SimpleDialog(
            key: key,
            backgroundColor: Colors.black54,
            children: <Widget>[
              Center(
                child: Column(
                  children: <Widget>[
                    const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent)),
                    const SizedBox(height: 10),
                    Text(
                      getTranslated('pleaseWait', context),
                      style: utils.getTextStyleRegular(color: Colors.white, fontSize: 12)
                    )
                  ]
                ),
              )
            ]
          )
        );
      }
    );
  }

  Widget noDataFound(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 150,
            width: 150,
            child: Lottie.asset('assets/images/norecord.json')
          ),
          Text(utils.getTranslated('noRecord', context), style: utils.getTextStyleRegular(fontSize: 13))
        ]
      )
    );
  }
}

final utils = Utils();