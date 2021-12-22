import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:myveteran/core/models/user/user_model.dart';
import 'package:myveteran/core/services/user/user_service.dart';
import 'package:myveteran/shared/components/custom_button/button_round.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EditProfileState extends StatefulWidget {
  final UserModel? user;

  const EditProfileState({Key? key, this.user}) : super(key: key);
  
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfileState> {
  final _storage = const FlutterSecureStorage();
  final ScrollController scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  UserService? _userService;
  UserModel? _user;

  TextEditingController getAddress1 = TextEditingController();
  TextEditingController getAddress2 = TextEditingController();
  TextEditingController getAddress3 = TextEditingController();
  TextEditingController getPostcode = TextEditingController();
  TextEditingController getState = TextEditingController();
  TextEditingController getMobileNo = TextEditingController();
  TextEditingController getHomePhoneNo = TextEditingController();
  TextEditingController getOfficePhoneNo = TextEditingController();
  TextEditingController getEmail = TextEditingController();
  
  String? _token;
  double _offSet = 0.0;

  @override
  void initState() {
    super.initState();
    
    _userService = UserService();
    // _bloc = UserBloc();
    utils.getToken()!.then((value) {
      _token = value;

      _getUserInfo()!.then((record) {
        _user = record;
        getMobileNo.text = _user!.personPhoneNo!;
        // getHomePhoneNo.text = _user!.personPhoneNo2!;
        getEmail.text = _user!.personEmail!;
      });
    });

    getAddress1 = TextEditingController(text: '');
    getAddress2 = TextEditingController(text: '');
    getAddress3 = TextEditingController(text: '');
    getPostcode = TextEditingController(text: '');
    getState = TextEditingController(text: '');
    getMobileNo = TextEditingController(text: '');
    getHomePhoneNo = TextEditingController(text: '');
    getOfficePhoneNo = TextEditingController(text: '');
    getEmail = TextEditingController(text: '');

    getMobileNo.text = widget.user!.personPhoneNo ?? '';
    // getHomePhoneNo.text = widget.user!.personHomePhoneNo ?? '';
    getHomePhoneNo.text = '';
    getEmail.text = widget.user!.personEmail ?? '-';

    scrollController.addListener(() => 
      setState(() {
        //<-----------------------------
        _offSet = scrollController.offset;
        // print('_offSet $_offSet');
        // force a refresh so the app bar can be updated
      })
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
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
        appBar: AppBar(
          centerTitle: true,
          leading: utils.backHeaderButton(context, backIcon: CupertinoIcons.chevron_back),
          brightness: Brightness.light,
          elevation: _offSet > 6 ? 1.0 : 0.0,
          title: Text(
            utils.getTranslated('editProfile', context),
            style: utils.getTextStyleRegular(color: mainColor, fontSize: 22, weight: FontWeight.bold)
          ),
          backgroundColor: Colors.white
        ),
        backgroundColor: Colors.white,
        body: widget.user!.userNo!.isNotEmpty && widget.user!.returnCode == 200 ? SingleChildScrollView(
          controller: scrollController,
          child: _editProfileForm()
        ) : utils.noDataFound(context),
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
            onSubmit: () {
              debugPrint('print edit');
              _submitEditProfile();
            }
          ),
        )
      )
    );
  }

  Widget _editProfileForm() {
    ThemeData? theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                // TextFormField(
                //   initialValue: 'Azli Bin Rahman',
                //   textAlign: TextAlign.left,
                //   inputFormatters: [
                //     LengthLimitingTextInputFormatter(40),
                //   ],
                //   style: theme.textTheme.subtitle1!.copyWith(
                //     color: theme.disabledColor,
                //     fontSize: 16,
                //     height: 1.8
                //   ),
                //   decoration: InputDecoration(
                //     labelText: 'Nama Penuh',
                //     labelStyle: utils.getTextStyleRegular(fontSize: 14, weight: FontWeight.w700),
                //     suffixIcon: const Icon(CupertinoIcons.person_circle, color: mainColor)
                //   ),
                //   enabled: false
                // ),
                // TextFormField(
                //   initialValue: '8621516',
                //   textAlign: TextAlign.left,
                //   keyboardType: const TextInputType.numberWithOptions(decimal: true),
                //   inputFormatters: [
                //     LengthLimitingTextInputFormatter(12),
                //   ],
                //   style: theme.textTheme.subtitle1!.copyWith(
                //     color: theme.disabledColor,
                //     fontSize: 16,
                //     height: 1.8
                //   ),
                //   decoration: InputDecoration(
                //     labelText: 'No. Tentara',
                //     labelStyle: utils.getTextStyleRegular(fontSize: 14, weight: FontWeight.w700),
                //     suffixIcon: const Icon(CupertinoIcons.person_crop_circle_badge_checkmark, color: mainColor)
                //   ),
                //   enabled: false
                // ),
                // TextFormField(
                //   initialValue: '561006101234',
                //   textAlign: TextAlign.left,
                //   keyboardType: const TextInputType.numberWithOptions(decimal: true),
                //   inputFormatters: [
                //     LengthLimitingTextInputFormatter(12),
                //     FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\d{0,2}')),
                //   ],
                //   style: theme.textTheme.subtitle1!.copyWith(
                //     color: theme.disabledColor,
                //     fontSize: 16,
                //     height: 1.8
                //   ),
                //   decoration: InputDecoration(
                //     labelText: 'No. MyKad',
                //     labelStyle: utils.getTextStyleRegular(fontSize: 14, weight: FontWeight.w700),
                //     suffixIcon: const Icon(CupertinoIcons.doc_richtext, color: mainColor)
                //   ),
                //   enabled: false
                // ),
                // Container(
                //   width: MediaQuery.of(context).size.width,
                //   margin: const EdgeInsets.only(top: 30),
                //   child: Text(
                //     'Alamat Tetap',
                //     style: utils.getTextStyleRegular(fontSize: 14, weight: FontWeight.w700),
                //     textAlign: TextAlign.left
                //   )
                // ),
                // Container(
                //   width: MediaQuery.of(context).size.width,
                //   padding: const EdgeInsets.only(left: 10),
                //   child: Column(
                //     children: <Widget>[
                //       TextFormField(
                //         controller: getAddress1,
                //         textAlign: TextAlign.left,
                //         inputFormatters: [
                //           LengthLimitingTextInputFormatter(50)
                //         ],
                //         style: theme.textTheme.subtitle1!.copyWith(
                //           fontSize: 16,
                //           height: 1.8
                //         ),
                //         decoration: InputDecoration(
                //           labelText: 'Barisan 1',
                //           labelStyle: utils.getTextStyleRegular(fontSize: 14, fontStyle: FontStyle.italic),
                //           suffixIcon: const Icon(CupertinoIcons.map_pin_ellipse, color: mainColor)
                //         ),
                //         validator: _validateField,
                //         onSaved: (String? value) {
                //           setState(() {
                //             getAddress1.text = (value)!;
                //           });
                //         }
                //       ),
                //       TextFormField(
                //         controller: getAddress2,
                //         textAlign: TextAlign.left,
                //         inputFormatters: [
                //           LengthLimitingTextInputFormatter(30)
                //         ],
                //         style: theme.textTheme.subtitle1!.copyWith(
                //           fontSize: 16,
                //           height: 1.8
                //         ),
                //         decoration: InputDecoration(
                //           labelText: 'Barisan 2',
                //           labelStyle: utils.getTextStyleRegular(fontSize: 14, fontStyle: FontStyle.italic),
                //           suffixIcon: const Icon(CupertinoIcons.map_pin_ellipse, color: mainColor)
                //         ),
                //         onSaved: (String? value) {
                //           setState(() {
                //             getAddress2.text = (value)!;
                //           });
                //         }
                //       ),
                //       TextFormField(
                //         controller: getAddress3,
                //         textAlign: TextAlign.left,
                //         inputFormatters: [
                //           LengthLimitingTextInputFormatter(30)
                //         ],
                //         style: theme.textTheme.subtitle1!.copyWith(
                //           fontSize: 16,
                //           height: 1.8
                //         ),
                //         decoration: InputDecoration(
                //           labelText: 'Barisan 3',
                //           labelStyle: utils.getTextStyleRegular(fontSize: 14, fontStyle: FontStyle.italic),
                //           suffixIcon: const Icon(CupertinoIcons.map_pin_ellipse, color: mainColor)
                //         ),
                //         onSaved: (String? value) {
                //           setState(() {
                //             getAddress3.text = (value)!;
                //           });
                //         }
                //       ),
                //       TextFormField(
                //         controller: getPostcode,
                //         textAlign: TextAlign.left,
                //         keyboardType: const TextInputType.numberWithOptions(decimal: false),
                //         inputFormatters: [
                //           LengthLimitingTextInputFormatter(5),
                //           FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\d{0,5}')),
                //         ],
                //         style: theme.textTheme.subtitle1!.copyWith(
                //           fontSize: 16,
                //           height: 1.8
                //         ),
                //         decoration: InputDecoration(
                //           labelText: 'Poskod',
                //           labelStyle: utils.getTextStyleRegular(fontSize: 14, fontStyle: FontStyle.italic),
                //           suffixIcon: const Icon(CupertinoIcons.textformat_123, color: mainColor)
                //         ),
                //         validator: _validateField,
                //         onSaved: (String? value) {
                //           setState(() {
                //             getPostcode.text = (value)!;
                //           });
                //         }
                //       ),
                //       TextFormField(
                //         controller: getState,
                //         textAlign: TextAlign.left,
                //         inputFormatters: [
                //           LengthLimitingTextInputFormatter(20)
                //         ],
                //         style: theme.textTheme.subtitle1!.copyWith(
                //           fontSize: 16,
                //           height: 1.8
                //         ),
                //         decoration: InputDecoration(
                //           labelText: 'Negeri',
                //           labelStyle: utils.getTextStyleRegular(fontSize: 14, fontStyle: FontStyle.italic),
                //           suffixIcon: const Icon(CupertinoIcons.rays, color: mainColor)
                //         ),
                //         validator: _validateField,
                //         onSaved: (String? value) {
                //           setState(() {
                //             getState.text = (value)!;
                //           });
                //         }
                //       )
                //     ]
                //   )
                // ),
                TextFormField(
                  // initialValue: '1223456895',
                  controller: getMobileNo,
                  textAlign: TextAlign.left,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(12),
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  style: theme.textTheme.subtitle1!.copyWith(
                    fontSize: 16,
                    height: 1.8
                  ),
                  decoration: InputDecoration(
                    labelText: utils.getTranslated('mobileNo', context) + ' (HP)',
                    labelStyle: utils.getTextStyleRegular(fontSize: 14, weight: FontWeight.w700),
                    suffixIcon: const Icon(CupertinoIcons.device_phone_portrait, color: mainColor),
                    prefixText: '+60 ',
                  ),
                  validator: _validateMobileNo,
                  onSaved: (String? value) {
                    setState(() {
                      getMobileNo.text = (value)!;
                    });
                  }
                ),
                TextFormField(
                  // initialValue: '61234567',
                  controller: getHomePhoneNo,
                  textAlign: TextAlign.left,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(12),
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  style: theme.textTheme.subtitle1!.copyWith(
                    fontSize: 16,
                    height: 1.8
                  ),
                  decoration: InputDecoration(
                    labelText: utils.getTranslated('officePhoneNo', context),
                    labelStyle: utils.getTextStyleRegular(fontSize: 14, weight: FontWeight.w700),
                    suffixIcon: const Icon(CupertinoIcons.phone_circle, color: mainColor),
                    prefixText: '+60 ',
                  ),
                  validator: _validatePhoneNo,
                  onSaved: (String? value) {
                    setState(() {
                      getHomePhoneNo.text = (value)!;
                    });
                  }
                ),
                // TextFormField(
                //   controller: getOfficePhoneNo,
                //   textAlign: TextAlign.left,
                //   keyboardType: TextInputType.number,
                //   inputFormatters: [
                //     LengthLimitingTextInputFormatter(12),
                //     FilteringTextInputFormatter.digitsOnly
                //   ],
                //   style: theme.textTheme.subtitle1!.copyWith(
                //     fontSize: 16,
                //     height: 1.8
                //   ),
                //   decoration: InputDecoration(
                //     labelText: 'No. Telefon Pejabat',
                //     labelStyle: utils.getTextStyleRegular(fontSize: 14, weight: FontWeight.w700),
                //     suffixIcon: const Icon(CupertinoIcons.phone_arrow_right, color: mainColor),
                //     prefixText: '+603 ',
                //   ),
                //   validator: _validatePhoneNo,
                //   onSaved: (String? value) {
                //     setState(() {
                //       getOfficePhoneNo.text = (value)!;
                //     });
                //   }
                // ),
                TextFormField(
                  // initialValue: 'azlirahman@gmail.com',
                  controller: getEmail,
                  textAlign: TextAlign.left,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(50)
                  ],
                  style: theme.textTheme.subtitle1!.copyWith(
                    fontSize: 16,
                    height: 1.8
                  ),
                  decoration: InputDecoration(
                    labelText: utils.getTranslated('email', context),
                    labelStyle: utils.getTextStyleRegular(fontSize: 14, weight: FontWeight.w700),
                    suffixIcon: const Icon(CupertinoIcons.at, color: mainColor)
                  ),
                  validator: _validateEmail,
                  onSaved: (String? value) {
                    setState(() {
                      getEmail.text = (value)!;
                    });
                  }
                ),
                const SizedBox(height: 30)
              ]
            )
          )
        ]
      )
    );
  }

  Future<dynamic>? _getUserInfo() async {
    final token = await _storage.read(key: 'token');
    final result = await _userService!.fetchUserProfileData(token: token).then((response) {
      return response;
    }).catchError((onError) {
      debugPrint('onError $onError');
    });
    return result;
  }

  String? _validateField(String? value) {
    if ((value?.isEmpty) as bool) {
      return 'Maklumat ini adalah diperlukan';
    } else {
      return null;
    }
  }

  String? _validateMobileNo(String? value) {
    String pattern = r'(^(?!6)[0-9][0-9]{8,12}$)'; //r'(^(?!6)[1-9][0-9]{8,12}$)'
    RegExp regExp = RegExp(pattern);
    if(!regExp.hasMatch(value!)){
      return utils.getTranslated('mobileNoErrorMsg', context);
    } else {
      return null;
    }
  }

  String? _validatePhoneNo(String? value) {
    String pattern = r'(^(?!6)[1-9][0-9]{8,12}$)';
    RegExp regExp = RegExp(pattern);
    if ((value?.isEmpty) as bool) {
      return utils.getTranslated('fieldRequired', context);
    } else if(!regExp.hasMatch(value!)){
      return utils.getTranslated('phoneNoErrorMsg', context);
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

  void _submitEditProfile() {
    if (_formKey.currentState!.validate()) {
      // No any error in validation
      _formKey.currentState!.save();

      Map _body = {
        'Mykad': _user!.personIdentidyID,
        'PhoneNo1': getMobileNo.text,
        'PhoneNo2': getHomePhoneNo.text,
        'Email': getEmail.text
      };

      utils.showLoadingDialog(context, _keyLoader);
      _userService?.userUpdateProfile(token: _token, body: _body).then((response) {
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

      // Future.delayed(const Duration(seconds: 2), () {
      //   Navigator.of(_keyLoader.currentContext!).pop();
      // });
    } else {
      debugPrint('have error');
    }
  }
}