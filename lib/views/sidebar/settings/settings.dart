import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myveteran/core/models/user/user_model.dart';
import 'package:myveteran/core/provider/localization_provider.dart';
import 'package:myveteran/core/services/user/user_service.dart';
import 'package:myveteran/shared/components/misc/animated_toggle.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';
import 'package:flutter/material.dart';
import 'package:myveteran/views/sidebar/settings/change_password/change_password.dart';
import 'package:myveteran/views/sidebar/settings/edit_profile/edit_profile.dart';
import 'package:myveteran/views/web_portal/portal_link/portal_link_direct.dart';
import 'package:provider/provider.dart';

class SettingsState extends StatefulWidget {
  final String? languageCode;

  const SettingsState({Key? key, this.languageCode}) : super(key: key);
  
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsState> {
  final _storage = const FlutterSecureStorage();

  UserModel? _user;
  UserService? _userService;

  String? _userType;

  @override
  void initState() {
    super.initState();
    _userService = UserService();
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
          leading: utils.backHeaderButton(context, backIcon: CupertinoIcons.chevron_back),
          brightness: Brightness.light,
          elevation: 1.0,
          title: Text(
            utils.getTranslated('settings', context),
            style: utils.getTextStyleRegular(color: mainColor, fontSize: 22, weight: FontWeight.bold)
          ),
          backgroundColor: Colors.white
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Column(
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
                                _user!.personIdentidyName ?? '-',
                                style: utils.getTextStyleRegular(fontSize: 19, color: Colors.black, weight: FontWeight.w700),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                _userType == '1' ? utils.getTranslated('veteranPension', context) : utils.getTranslated('dependent', context),
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
                  )
                ]     
              ),
              const SizedBox(height: 10),
              _itemMenu(label: utils.getTranslated('editProfile', context)),
              _itemMenu(label: utils.getTranslated('changePassword', context)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            utils.getTranslated('changeLanguage', context),
                            style: utils.getTextStyleRegular(color: Colors.black, fontSize: 15),
                          )
                        ),
                        AnimatedToggle(
                          values: const ['BM', 'ENG'],
                          initialPosition: widget.languageCode == 'ms' ? true : false,
                          onToggleCallback: (idx) {
                            setState(() {
                              Provider.of<LocalizationProvider>(context, listen: false).setLanguage(Locale(
                                languages[idx].languageCode!,
                                languages[idx].countryCode!,
                              ));
                            });
                          },
                          buttonColor: secondColor,
                          backgroundColor: const Color(0xFFcacaca),
                          textColor: const Color(0xFFFFFFFF),
                        ),
                      ],
                    ),
                    const Divider(height: 5),
                  ]
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            utils.getTranslated('notificationSettings', context),
                            style: utils.getTextStyleRegular(color: Colors.black, fontSize: 15),
                          )
                        ),
                        AnimatedToggle(
                          values: [utils.getTranslated('yes', context), utils.getTranslated('no', context)],
                          initialPosition: true,
                          onToggleCallback: (value) {
                            setState(() {
                              // print('value $value');
                              // _toggleValue = value;
                            });
                          },
                          buttonColor: secondColor,
                          backgroundColor: const Color(0xFFcacaca),
                          textColor: const Color(0xFFFFFFFF),
                        ),
                      ],
                    ),
                    const Divider(height: 5),
                  ]
                ),
              ),
              _itemMenu(label: utils.getTranslated('contactUs', context)),
            ]
          )
        )
      )
    );
  }

  Widget _itemMenu({@required String? label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text(
              label!,
              style: utils.getTextStyleRegular(color: Colors.black, fontSize: 15),
            ),
            trailing: const Icon(
              CupertinoIcons.arrow_right_circle,
              color: secondColor,
            ),
            onTap: () {
              if (label == 'Kemaskini Maklumat' || label == 'Edit Profile') {
                Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => EditProfileState(user: _user)));
              } else if (label == 'Tukar Kata Laluan' || label == 'Change Password') {
                 Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => const ChangePasswordState(), fullscreenDialog: true));
              } else if (label == 'Hubungi Kami' || label == 'Contact Us') {
                Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => PortalLinkDirectState(
                  pageName: utils.getTranslated('contactUs', context), linkUrl: 'https://www.jhev.gov.my/en/contact-us/head-office')
                ));
              }
            }
          ),
          const Divider(height: 5),
        ]
      ),
    );
  }

  Future<UserModel>? _getUserInfo() async {
    final type = await _storage.read(key: 'type');
    _userType = type;

    final token = await _storage.read(key: 'token');
    final result = await _userService!.fetchUserProfileData(token: token).then((response) {
      return response;
    }).catchError((onError) {
      debugPrint('onError $onError');
    });
    return result;
  }
}