import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:myveteran/core/services/user/user_service.dart';
import 'package:myveteran/shared/components/custom_button/button_round.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:flutter/material.dart';
import 'package:myveteran/shared/config/utils.dart';

class ForgetPasswordState extends StatefulWidget {
  const ForgetPasswordState({Key? key}) : super(key: key);
  
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPasswordState> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  UserService? _userService;

  TextEditingController getMyCardNo = TextEditingController();
  TextEditingController getEmail = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    _userService = UserService();

    getMyCardNo = TextEditingController(text: '');
    getEmail = TextEditingController(text: '');
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
          leading: utils.backHeaderButton(context, backIcon: Icons.close),
          brightness: Brightness.light,
          elevation: 0.0,
          title: const Text(''),
          backgroundColor: Colors.white
        ),
        body: _forgetPasswordForm()
      )
    );
  }

  Widget? _forgetPasswordForm() {
    double _hApp = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double _hTop = (_hApp * 0.1);
    double _hForm = (_hApp * 0.32);
    double _hFooter = (_hApp * 0.4);

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
              utils.getTranslated('forgetPassword', context),
              style: utils.getTextStyleRegular(color: mainColor, fontSize: 25, weight: FontWeight.w700)
            )
          ),
          Container(
            height: _hForm,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                          // maxLength: 15,
                          validator: _validateCardNo,
                          onSaved: (String? value) {
                            setState(() {
                              getMyCardNo.text = (value)!;
                            });
                          },
                        ),
                        TextFormField(
                          controller: getEmail,
                          textAlign: TextAlign.left,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50),
                          ],
                          style: utils.getTextStyleRegular(fontSize: 14),
                          decoration: InputDecoration(
                            // counterText: '',
                            labelText: utils.getTranslated('email', context),
                            labelStyle: utils.getTextStyleRegular(fontSize: 14),
                            suffixIcon: const Icon(CupertinoIcons.at, color: mainColor)
                          ),
                          validator: _validateEmail,
                          onSaved: (String? value) {
                            setState(() {
                              getEmail.text = (value)!;
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
          Container(
            height: _hFooter,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 10),
                ButtonRound(
                  btnName: utils.getTranslated('submit', context),
                  borderColor: Colors.white,
                  btnColor: secondColor,
                  colorTitle: Colors.white,
                  iconBtn: Icon(CupertinoIcons.chevron_right_circle_fill, size: 20, color: Colors.yellow[600]),
                  onSubmit: () {
                    _submitForgetPassword();
                  }
                ),
              ]
            )
          )
        ]
      ),
    );
  }

  String? _validateCardNo(String? value) {
    if(value?.length as int < 11){
      return utils.getTranslated('icNoErrorMsg', context);
    } else {
      return null;
    }
  }

  String? _validateEmail(String? value) {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    if ((value?.isEmpty) as bool) {
      return utils.getTranslated('emailErrorMsg', context);
    } else if(!regExp.hasMatch(value!)){
      return utils.getTranslated('emailValidErrorMsg', context);
    } else {
      return null;
    }
  }

  void _submitForgetPassword() {
    if (_formKey.currentState!.validate()) {
      // No any error in validation
      _formKey.currentState!.save();

      Map _body = {
        'Mykad': getMyCardNo.text,
        // 'Email': getEmail.text
      };

      utils.showLoadingDialog(context, _keyLoader);
      _userService!.forgetPasswordData(body: _body).then((response) {
        Navigator.of(_keyLoader.currentContext!).pop();
        if (response.returnCode == 200) {
          utils.showSnackBar(context, response.responseMessage!, 'success');
        } else {
          utils.showSnackBar(context, response.responseMessage!, 'fail');
        }
      }).catchError((onError) {
        debugPrint('errrr upload forget password $onError');
        Navigator.of(_keyLoader.currentContext!).pop();
        utils.showSnackBar(context, 'Network server error', 'fail');
      });
      // Future.delayed(const Duration(seconds: 2), () {
      //   Navigator.of(_keyLoader.currentContext!).pop();
      //   if (getMyCardNo.text == '12345678901') {
      //     Navigator.of(context).pushNamed(login);
      //     utils.showSnackBar(context, 'Maklumat kata laluan telah dihantar ke e-mel', 'success');
      //   } else {
      //     utils.showSnackBar(context, 'Maklumat kata laluan tidak berjaya dihantar ke e-mel', 'fail');
      //   }
      // });
    } else {
      debugPrint('have error');
    }
  }
}