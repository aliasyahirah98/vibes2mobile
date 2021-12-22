import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:myveteran/blocs/user/user_bloc.dart';
import 'package:myveteran/core/services/user/user_service.dart';
import 'package:myveteran/shared/components/custom_button/button_round.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:flutter/material.dart';
import 'package:myveteran/shared/config/utils.dart';

class FirstTimeRegisterState extends StatefulWidget {
  const FirstTimeRegisterState({Key? key}) : super(key: key);
  
  @override
  _FirstTimeRegisterState createState() => _FirstTimeRegisterState();
}

class _FirstTimeRegisterState extends State<FirstTimeRegisterState> {
  final ScrollController scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  TextEditingController getMyCardNo = TextEditingController();
  TextEditingController getArmyId = TextEditingController();
  TextEditingController getFullname = TextEditingController();
  TextEditingController getEmail = TextEditingController();
  TextEditingController getMobileNo = TextEditingController();
  TextEditingController getHomePhoneNo = TextEditingController();

  String? appType = '', myKad = '', armyId = '';
  int currIndex = 0;
  bool? _termConditionCB, _showResult, _agreeCb;
  UserBloc? _bloc;
  UserService? _userService;

  @override
  void initState() {
    super.initState();
    
    getMyCardNo = TextEditingController(text: '');
    getArmyId = TextEditingController(text: '');
    getFullname = TextEditingController(text: '');
    getEmail = TextEditingController(text: '');
    getMobileNo = TextEditingController(text: '');
    getHomePhoneNo = TextEditingController(text: '');

    _termConditionCB = false;
    _showResult = false;
    _agreeCb = false;

    _bloc = UserBloc();
    _userService = UserService();

    scrollController.addListener(() => 
      setState(() {
      })
    );
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
        body: Stack(
          children: <Widget>[
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              constraints: const BoxConstraints(maxHeight: 60),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 0.5, color: Color(0xFFc2aa92)),
                )
              ),
              child: Text(
                utils.getTranslated('firstTimeUser', context),
                style: utils.getTextStyleRegular(color: mainColor, fontSize: 25, weight: FontWeight.w700)
              )
            ),
            Container(
              margin: const EdgeInsets.only(top: 70),
              child: SingleChildScrollView(
                controller: scrollController,
                child: _registrationForm()
              )
            )
          ]
        ),
        bottomNavigationBar: Container(
          height: 130,
          decoration: BoxDecoration(
          // color: Colors.red,
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10)
            )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Checkbox(
                    activeColor: mainColor,
                    value: _termConditionCB,
                    onChanged: _agreeCb == true ? (bool? val) {
                      setState(() {
                        _termConditionCB = val;
                        debugPrint('test $val');
                      });
                    } : null
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(text: utils.getTranslated('acceptance', context) + ' ', style: utils.getTextStyleRegular(color: Colors.grey[500]!, fontSize: 14)),
                        TextSpan(text: utils.getTranslated('termAndConditions', context), style: utils.getTextStyleRegular(color: secondColor, fontSize: 14, underline: TextDecoration.underline))
                      ]
                    ),
                  )
                ],
              ),
              ButtonRound(
                btnName: utils.getTranslated('register', context),
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
    ThemeData? theme = Theme.of(context);
    return Container(
      // height: _hForm,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      utils.getTranslated('userType', context),
                      style: utils.getTextStyleRegular(fontSize: 14),
                      textAlign: TextAlign.left
                    )
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: <Widget>[
                        radioPane(utils.getTranslated('veteranATM', context).toUpperCase(), 0),
                        radioPane(utils.getTranslated('dependent', context).toUpperCase(), 1)
                      ]
                    )
                  ),
                  TextFormField(
                    controller: getMyCardNo,
                    textAlign: TextAlign.left,
                    keyboardType: const TextInputType.numberWithOptions(decimal: false),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(15)
                    ],
                    style: utils.getTextStyleRegular(fontSize: 14),
                    decoration: InputDecoration(
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
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.5 - 60,
                          child: TextFormField(
                            controller: getArmyId,
                            textAlign: TextAlign.left,
                            keyboardType: const TextInputType.numberWithOptions(decimal: false),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(15)
                            ],
                            style: utils.getTextStyleRegular(fontSize: 14),
                            decoration: InputDecoration(
                              labelText: currIndex == 0 ? utils.getTranslated('armyNo', context) : utils.getTranslated('veteranArmyNo', context),
                              labelStyle: utils.getTextStyleRegular(fontSize: 14),
                              suffixIcon: const Icon(CupertinoIcons.person_crop_circle_badge_checkmark, color: mainColor)
                            ),
                            validator: _validateArmyId,
                            onSaved: (String? value) {
                              setState(() {
                                getArmyId.text = (value)!;
                              });
                            },
                          )
                        ),
                        ButtonRound(
                          width: 80,
                          btnName: utils.getTranslated('find', context),
                          borderColor: secondColor,
                          btnColor: Colors.grey[300],
                          colorTitle: secondColor,
                          onSubmit: () {
                            _checkAccount();
                          }
                        ),
                      ]
                    )
                  ),
                  _showResult! ? Column(
                    children: <Widget>[
                      TextFormField(
                        controller: getFullname,
                        textAlign: TextAlign.left,
                        style: theme.textTheme.subtitle1!.copyWith(
                          fontSize: 16,
                          height: 1.8
                        ),
                        decoration: InputDecoration(
                          // counterText: '',
                          labelText: utils.getTranslated('fullname', context),
                          labelStyle: utils.getTextStyleRegular(fontSize: 14),
                          suffixIcon: const Icon(CupertinoIcons.person_circle, color: mainColor)
                        ),
                        enabled: false
                      ),
                      TextFormField(
                        controller: getEmail,
                        textAlign: TextAlign.left,
                        style: utils.getTextStyleRegular(fontSize: 14),
                        decoration: InputDecoration(
                          labelText: utils.getTranslated('email', context),
                          labelStyle: utils.getTextStyleRegular(fontSize: 14),
                          suffixIcon: const Icon(CupertinoIcons.at, color: mainColor)
                        ),
                        enabled: false
                      ),
                      TextFormField(
                        controller: getMobileNo,
                        textAlign: TextAlign.left,
                        style: utils.getTextStyleRegular(fontSize: 14),
                        decoration: InputDecoration(
                          labelText: utils.getTranslated('mobileNo', context),
                          labelStyle: utils.getTextStyleRegular(fontSize: 14),
                          suffixIcon: const Icon(CupertinoIcons.device_phone_portrait, color: mainColor),
                          prefixText: '+60 ',
                        ),
                        enabled: false
                      ),
                      TextFormField(
                        controller: getHomePhoneNo,
                        textAlign: TextAlign.left,
                        style: utils.getTextStyleRegular(fontSize: 14),
                        decoration: InputDecoration(
                          labelText: utils.getTranslated('officePhoneNo', context),
                          labelStyle: utils.getTextStyleRegular(fontSize: 14),
                          suffixIcon: const Icon(CupertinoIcons.phone_arrow_right, color: mainColor),
                          prefixText: '+603 ',
                        ),
                        enabled: false
                      )
                    ]
                  ) : Container()
                ]
              )
            ),
            const SizedBox(height: 30)
          ]
        )
      )
    );
  }

  void changeIndex(int index){
    setState(() {
      currIndex = index;
    });
  }

  Widget radioPane(String type, int index){
    return SizedBox(
      width: (MediaQuery.of(context).size.width / 2) - 50,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: currIndex == index ? secondColor : Colors.grey[300],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          side: BorderSide(color: currIndex == index ? Colors.yellow[700]! : Colors.grey[500]!, width: 2)
        ),
        onPressed: () => changeIndex(index),
        child: Text(
          type,
          style: utils.getTextStyleRegular(fontSize: 13, color: currIndex == index ? Colors.white : secondColor)
        )
      )
    );
  }

  String? _validateCardNo(String? value) {
    if(value?.length as int < 11){
      return utils.getTranslated('icNoErrorMsg', context);
    } else {
      return null;
    }
  }

  String? _validateArmyId(String? value) {
    // if(value?.length as int < 11){
    if(value?.length as int < 4){
      return utils.getTranslated('armyNoErrorMsg', context);
    } else {
      return null;
    }
  }

  void _checkAccount() async {
    setState(() {
      appType = '';
      myKad = '';
      armyId = '';

      _showResult = false;
      _agreeCb = false;
      _termConditionCB = false;
    });
    
    if (_formKey.currentState!.validate()) {
      // No any error in validation
      _formKey.currentState!.save();

      Map _body = {
        'UserType': currIndex == 0 ? 'VETERAN ATM' : 'WARIS',
        'Mykad': getMyCardNo.text,
        'MilitaryNo': getArmyId.text,
        'TermsAgree': 'true'
      };

      // utils.showLoadingDialog(context, _keyLoader);
      _userService?.verifyUser(body: _body).then((respInfo) async {
        // Navigator.of(_keyLoader.currentContext!).pop();
        if (respInfo.personMykad! == '-') {
          setState(() {
            appType = _body['UserType'];
            myKad = respInfo.personMykad;
            armyId = getArmyId.text;

            _showResult = true;
            _agreeCb = true;
            getFullname.text = respInfo.personName!;
            getEmail.text = respInfo.personEmail!;
            getMobileNo.text = respInfo.personPhoneNo!;
            getHomePhoneNo.text = '-';
          });
        } else {
          _showResult = false;
          _agreeCb = false;
          _termConditionCB = false;
          utils.showSnackBar(context, respInfo.responseMessage!, 'fail');
        }
      }).catchError((onError) {
        // Navigator.of(_keyLoader.currentContext!).pop();
        utils.showSnackBar(context, 'Network server error', 'fail');
      });
      // await _bloc!.createUserProfile(body: _body);
      // _userService!.createUserProfileData(body: _body).then((response) async {
      //   Navigator.of(_keyLoader.currentContext!).pop();
      // }).catchError((onError) async {
      //   debugPrint('errrr upload $onError');
      //   Navigator.of(_keyLoader.currentContext!).pop();
      //   utils.showSnackBar(context, 'Network server error', 'fail');
      // });
      // Future.delayed(const Duration(seconds: 2), () {
      //   Navigator.of(_keyLoader.currentContext!).pop();
      //   if (getMyCardNo.text == '12345678901') {
      //     setState(() {
      //       _showResult = true;
      //       getFullname.text = 'ALI BIN ISMAIL';
      //       getEmail.text = 'ali@gmail.com';
      //       getMobileNo.text = '123456789';
      //       getHomePhoneNo.text = '89921234';
      //     });
      //   } else {
      //     utils.showSnackBar(context, 'Tiada rekod dijumpai', 'fail');
      //   }
      // });
    } else {
      debugPrint('have error 1');
    }
  }

  void _submitRegister() async {    
    if (_formKey.currentState!.validate() && _showResult! && myKad != '-') {
      // No any error in validation
      _formKey.currentState!.save();

      Map _body = {
        'UserType': appType,
        'Mykad': myKad,
        'MilitaryNo': armyId,
        'Fullname': getFullname.text,
        'Email': getEmail.text,
        'MobileNo': getMobileNo.text,
        'HomePhoneNo': getHomePhoneNo.text,
        'TermsAgree': _termConditionCB.toString()
      };

      utils.showLoadingDialog(context, _keyLoader);
      _userService!.createUserProfileData(body: _body).then((response) async {
        Navigator.of(_keyLoader.currentContext!).pop();

        if (response.returnCode! != 401) {
          Navigator.of(context).pushNamed(login);
          utils.showSnackBar(context, response.responseMessage!, 'success');
        } else {
          utils.showSnackBar(context, response.responseMessage!, 'fail');
        }
      }).catchError((onError) async {
        debugPrint('errrr upload $onError');
        Navigator.of(_keyLoader.currentContext!).pop();
        utils.showSnackBar(context, 'Network server error', 'fail');
      });
      
      // Future.delayed(const Duration(seconds: 2), () {
      //   Navigator.of(_keyLoader.currentContext!).pop();
      //   if (getMyCardNo.text == '12345678901') {
      //     setState(() {
      //       _showResult = true;
      //       getFullname.text = 'ALI BIN ISMAIL';
      //       getEmail.text = 'ali@gmail.com';
      //       getMobileNo.text = '123456789';
      //       getHomePhoneNo.text = '89921234';
      //     });
      //   } else {
      //     utils.showSnackBar(context, 'Tiada rekod dijumpai', 'fail');
      //   }
      // });
      
      // Future.delayed(const Duration(seconds: 2), () {
      //   Navigator.of(_keyLoader.currentContext!).pop();
      //   if (getFullname.text == 'ALI BIN ISMAIL') {
      //     Navigator.of(context).pushNamed(login);
      //     utils.showSnackBar(context, 'Rekod berjaya disimpan', 'success');
      //   } else {
      //     utils.showSnackBar(context, 'Rekod tidak berjaya disimpan', 'fail');
      //   }
      // });
    } else {
      utils.showSnackBar(context, 'Sila semak dulu rekod anda', 'fail');
      debugPrint('have error 2');
    }
  }
}