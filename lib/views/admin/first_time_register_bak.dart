import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:myveteran/shared/components/custom_button/button_round.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:flutter/material.dart';
import 'package:myveteran/shared/config/utils.dart';

class FirstTimeRegisterBakState extends StatefulWidget {
  const FirstTimeRegisterBakState({Key? key}) : super(key: key);
  
  @override
  _FirstTimeRegisterBakState createState() => _FirstTimeRegisterBakState();
}

class _FirstTimeRegisterBakState extends State<FirstTimeRegisterBakState> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  TextEditingController getFullname = TextEditingController();
  TextEditingController getMyCardNo = TextEditingController();
  TextEditingController getPhoneNo = TextEditingController();
  TextEditingController getEmail = TextEditingController();

  bool? _termConditionCB;

  @override
  void initState() {
    super.initState();
    
    getFullname = TextEditingController(text: '');
    getMyCardNo = TextEditingController(text: '');
    getPhoneNo = TextEditingController(text: '');
    getEmail = TextEditingController(text: '');

    _termConditionCB = false;
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
        body: _registrationForm(),
        bottomNavigationBar: SizedBox(
          height: 130,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Checkbox(
                    activeColor: mainColor,
                    value: _termConditionCB,
                    onChanged: (bool? val) {
                      setState(() {
                        _termConditionCB = val;
                        debugPrint('test $val');
                      });
                    }
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(text: 'Saya bersetuju dengan ', style: utils.getTextStyleRegular(color: Colors.grey[500]!, fontSize: 14)),
                        TextSpan(text: 'Terma dan Syarat ', style: utils.getTextStyleRegular(color: secondColor, fontSize: 14, underline: TextDecoration.underline))
                      ]
                    ),
                  )
                ],
              ),
              ButtonRound(
                btnName: 'Daftar',
                borderColor: _termConditionCB! ? Colors.white : Colors.grey[300],
                btnColor: _termConditionCB! ? secondColor : Colors.grey[400],
                colorTitle: _termConditionCB! ? Colors.white : Colors.grey[600],
                iconBtn: Icon(Icons.person_add_alt_1_rounded, size: 20, color: Colors.yellow[600]),
                onSubmit: _termConditionCB! ? () {
                  _submitRegister();
                } : null
              ),
              const SizedBox(height: 30)
            ]
          )
        )
      )
    );
  }

  Widget? _registrationForm() {
    double _hApp = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double _hTop = (_hApp * 0.1);
    double _hForm = (_hApp * 0.6);
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
              'Pengguna Kali Pertama',
              style: utils.getTextStyleRegular(color: mainColor, fontSize: 25, weight: FontWeight.w700)
            )
          ),
          Container(
            height: _hForm,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                          controller: getFullname,
                          textAlign: TextAlign.left,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(40),
                          ],
                          style: utils.getTextStyleRegular(fontSize: 14),
                          decoration: InputDecoration(
                            // counterText: '',
                            labelText: 'Nama Penuh',
                            labelStyle: utils.getTextStyleRegular(fontSize: 14),
                            suffixIcon: const Icon(CupertinoIcons.person_circle, color: mainColor)
                          ),
                          validator: _validateFullname,
                          onSaved: (String? value) {
                            setState(() {
                              getFullname.text = (value)!;
                            });
                          },
                        ),
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
                            labelText: 'No. MyKad',
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
                          controller: getPhoneNo,
                          textAlign: TextAlign.left,
                          keyboardType: const TextInputType.numberWithOptions(),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(11),
                          ],
                          style: utils.getTextStyleRegular(fontSize: 14),
                          decoration: InputDecoration(
                            // counterText: '',
                            labelText: 'No. Telefon',
                            labelStyle: utils.getTextStyleRegular(fontSize: 14),
                            suffixIcon: const Icon(CupertinoIcons.phone, color: mainColor),
                            prefixText: '+60 ',
                          ),
                          validator: _validatePhoneNo,
                          onSaved: (String? value) {
                            setState(() {
                              getPhoneNo.text = (value)!;
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
                            labelText: 'E-mel',
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
          )
        ]
      ),
    );
  }

  String? _validateFullname(String? value) {
    String pattern = r'^\w[a-zA-Z\s]{2,}$';
    RegExp regExp = RegExp(pattern);
    if(!regExp.hasMatch(value!)){
      return 'Sila masukkan nama penuh';
    } else {
      return null;
    }
  }

  String? _validateCardNo(String? value) {
    if(value?.length as int < 11){
      return 'Sila masukkan nombor MyKad';
    } else {
      return null;
    }
  }

  String? _validatePhoneNo(String? value) {
    String pattern = r'(^(?!6)[1-9][0-9]{9,11}$)';
    RegExp regExp = RegExp(pattern);
    if ((value?.isEmpty) as bool) {
      return 'Nombor telefon diperlukan';
    } else if(!regExp.hasMatch(value!)){
      return 'Sila masukkan nombor telefon';
    } else {
      return null;
    }
  }

  String? _validateEmail(String? value) {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    if ((value?.isEmpty) as bool) {
      return 'Alamat e-mel diperlukan';
    } else if(!regExp.hasMatch(value!)){
      return 'Sila masukkan alamat e-mel yang sah';
    } else {
      return null;
    }
  }

  void _submitRegister() {
    if (_formKey.currentState!.validate()) {
      // No any error in validation
      _formKey.currentState!.save();

      utils.showLoadingDialog(context, _keyLoader);
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(_keyLoader.currentContext!).pop();
        if (getMyCardNo.text == '12345678901') {
          Navigator.of(context).pushNamed(login);
          utils.showSnackBar(context, 'Rekod berjaya disimpan', 'success');
        } else {
          utils.showSnackBar(context, 'Rekod tidak berjaya disimpan', 'fail');
        }
      });
    } else {
      debugPrint('have error');
    }
  }
}