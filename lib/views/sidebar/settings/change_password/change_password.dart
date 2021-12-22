import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:myveteran/core/services/user/user_service.dart';
import 'package:myveteran/shared/components/custom_button/button_round.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:flutter/material.dart';
import 'package:myveteran/shared/config/utils.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChangePasswordState extends StatefulWidget {
  const ChangePasswordState({Key? key}) : super(key: key);
  
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePasswordState> {
  final _storage = const FlutterSecureStorage();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  TextEditingController getCurrentPassword = TextEditingController();
  TextEditingController getNewPassword = TextEditingController();
  bool? _invalidPassword, _showCurrentPassword = false, _showNewPassword = false, _showMatchPassword = false;

  UserService? _userService;
  String? _token;
  Map<String, dynamic>? _user;

  @override
  void initState() {
    super.initState();

    _userService = UserService();

    utils.getToken()!.then((value) {
      _token = value;

      _getUserInfo()!.then((record) {
        _user = record;
      });
    });
    
    getCurrentPassword = TextEditingController(text: '');
    getNewPassword = TextEditingController(text: '');
    _invalidPassword = false;
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          leading: utils.backHeaderButton(context, type: 'close'),
          brightness: Brightness.light,
          elevation: 0.0,
          title: const Text(''),
          backgroundColor: Colors.white
        ),
        body: _changePasswordForm(),
        bottomNavigationBar: Container(
          height: 90,
          decoration: BoxDecoration(
          // color: Colors.red,
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10)
            )
          ),
          child: ButtonRound(
            width: MediaQuery.of(context).size.width - 30,
            btnName: utils.getTranslated('save', context),
            borderColor: Colors.white,
            btnColor: secondColor,
            colorTitle: Colors.white,
            iconBtn: Icon(CupertinoIcons.chevron_right_circle_fill, size: 20, color: Colors.yellow[600]),
            onSubmit: () {
              debugPrint('print simpan');
              _submitChangePassword();
            }
          ),
        )
      )
    );
  }

  Widget? _changePasswordForm() {
    double _hApp = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double _hTop = (_hApp * 0.07);
    double _hForm = (_hApp * 0.7);
    // double _hFooter = (_hApp * 0.2);

    return Center(
      child: ListView(
        children: <Widget>[
          Container(
            height: _hTop,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            constraints: BoxConstraints(maxHeight: _hTop),
            alignment: Alignment.center,
            child: Text(
              utils.getTranslated('changePassword', context),
              style: utils.getTextStyleRegular(color: mainColor, fontSize: 25, weight: FontWeight.w700)
            )
          ),
          Container(
            height: _hForm,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: getCurrentPassword,
                            textAlign: TextAlign.left,
                            style: utils.getTextStyleRegular(fontSize: 14),
                            decoration: InputDecoration(
                              labelText: utils.getTranslated('oldPassword', context),
                              labelStyle: utils.getTextStyleRegular(fontSize: 14),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  _togglePassword('currentPassword');
                                },
                                child: Icon(
                                  _showCurrentPassword! ? CupertinoIcons.eye : CupertinoIcons.eye_slash, color: mainColor),
                              )
                            ),
                            obscureText: !_showCurrentPassword!,
                            validator: _validateCurrentPassword,
                            onSaved: (String? value) {
                              setState(() {
                                getCurrentPassword.text = (value)!;
                              });
                            },
                          ),
                          TextFormField(
                            controller: getNewPassword,
                            textAlign: TextAlign.left,
                            style: utils.getTextStyleRegular(fontSize: 14),
                            decoration: InputDecoration(
                              labelText: utils.getTranslated('newPassword', context),
                              labelStyle: utils.getTextStyleRegular(fontSize: 14),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  _togglePassword('newPassword');
                                },
                                child: Icon(
                                  _showNewPassword! ? CupertinoIcons.eye_fill : CupertinoIcons.eye_slash_fill, color: mainColor),
                              )
                            ),
                            obscureText: !_showNewPassword!,
                            validator: _validatePassword,
                            onSaved: (String? value) {
                              setState(() {
                                getNewPassword.text = (value)!;
                              });
                            },
                          ),
                          TextFormField(
                            textAlign: TextAlign.left,
                            style: utils.getTextStyleRegular(fontSize: 14),
                            decoration: InputDecoration(
                              // counterText: '',
                              labelText: utils.getTranslated('confirmNewPassword', context),
                              labelStyle: utils.getTextStyleRegular(fontSize: 14),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  _togglePassword('matchPassword');
                                },
                                child: Icon(
                                  _showMatchPassword! ? CupertinoIcons.eye_fill : CupertinoIcons.eye_slash_fill, color: mainColor),
                              )
                            ),
                            obscureText: !_showMatchPassword!,
                            validator: _confirmPassword
                          )
                        ]
                      )
                    )
                  ),
                  const SizedBox(height: 5),
                  Container( //_invalidPassword! ? //to_hide_password_criteria
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(5),
                    child: Material(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                      ),
                      elevation: 5.0,
                      color: Colors.white,
                      child: Container(
                        height: 180,
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.4,
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                utils.getTranslated('passwordMustContain', context) + ':',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: utils.getTextStyleRegular(color: Colors.black, fontSize: 16, weight: FontWeight.w700, height: 1.3)
                              ),
                              const SizedBox(height: 10),
                              RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(text: '\u2022 ' + utils.getTranslated('minimum', context) + ' ', style: utils.getTextStyleRegular(color: Colors.grey[600]!, fontSize: 13)),
                                    TextSpan(text: utils.getTranslated('eightCharacter', context).toUpperCase(), style: utils.getTextStyleRegular(color: secondColor, fontSize: 13, weight: FontWeight.w700))
                                  ]
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text('\u2022 ' + utils.getTranslated('useMixCharacter', context) + ': ', style: utils.getTextStyleRegular(color: Colors.grey[600]!, fontSize: 13)),
                              const SizedBox(height: 5),
                              Container(
                                padding: const EdgeInsets.only(left: 10),
                                child: RichText(
                                  textAlign: TextAlign.left,
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(text: utils.getTranslated('criteriaLetter', context).toUpperCase() + ' ', style: utils.getTextStyleRegular(color: secondColor, fontSize: 13, weight: FontWeight.w700)),
                                      TextSpan(text: utils.getTranslated('and', context) + ' ', style: utils.getTextStyleRegular(color: Colors.grey[600]!, fontSize: 13)),
                                      TextSpan(text: utils.getTranslated('symbol', context).toUpperCase() + ' ', style: utils.getTextStyleRegular(color: secondColor, fontSize: 13, weight: FontWeight.w700)),
                                      TextSpan(text: utils.getTranslated('criteriaSample', context), style: utils.getTextStyleRegular(color: Colors.grey[600]!, fontSize: 13))
                                    ]
                                  ),
                                )
                              )
                            ],
                          )
                        )
                      )
                    )
                  )
                  // Container(
                  //   alignment: Alignment.centerLeft,
                  //   child: Row(
                  //     children: <Widget>[
                  //       const Icon(CupertinoIcons.info_circle, size: 20, color: alertColor),
                  //       const SizedBox(width: 10),
                  //       SizedBox(
                  //         width: MediaQuery.of(context).size.width - 110,
                  //         child: Text(
                  //           'Kata Laluan sekurang-kurangnya 8 aksara dengan 1 angka, 1 simbol dan 1 huruf besar',
                  //           overflow: TextOverflow.ellipsis,
                  //           maxLines: 3,
                  //           style: utils.getTextStyleRegular(color: alertColor, fontSize: 14, weight: FontWeight.w500)
                  //         )
                  //       )
                  //     ]
                  //   )
                  // ) 
                  //: Container(), //to_hide_password_criteria
                ]
              )
            ),
          // Container(
          //   height: _hFooter,
          //   padding: const EdgeInsets.symmetric(horizontal: 20),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: <Widget>[
          //       const SizedBox(height: 10),
          //       ButtonRound(
          //         width: MediaQuery.of(context).size.width - 50,
          //         btnName: 'Simpan',
          //         borderColor: Colors.white,
          //         btnColor: secondColor,
          //         colorTitle: Colors.white,
          //         iconBtn: Icon(CupertinoIcons.chevron_right_circle_fill, size: 20, color: Colors.yellow[600]),
          //         onSubmit: () {
          //           _submitChangePassword();
          //         }
          //       ),
          //       const SizedBox(height: 10),
          //     ]
          //   )
          // )
        ]
      ),
    );
  }

  Future<dynamic>? _getUserInfo() async {
    final userInfo = await _storage.read(key: 'userInfo');
    return json.decode(userInfo!);
  }

  String? _validateCurrentPassword(String? value) {
    if (value!.isEmpty) {
      return 'Sila masukkan Kata Laluan';
    } else {
      return null;
    }
  }

  bool? _checkPassword(String value) {
    // Use 8 or more characters with a mix of letters, numbers & symbols
    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  String? _validatePassword(String? value) {
    bool? isValid = _checkPassword(value!);
    setState(() {
      _invalidPassword = false;
    });
    // print('pass $isValid');
    if (value.isEmpty) {
      return utils.getTranslated('passwordErrorMsg', context);
    } else if (!isValid!) {
      setState(() {
        _invalidPassword = true;
      });
      return utils.getTranslated('passwordErrorUnmatchCriteriaMsg', context);
    } else {
      return null;
    }
  }

  String? _confirmPassword(String? value) {
    if (value != getNewPassword.text) {
      return utils.getTranslated('passwordErrorNotMatchMsg', context);
    } else {
      return null;
    }
  }

  void _togglePassword(String type) {
    setState(() {
      if (type == 'currentPassword') {
        _showCurrentPassword = !_showCurrentPassword!;
      } else if (type == 'newPassword') {
        _showNewPassword = !_showNewPassword!;
      } else if (type == 'matchPassword') {
        _showMatchPassword = !_showMatchPassword!;
      }
    });
  }

  void _submitChangePassword() {
    if (_formKey.currentState!.validate()) {
      // No any error in validation
      _formKey.currentState!.save();

      Map _body = {
        'Mykad': _user!['identidyId'],
        'OldPassword': getCurrentPassword.text,
        'NewPassword': getNewPassword.text
      };

      utils.showLoadingDialog(context, _keyLoader);
      _userService?.userChangepassword(token: _token, body: _body).then((response) {
        Navigator.of(_keyLoader.currentContext!).pop();

        if (response.returnCode == 200) {
          utils.showSnackBar(context, response.responseMessage!, 'success');
        } else {
          utils.showSnackBar(context, response.responseMessage!, 'fail');
        }
      }).catchError((onError) {
        debugPrint('errrr course $onError');
        Navigator.of(_keyLoader.currentContext!).pop();
        utils.showSnackBar(context, 'Network server error', 'fail');
      });
    } else {
      debugPrint('have error');
    }
  }
}