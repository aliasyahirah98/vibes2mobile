import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myveteran/blocs/welfare/welfare_bloc.dart';
import 'package:myveteran/core/models/welfare/welfare_list_model.dart';
import 'package:myveteran/core/provider/response.dart';
import 'package:myveteran/shared/components/error_handling/error_sync.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';
import 'package:flutter/material.dart';
import 'package:myveteran/views/home/panel_service/welfare/welfare_track/welfare_track_details.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';

class WelfareTrackState extends StatefulWidget {
  const WelfareTrackState({Key? key}) : super(key: key);
  
  @override
  _WelfareTrackState createState() => _WelfareTrackState();
}

class _WelfareTrackState extends State<WelfareTrackState> {
  final _storage = const FlutterSecureStorage();
  final ScrollController scrollController = ScrollController();

  Map<String, dynamic>? _user;
  String? _token, _userType;
  WelfareBloc? _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = WelfareBloc();
    utils.getToken()!.then((value) {
      _token = value;


      _getUserInfo()!.then((record) {
        _user = record;
        // debugPrint("_user!['identityId'] ${_user!['identidyId']}");
        _bloc!.loadWelfareList(token: _token, myKadNo: _user!['identidyId']); //'560113025219' //_user!['identidyId'] ?? '-' //find_me
      });
      // debugPrint('token $_token');
    });
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
        body: RefreshIndicator(
          color: mainColor,
          onRefresh: () {
            return _bloc!.loadWelfareList(token: _token, myKadNo: _user!['identidyId'] ?? '-');
          },
          child: StreamBuilder<Response<WelfareListModel?>>(
            stream: _bloc!.resultStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data!.status!) {
                  case Status.loading:
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      // enabled: _enabled,
                      child: ListView.builder(
                        itemBuilder: (_, __) => Container(
                          margin: const EdgeInsets.fromLTRB(3.0, 10.0, 3.0, 0.0),
                          // constraints: new BoxConstraints.expand(),
                          height: 155.0,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            enabled: true,
                            child: Container(
                              margin: const EdgeInsets.only(left: 3.0, right: 3.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.grey[300],
                                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),
                          ),
                        ),
                        itemCount: 5,
                      )
                    );
                  case Status.completed:
                    return snapshot.data!.data!.welfareList!.isNotEmpty ? ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: scrollController,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.data!.welfareList!.length,
                      itemBuilder: (BuildContext context, int index) => _informationItem(snapshot.data!.data!.welfareList![index])
                    ) : utils.noDataFound(context);
                  case Status.error:
                    return ErrorSync(
                      errorMessage: snapshot.data!.message,
                      onRetryPressed: () => _bloc!.loadWelfareList(token: _token, myKadNo: _user!['identidyId'] ?? '-')
                    );
                }
              }
              return Container();
            }
          )
        )
      )
    );
  }

  Widget _informationItem(WelfareInfoModel item) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: 170,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        utils.getTranslated('lastModified', context) + ' ' + item.bKAppSubmittedDate!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: utils.getTextStyleRegular(fontSize: 13, color: Colors.black, fontStyle: FontStyle.italic),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item.bKAppTypeName!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: utils.getTextStyleRegular(fontSize: 17, color: secondColor, weight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          // width: 100,
                          height: 25,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(15)),
                            // border: Border.all(width: 1.0, color: (Colors.grey[300])!),
                            color: Colors.green[400],
                          ),
                          child: Text(
                            item.bKAppStatusName!,
                            style: utils.getTextStyleRegular(fontSize: 12, color: Colors.white)
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 4,
                          height: 35,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            // border: Border.all(width: 1.0, color: (Colors.grey[300])!),
                            color: secondColor,
                          ),
                          child: Material(
                            shape: const StadiumBorder(),
                            color: Colors.transparent,
                            child: InkWell(
                              // customBorder: const CircleBorder(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    utils.getTranslated('view', context).toUpperCase() + ' >>',
                                    style: utils.getTextStyleRegular(fontSize: 14, color: Colors.white)
                                  )
                                ],
                              ),
                              onTap: () => {
                                Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => WelfareTrackDetailsState(
                                  bKAppCode: item.bKAppCode, //item.bKAppCode //find_me,
                                  bKAppSubmittedDate: item.bKAppSubmittedDate,
                                  bKAppTypeName: item.bKAppTypeName,
                                  bKAppStatusName: item.bKAppStatusName
                                )))
                              }
                            )
                          )
                        ),
                      ]
                    )
                  ]
                )
              )
            ]
          )
        ]
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