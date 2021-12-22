import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myveteran/core/provider/localization_provider.dart';
import 'package:myveteran/core/services/admin/auth_service.dart';
import 'package:myveteran/core/services/user/user_service.dart';
import 'package:myveteran/shared/components/custom_button/button_round.dart';
import 'package:myveteran/shared/components/misc/animated_toggle.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myveteran/shared/config/environment.dart';
import 'dart:ui';
import 'package:myveteran/shared/config/utils.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

class LoginState extends StatefulWidget {
  final String? languageCode;

  const LoginState({Key? key, this.languageCode}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginState> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  final _storage = const FlutterSecureStorage();

  TextEditingController getMyCardNo = TextEditingController();
  TextEditingController getPassword = TextEditingController();

  bool _hasValidate = true, _showPassword = false;

  AuthService? _authService;
  UserService? _userService;

  @override
  void initState() {
    super.initState();
    
    _authService = AuthService();
    _userService = UserService();

    getMyCardNo = TextEditingController(text: '');
    getPassword = TextEditingController(text: '');
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
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).padding.top,
              // color: mainColor,
              // child: CustomPaint(painter: CurvePainter(heightSize: MediaQuery.of(context).size.height - 40))
            ),
            _loginPanel()
          ] /* add child content here */,
        ),
      )
    );
  }

  Widget _loginPanel() {
    double _hApp = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double _hLogo = (_hApp * 0.3);
    double _hForm = (_hApp * 0.3);
    double _hFooter = (_hApp * 0.4);

    return Center(
      child: ListView(
        children: <Widget>[
          Container(
            height: _hLogo,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            constraints: BoxConstraints(maxHeight: _hLogo),
            child: Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 12.0, color: Color(0xFFc2aa92)),
                    ),
                    color: Colors.white,
                  ),
                ),
                Container(
                  alignment: Alignment.topRight,
                  child: AnimatedToggle(
                    values: const ['BM', 'ENG'],
                    initialPosition: widget.languageCode == 'ms' ? true : false,
                    onToggleCallback: (idx) {
                      setState(() {
                        // print('value $_idx');
                        // _toggleValue = idx;
                        Provider.of<LocalizationProvider>(context, listen: false).setLanguage(Locale(
                          languages[idx].languageCode!,
                          languages[idx].countryCode!,
                        ));
                      });
                    },
                    buttonColor: const Color(0xFFc2aa92),
                    backgroundColor: const Color(0xFFcacaca),
                    textColor: const Color(0xFFFFFFFF),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/images/logo.png",
                        height: 80,
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
              ]
            )
          ),
          Container(
            height: _hForm,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              // decoration: BoxDecoration(
              //   borderRadius: const BorderRadius.all(Radius.circular(15)),
              //   border: Border.all(width: 1.0, color: (Colors.grey[300])!)
              // ),
              child: Column(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: getMyCardNo,
                          textAlign: TextAlign.left,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(15),
                            FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\d{0,2}')),
                          ],
                          style: utils.getTextStyleRegular(fontSize: 14),
                          decoration: InputDecoration(
                            // counterText: '',
                            labelText: utils.getTranslated('icNo', context),
                            labelStyle: utils.getTextStyleRegular(fontSize: 14),
                            suffixIcon: const Icon(CupertinoIcons.doc_richtext, color: mainColor)
                          ),
                          maxLength: 15,
                          validator: _validateCardNo,
                          onSaved: (String? value) {
                            setState(() {
                              getMyCardNo.text = (value)!;
                            });
                          },
                        ),
                        TextFormField(
                          controller: getPassword,
                          textAlign: TextAlign.left,
                          style: utils.getTextStyleRegular(fontSize: 14),
                          decoration: InputDecoration(
                            counterText: '',
                            labelText: utils.getTranslated('password', context),
                            labelStyle: utils.getTextStyleRegular(fontSize: 14),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                _togglePassword();
                              },
                              child: Icon(
                                _showPassword ? CupertinoIcons.eye : CupertinoIcons.eye_slash, color: mainColor),
                            )
                          ),
                          obscureText: !_showPassword,
                          validator: _validatePassword,
                          onSaved: (String? value) {
                            setState(() {
                              getPassword.text = (value)!;
                            });
                          },
                        )
                      ]
                    )
                  )
                ]
              )
            ),
          ),
          SizedBox(
            height: _hFooter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  child: Text(
                    utils.getTranslated('forgetPassword', context) + '?',
                    style: utils.getTextStyleRegular(fontSize: 14, color: Colors.black54, weight: FontWeight.w700, underline: TextDecoration.underline)
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(forgetPassword);
                  }
                ),
                ButtonRound(
                  btnName: utils.getTranslated('login', context),
                  borderColor: Colors.white,
                  btnColor: secondColor,
                  colorTitle: Colors.white,
                  iconBtn: Icon(Icons.login, size: 20, color: Colors.yellow[600]),
                  onSubmit: () {
                    _submitLogin();
                  }
                ),
                const SizedBox(height: 70),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.person_add_alt_1_rounded, size: 25, color: mainColor),
                    TextButton(
                      child: Text(
                        utils.getTranslated('firstTimeUser', context) + '?',
                        style: utils.getTextStyleRegular(fontSize: 14, color: mainColor)
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(firstRegister);
                      }
                    )
                  ],
                ),
                Text(utils.getTranslated('version', context) + ': 1.0.6 (' + Environment.location + ')', style: utils.getTextStyleRegular(fontSize: 13, color: Colors.black45)), //app_version
                const SizedBox(height: 20),
              ]
            )
          )
        ]
      ),
    );
  }

  String? _validateCardNo(String? value) {
    if (value?.length as int < 11) {
      return utils.getTranslated('icNoErrorMsg', context);
    } else {
      return null;
    }
  }

  String? _validatePassword(String? value) {
    if (value == '') {
      return utils.getTranslated('passwordErrorMsg', context);
    } else {
      return null;
    }
  }

  void _submitLogin() {
    setState(() {
      _hasValidate = false;
    });
    if (_formKey.currentState!.validate()) {
      // No any error in validation
      _formKey.currentState!.save();
      setState(() {
        _hasValidate = true;
      });
      
      utils.showLoadingDialog(context, _keyLoader);
      // Future.delayed(const Duration(seconds: 3), () async {
      //   Navigator.of(_keyLoader.currentContext!).pop();
      //   if (getMyCardNo.text == '12345678901') {
      //     await _storage.write(key: 'token', value: 'tokenabc123test');
      //     await _storage.write(key: 'type', value: '1');
      //     Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(layout, (Route<dynamic> route) => false);
      //   } else if (getMyCardNo.text == '12345678902') {
      //     await _storage.write(key: 'token', value: 'tokenabc123test');
      //     await _storage.write(key: 'type', value: '2');
      //     Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(layout, (Route<dynamic> route) => false);
      //   } else {
      //     utils.showSnackBar(context, 'Log masuk tidak berjaya', 'fail');
      //   }
      // });
      Map _input = {
        'grant_type': 'password',
        'username': getMyCardNo.text,
        'password': getPassword.text
      };

      _authService?.authUserLogin(body: _input).then((respLogin) {
        debugPrint('respLogin 1 ${respLogin.accessToken}');

        if (respLogin.accessToken!.isNotEmpty) {
          _userService?.fetchUserProfileData(token: respLogin.accessToken).then((respInfo) async {
            Navigator.of(_keyLoader.currentContext!).pop();

            if (respInfo.userNo!.isNotEmpty) {
              await _storage.write(key: 'token', value: respLogin.accessToken);
              await _storage.write(key: 'type', value: respInfo.userType == 'Veteran Berpencen' ? '1' : '2');
              Map<String, dynamic> _userInfo = {
                'fullname': respInfo.personIdentidyName,
                'identidyId': respInfo.personIdentidyID
              };
              await _storage.write(key: 'userInfo', value: json.encode(_userInfo));
              Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(layout, (Route<dynamic> route) => false);
            } else {
              utils.showSnackBar(context, 'Log masuk tidak berjaya', 'fail');
            }
          }).catchError((onError) {
            Navigator.of(_keyLoader.currentContext!).pop();
            utils.showSnackBar(context, 'Log masuk tidak berjaya', 'fail');
          });
        } else {
          Navigator.of(_keyLoader.currentContext!).pop();
          utils.showSnackBar(context, 'Log masuk tidak berjaya', 'fail');
        }
      }).catchError((onError) {
        // print('errrr $onError');
        Navigator.of(_keyLoader.currentContext!).pop();
        utils.showSnackBar(context, 'Log masuk tidak berjaya', 'fail');
      });
    } else {
      debugPrint('have error');
    }
  }

  void _togglePassword() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }
}