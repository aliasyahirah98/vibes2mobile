import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:myveteran/core/services/veteran/veteran_education_service.dart';
import 'package:myveteran/shared/components/custom_button/button_round.dart';
import 'package:myveteran/shared/components/dialog/direct_dialog.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';

List<dynamic> _itemList = [
  {
    'name': 'RM3000 ke bawah',
    'value': '0T03000'
  },
  {
    'name': 'RM3000 ke atas',
    'value': '3000Above'
  }
];

class UpdateEducationState extends StatefulWidget {
  const UpdateEducationState({Key? key}) : super(key: key);
  
  @override
  _UpdateEducationState createState() => _UpdateEducationState();
}

class _UpdateEducationState extends State<UpdateEducationState> {
  final ScrollController scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  TextEditingController getUserHeight = TextEditingController();
  TextEditingController getUserWeight = TextEditingController();
  TextEditingController getUserOccupation = TextEditingController();
  TextEditingController getUserEmployee = TextEditingController();
  TextEditingController getUserSalary = TextEditingController();

  double _offSet = 0.0;
  String? _token, _codeValue;

  VeteranEducationService? _veteranEducationService;

  @override
  void initState() {
    super.initState();
    
    getUserHeight = TextEditingController(text: '');
    getUserWeight = TextEditingController(text: '');
    getUserOccupation = TextEditingController(text: '');
    getUserEmployee = TextEditingController(text: '');
    getUserSalary = TextEditingController(text: '');

    _veteranEducationService = VeteranEducationService();

    utils.getToken()!.then((value) {
      _token = value;
      // debugPrint('token $_token');
    });

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
            utils.getTranslated('update', context),
            style: utils.getTextStyleRegular(color: mainColor, fontSize: 22, weight: FontWeight.bold)
          ),
          backgroundColor: Colors.white
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          controller: scrollController,
          child: _updateEducationForm()
        ),
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
              _submitUpdateEducation();
            }
          ),
        )
      )
    );
  }

  Widget _updateEducationForm() {
    ThemeData? theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: getUserHeight,
                  // initialValue: '170',
                  textAlign: TextAlign.left,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(3),
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  style: theme.textTheme.subtitle1!.copyWith(
                    fontSize: 16,
                    height: 1.8
                  ),
                  decoration: InputDecoration(
                    labelText: utils.getTranslated('height', context) + ' (CM)',
                    labelStyle: utils.getTextStyleRegular(fontSize: 14, weight: FontWeight.w700),
                    // suffixIcon: const Icon(CupertinoIcons.person_circle, color: mainColor)
                  ),
                  validator: _validateField,
                  onSaved: (String? value) {
                    setState(() {
                      getUserHeight.text = (value)!;
                    });
                  }
                ),
                TextFormField(
                  controller: getUserWeight,
                  // initialValue: '80',
                  textAlign: TextAlign.left,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(3),
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  style: theme.textTheme.subtitle1!.copyWith(
                    fontSize: 16,
                    height: 1.8
                  ),
                  decoration: InputDecoration(
                    labelText: utils.getTranslated('weight', context) + ' (KG)',
                    labelStyle: utils.getTextStyleRegular(fontSize: 14, weight: FontWeight.w700),
                    // suffixIcon: const Icon(CupertinoIcons.person_circle, color: mainColor)
                  ),
                  validator: _validateField,
                  onSaved: (String? value) {
                    setState(() {
                      getUserWeight.text = (value)!;
                    });
                  }
                ),
                TextFormField(
                  controller: getUserOccupation,
                  // initialValue: 'Pegawai Keselamatan',
                  textAlign: TextAlign.left,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(100)
                  ],
                  style: theme.textTheme.subtitle1!.copyWith(
                    fontSize: 16,
                    height: 1.8
                  ),
                  decoration: InputDecoration(
                    labelText: utils.getTranslated('currentOccupation', context),
                    labelStyle: utils.getTextStyleRegular(fontSize: 14, weight: FontWeight.w700),
                    // suffixIcon: const Icon(CupertinoIcons.doc_richtext, color: mainColor)
                  ),
                  validator: _validateField,
                  onSaved: (String? value) {
                    setState(() {
                      getUserOccupation.text = (value)!;
                    });
                  }
                ),
                TextFormField(
                  controller: getUserEmployee,
                  // initialValue: 'Deli Security Sdn Bhd',
                  textAlign: TextAlign.left,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(100)
                  ],
                  style: theme.textTheme.subtitle1!.copyWith(
                    fontSize: 16,
                    height: 1.8
                  ),
                  decoration: InputDecoration(
                    labelText: utils.getTranslated('employer', context),
                    labelStyle: utils.getTextStyleRegular(fontSize: 14, weight: FontWeight.w700),
                    // suffixIcon: const Icon(CupertinoIcons.doc_richtext, color: mainColor)
                  ),
                  validator: _validateField,
                  onSaved: (String? value) {
                    setState(() {
                      getUserEmployee.text = (value)!;
                    });
                  }
                ),
                TextFormField(
                  controller: getUserSalary,
                  // initialValue: '1200',
                  textAlign: TextAlign.left,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(5),
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  style: theme.textTheme.subtitle1!.copyWith(
                    fontSize: 16,
                    height: 1.8
                  ),
                  decoration: InputDecoration(
                    labelText: utils.getTranslated('currentSalary', context) + ' (RM)',
                    labelStyle: utils.getTextStyleRegular(fontSize: 14, weight: FontWeight.w700),
                    // suffixIcon: const Icon(CupertinoIcons.person_circle, color: mainColor)
                  ),
                  validator: _validateField,
                  onSaved: (String? value) {
                    setState(() {
                      getUserSalary.text = (value)!;
                    });
                  }
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(top: 20),
                  child: FormField<String>(
                    validator: _validateDDItem,
                    onSaved: (value) {
                      _codeValue = value;
                    },
                    builder: (
                      FormFieldState<String> state,
                    ) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          InputDecorator(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(0.0),
                              labelText: utils.getTranslated('expectedSalary', context) + ' (RM)',
                              labelStyle: utils.getTextStyleRegular(fontSize: 14, weight: FontWeight.w700)
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: Text(
                                  '-- Sila pilih kategori --',
                                  style: utils.getTextStyleRegular(fontSize: 16)
                                ),
                                value: _codeValue,
                                onChanged: (String? value) {
                                  state.didChange(value);
                                  setState(() {
                                    _codeValue = value;
                                  });
                                },
                                items: _itemList.map((elem) {
                                  return DropdownMenuItem<String>(
                                    value: elem['value'],
                                    child: Text(
                                      elem['name'],
                                      // maxLines: 1,
                                      // overflow: TextOverflow.ellipsis,
                                      style: utils.getTextStyleRegular(fontSize: 16)
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            state.hasError ? state.errorText! : '',
                            style:
                                TextStyle(color: Colors.redAccent.shade700, fontSize: 12.0),
                          ),
                        ],
                      );
                    },
                  )
                ),
                const SizedBox(height: 30)
              ]
            )
          )
        ]
      )
    );
  }

  String? _validateField(String? value) {
    if ((value?.isEmpty) as bool) {
      return utils.getTranslated('fieldRequired', context);
    } else {
      return null;
    }
  }

  String? _validateDDItem(String? value) {
    if (value == null) {
      return utils.getTranslated('categorySelectMsg', context);
    } else {
      return null;
    }
  }

  void _submitUpdateEducation() {
    if (_formKey.currentState!.validate()) {
      // No any error in validation
      _formKey.currentState!.save();

      showDialog(
        barrierColor: Colors.transparent.withOpacity(0.3),
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future(() => true);
            },
            child: DirectDialogState(
              title: utils.getTranslated('update', context),
              messages: utils.getTranslated('saveAndUpdateGeneralSkills', context),
              buttonName: utils.getTranslated('yes', context),
              onCallback: () {
                Map _body = {
                  'Height': getUserHeight.text,
                  'Weight': getUserWeight.text,
                  'JobCurrentPosition': getUserOccupation.text,
                  'JobCurrentCompanyName': getUserEmployee.text,
                  'JobCurrentSalary': getUserSalary.text,
                  'ExpectedSalary': _codeValue
                };

                debugPrint('_body_body $_body');
                utils.showLoadingDialog(context, _keyLoader);
                _veteranEducationService?.updateVeteranEducationData(token: _token, body: _body).then((response) {
                  Navigator.of(_keyLoader.currentContext!).pop();
                  if (response.returnCode == 200) {
                    int count = 0;
                    Navigator.of(context).popUntil((_) => count++ >= 2);
                    utils.showSnackBar(context, response.responseMessage!, 'success');
                  } else {
                    utils.showSnackBar(context, response.responseMessage!, 'fail');
                  }
                }).catchError((onError) {
                  debugPrint('errrr update education $onError');
                  Navigator.of(_keyLoader.currentContext!).pop();
                  utils.showSnackBar(context, 'Network server error', 'fail');
                });
                // Future.delayed(const Duration(seconds: 2), () {});
              },    
            )
          );
        }
      );
    } else {
      debugPrint('have error');
    }
  }
}