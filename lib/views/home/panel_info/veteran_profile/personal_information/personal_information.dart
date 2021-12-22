import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myveteran/shared/components/dialog/direct_dialog.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';
import 'package:flutter/material.dart';
import 'package:myveteran/views/web_portal/portal_link/portal_link_direct.dart';
import 'dart:convert';

class PersonalInformationState extends StatefulWidget {
  const PersonalInformationState({Key? key}) : super(key: key);
  
  @override
  _PersonalInformationState createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformationState> {
  final _storage = const FlutterSecureStorage();
  final ScrollController scrollController = ScrollController();

  Map<String, dynamic>? _user;
  String? _userType;

  double _offSet = 0.0;

  @override
  void initState() {
    super.initState();

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
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          leading: utils.backHeaderButton(context, backIcon: CupertinoIcons.chevron_back),
          brightness: Brightness.light,
          elevation: _offSet > 6 ? 1.0 : 0.0,
          title: Text(
            utils.getTranslated('personalInformation', context),
            style: utils.getTextStyleRegular(color: mainColor, fontSize: 22, weight: FontWeight.bold)
          ),
          backgroundColor: Colors.white
        ),
        body: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 50.0,
                  backgroundImage: const NetworkImage('https://www.occrp.org/assets/common/staff/male.png'),
                  backgroundColor: Colors.grey[300],
                )
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: FutureBuilder<dynamic>(
                  future: _getUserInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      _user = snapshot.data;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            _user!['fullname'] ?? '-',
                            style: utils.getTextStyleRegular(fontSize: 19, color: Colors.black, weight: FontWeight.w700),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            _user!['identidyId'] ?? '-',
                            style: utils.getTextStyleRegular(fontSize: 15, color: Colors.black)
                          ),
                        ]
                      );
                    }
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      // padding: const EdgeInsets.all(10),
                      child: const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(secondColor)))
                    );
                  }
                )
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 20, bottom: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
                  ),
                  color: const Color(0xFFEBEBEB),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  padding: const EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    utils.getTranslated('veteranPension', context),
                    style: utils.getTextStyleRegular(fontSize: 17, color: Colors.black) //fontStyle: FontStyle.italic
                  )
                )
              ),
              _itemDetails(label: utils.getTranslated('armyNo', context), details: '124558', hasMultiInfo: false),
              _itemDetails(label: utils.getTranslated('icNo', context), details: '560518148956', hasMultiInfo: false),
              _itemDetails(label: utils.getTranslated('totalAmount', context), details: 'RM 121,322.15', hasMultiInfo: false),
              // _itemDetails(label: utils.getTranslated('veteranFrom', context), details: '05/06/2010', hasMultiInfo: false),
              // _itemDetails(label: utils.getTranslated('status', context), details: 'Aktif', hasMultiInfo: false),
              // _itemDetails(label: utils.getTranslated('backgroundService', context), details: 'Tentera Darat dari 01-Jan-1978 ke 05-Jun-2001', hasMultiInfo: false),
              _itemDetails(label: utils.getTranslated('contactDetails', context), details: '', hasMultiInfo: true, moreDetails: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _moreItemDetails(label: utils.getTranslated('permanentAddress', context), details: 'No 32, Jalan Besar 2/3, Taman Besar, Bandar Melaka, 75100 Melaka.'),
                        _moreItemDetails(label: utils.getTranslated('maillingAddress', context), details: 'No 32, Jalan Besar 2/3, Taman Besar, Bandar Melaka, 75100 Melaka.'),
                        _moreItemDetails(label: utils.getTranslated('mobileNo', context), details: '012-2356895'),
                        _moreItemDetails(label: utils.getTranslated('officePhoneNo', context), details: '06-1234567'),
                        _moreItemDetails(label: utils.getTranslated('email', context), details: 'azlirahman@gmail.com')
                      ]
                    )
                  ),
                  const Divider(height: 10),
                ],
              )),
              _itemDetails(label: utils.getTranslated('bankDetails', context), details: '', hasMultiInfo: true, moreDetails: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _moreItemDetails(label: utils.getTranslated('bankName', context), details: 'Maybank'),
                        _moreItemDetails(label: utils.getTranslated('bankAccountNo', context), details: '1234 5678 9213 1241')
                      ]
                    )
                  ),
                  const Divider(height: 10),
                ],
              )),
              _itemDetails(label: utils.getTranslated('benefitReceived', context), details: '', hasMultiInfo: true, moreDetails: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 5, left: 15, right: 20),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        _itemBadge(label: 'PENCEN'),
                        _itemBadge(label: 'BSH'),
                        _itemBadge(label: 'IPTA')
                      ]
                    )
                  ),
                  const Divider(height: 10),
                ],
              )),
              _itemDetails(label: utils.getTranslated('awardReceived', context), details: 'PJM. Tarikh diterima: 12/01/2019', hasMultiInfo: false),
              _itemDetails(label: utils.getTranslated('associationList', context), details: 'PERSATUAN VETERAN KELUARGA IBRAHIM, PERSATUAN VETERAN DASDSA', hasMultiInfo: false),
              Stack(
                children: <Widget>[
                  Container(
                    // elevation: 4.0,
                    width: MediaQuery.of(context).size.width,
                    height: 110,
                    margin: const EdgeInsets.only(top: 50, left: 15.0, right: 15.0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      // border: Border.all(width: 1.0, color: (Colors.grey[300])!),
                      color: Color(0xFFC2AA92),
                    )
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 130,
                    margin: const EdgeInsets.only(top: 20, bottom: 40, left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border: Border.all(width: 1.0, color: (Colors.grey[300])!),
                      color: const Color(0xFFD2D2D2),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(height: 10),
                          Text(
                            utils.getTranslated('toUpdateYourInformationPleaseGoToPortalVibes', context),
                            textAlign: TextAlign.center,
                            style: utils.getTextStyleRegular(fontSize: 14, color: Colors.black)
                          ),
                          const SizedBox(height: 5),
                          TextButton(
                            child: Text(
                              utils.getTranslated('tapHereToLoginPortal', context),
                              style: utils.getTextStyleRegular(fontSize: 16, color: secondColor, weight: FontWeight.w700)
                            ),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => const PortalLinkDirectState(pageName: 'Portal', linkUrl: 'https://vibes2uat.jhev.gov.my/vibes2dev/portal/default.asp')));
                            }
                          ),
                        ],
                      )
                    )
                  )
                ]
              )
            ]
          ),
        )
      )
    );
  }

  Widget _itemDetails({@required String? label, @required String? details, bool? hasMultiInfo, Widget? moreDetails}) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
            child: label!.contains('Bank') ? Row(
              children: <Widget>[
                Text(
                  label,
                  style: utils.getTextStyleRegular(fontSize: 16, color: Colors.black, weight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(width: 5),
                utils.cirlceRippleButton(
                  context,
                  icon: const Icon(CupertinoIcons.info_circle_fill, size: 20, color: secondColor),
                  color: Colors.transparent,
                  onClick: () {
                    showDialog(
                      barrierColor: Colors.transparent.withOpacity(0.3),
                      context: context,
                      builder: (BuildContext context) {
                        return WillPopScope(
                          onWillPop: () {
                            return Future(() => true);
                          },
                          child: DirectDialogState(
                            title: utils.getTranslated('attention', context).toUpperCase(),
                            messages: utils.getTranslated('pleaseUpdateYourDependentsInformationOnPortalVibes', context),
                            buttonName: utils.getTranslated('yes', context),
                            onCallback: () {
                              debugPrint('Ya');
                              Navigator.of(context).pop();
                            },    
                          )
                        );
                      }
                    );
                  }
                )
              ]
            ) : Text(
              label,
              style: utils.getTextStyleRegular(fontSize: 16, color: Colors.black, weight: FontWeight.w700),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ),
          details != '' ? Container(
            padding: const EdgeInsets.only(bottom: 5, left: 20, right: 20),
            child: Text(
              details!,
              style: utils.getTextStyleRegular(fontSize: 14, color: Colors.black),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          ) : Container(),
          if (hasMultiInfo!) 
            moreDetails!
          else 
          const Divider(height: 10),
        ]
      ),
    );
  }

  Widget _moreItemDetails({@required String? label, @required String? details}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget> [
        Container(
          padding: const EdgeInsets.only(top: 10, bottom: 5, left: 30, right: 30),
          child: label!.contains('Alamat') ? Row(
            children: <Widget>[
              Text(
                label,
                style: utils.getTextStyleRegular(fontSize: 15, color: Colors.black, weight: FontWeight.w500), //fontStyle: FontStyle.italic
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(width: 5),
              utils.cirlceRippleButton(
                context,
                icon: const Icon(CupertinoIcons.info_circle_fill, size: 20, color: secondColor),
                color: Colors.transparent,
                onClick: () {
                  showDialog(
                    barrierColor: Colors.transparent.withOpacity(0.3),
                    context: context,
                    builder: (BuildContext context) {
                      return WillPopScope(
                        onWillPop: () {
                          return Future(() => true);
                        },
                        child: DirectDialogState(
                          title: 'PERHATIAN',
                          messages: 'Sila kemaskini Alamat anda di portal VIBES 2.0',
                          buttonName: 'Ya',
                          onCallback: () {
                            debugPrint('Ya');
                            Navigator.of(context).pop();
                          },    
                        )
                      );
                    }
                  );
                }
              ),
              // Container(
              //   width: 60,
              //   height: 25,
              //   alignment: Alignment.center,
              //   margin: const EdgeInsets.only(left: 5),
              //   padding: const EdgeInsets.symmetric(horizontal: 10),
              //   decoration: BoxDecoration(
              //     borderRadius: const BorderRadius.all(Radius.circular(15)),
              //     // border: Border.all(width: 1.0, color: (Colors.grey[300])!),
              //     color: Colors.green[400],
              //   ),
              //   child: Text(
              //     'Aktif',
              //     style: utils.getTextStyleRegular(fontSize: 12, color: const Color(0xFFFFFFFF)),
              //     maxLines: 1,
              //     overflow: TextOverflow.ellipsis,
              //   ),
              // )
            ]
          ) : Text(
            label,
            style: utils.getTextStyleRegular(fontSize: 15, color: Colors.black, weight: FontWeight.w500), //fontStyle: FontStyle.italic
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 5, left: 40, right: 40),
          child: Text(
            details!,
            style: utils.getTextStyleRegular(fontSize: 13, color: Colors.black),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          )
        )
      ]
    );
  }

  Widget _itemBadge({@required String? label}) {
    return Container(
      width: 100,
      height: 25,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(left: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        // border: Border.all(width: 1.0, color: (Colors.grey[300])!),
        color: secondColor,
      ),
      child: Text(
        label!,
        style: utils.getTextStyleRegular(fontSize: 12, color: const Color(0xFFFFFFFF)),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Future<dynamic>? _getUserInfo() async {
    final type = await _storage.read(key: 'type');
    _userType = type;

    final userInfo = await _storage.read(key: 'userInfo');
    return json.decode(userInfo!);
  }
}