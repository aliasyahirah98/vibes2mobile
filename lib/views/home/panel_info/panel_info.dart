import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';
import 'package:myveteran/views/home/panel_info/veteran_card/veteran_card.dart';
import 'dart:convert';

import 'package:myveteran/views/home/panel_info/veteran_profile/veteran_profile.dart';

class PanelInfoState extends StatefulWidget {
  const PanelInfoState({Key? key}) : super(key: key);
  @override
  _PanelInfoState createState() => _PanelInfoState();
}

class _PanelInfoState extends State<PanelInfoState> {
  final _storage = const FlutterSecureStorage();

  Map<String, dynamic>? _user;
  String? _userType;
  double _paddingTop = 0.0;
  
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _paddingTop = MediaQuery.of(context).padding.top;

    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: 100,
          margin: EdgeInsets.only(top: _paddingTop + 60, left: 15.0, right: 15.0),
          child: FutureBuilder<dynamic>(
            future: _getUserInfo(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                _user = snapshot.data;
                
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: 90,
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _user!['fullname'] ?? '-',
                            style: utils.getTextStyleRegular(fontSize: 18, color: Colors.white),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            _user!['identidyId'] ?? '-',
                            style: utils.getTextStyleRegular(fontSize: 15, color: Colors.white)
                          ),
                        ]
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        const SizedBox(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width / 2 - 50,
                          height: 35,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            // border: Border.all(width: 1.0, color: (Colors.grey[300])!),
                            color: Color(0xFFFEE693),
                          ),
                          child: Material(
                            shape: const StadiumBorder(),
                            color: Colors.transparent,
                            child: InkWell(
                              // customBorder: const CircleBorder(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Icon(CupertinoIcons.person_circle, size: 20, color: Colors.black87),
                                  const SizedBox(width: 5),
                                  Text(
                                    _userType == '1' ? utils.getTranslated('veteranInfo', context) : utils.getTranslated('dependentInfo', context),
                                    style: utils.getTextStyleRegular(fontSize: 14, color: Colors.black87)
                                  ),
                                ],
                              ),
                              onTap: () => {
                                _userType == '1' ? 
                                  Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => VeteranProfileState(
                                    userInfo: _user,
                                  ))) : Navigator.of(context).pushNamed(personalInformation)
                              }
                            )
                          )
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width / 2 - 50,
                          height: 35,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            // border: Border.all(width: 1.0, color: (Colors.grey[300])!),
                            color: Color(0xFFFEE693),
                          ),
                          child: Material(
                            shape: const StadiumBorder(),
                            color: Colors.transparent,
                            child: InkWell(
                              // customBorder: const CircleBorder(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Icon(CupertinoIcons.doc_richtext, size: 20, color: Colors.black87),
                                  const SizedBox(width: 5),
                                  Text(
                                    utils.getTranslated('veteranCard', context),
                                    style: utils.getTextStyleRegular(fontSize: 14, color: Colors.black87)
                                  ),
                                ],
                              ),
                              onTap: () => {
                                Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => const VeteranCardState(userType: '1')))
                                // Navigator.of(context).pushNamed(veteranCard)
                              }
                            )
                          )
                        ),
                      ],
                    )
                  ],
                );
              }
              return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(secondColor)));
            }
          )
        )
      ]
    );
  }

  Future<dynamic>? _getUserInfo() async {
    final type = await _storage.read(key: 'type');
    _userType = type;

    final userInfo = await _storage.read(key: 'userInfo');
    return json.decode(userInfo!);
  }
}