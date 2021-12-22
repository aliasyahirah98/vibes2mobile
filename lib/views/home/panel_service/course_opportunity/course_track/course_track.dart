import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:myveteran/blocs/course/course_bloc.dart';
import 'package:myveteran/core/models/course/course_track_list_model.dart';
import 'package:myveteran/core/provider/response.dart';
import 'package:myveteran/shared/components/error_handling/error_sync.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';
import 'package:flutter/material.dart';
import 'package:myveteran/views/home/panel_service/course_opportunity/course_track/course_track_details.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CourseTrackState extends StatefulWidget {
  const CourseTrackState({Key? key}) : super(key: key);
  
  @override
  _CourseTrackState createState() => _CourseTrackState();
}

class _CourseTrackState extends State<CourseTrackState> {
  final _storage = const FlutterSecureStorage();
  final ScrollController scrollController = ScrollController();

  String? _token;
  CourseBloc? _bloc;
  Map<String, dynamic>? _user;

  @override
  void initState() {
    super.initState();

    _bloc = CourseBloc();
    utils.getToken()!.then((value) {
      _token = value;

      _getUserInfo()!.then((record) {
        _user = record;
        debugPrint('widget.myKad ${_user!['identidyId']}');

        _bloc!.loadCourseTrackList(token: _token, myKad: _user!['identidyId']);
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
            return _bloc!.loadCourseTrackList(token: _token, myKad: _user!['identidyId']);
          },
          child: StreamBuilder<Response<CourseTrackListModel?>>(
            stream: _bloc!.resultStreamTrack,
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
                    return snapshot.data!.data!.courseTrackList!.isNotEmpty ? ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: scrollController,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.data!.courseTrackList!.length,
                      itemBuilder: (BuildContext context, int index) => _informationItem(snapshot.data!.data!.courseTrackList![index])
                    ) : utils.noDataFound(context);
                  case Status.error:
                    return ErrorSync(
                      errorMessage: snapshot.data!.message,
                      onRetryPressed: () => _bloc!.loadCourseTrackList(token: _token, myKad: _user!['identidyId'])
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

  Widget _informationItem(CourseTrackInfoModel item) {
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
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        utils.getTranslated('lastModified', context) + ' ', //find_me_no_object
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: utils.getTextStyleRegular(fontSize: 13, color: Colors.black, fontStyle: FontStyle.italic),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item.name!, //find_me_object_clarify
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: utils.getTextStyleRegular(fontSize: 17, color: secondColor, weight: FontWeight.w700),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item.organizationEventPersonTypeCode!, //find_me_object_clarify
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: utils.getTextStyleRegular(fontSize: 15, color: Colors.grey[600]!, weight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          // width: 130,
                          height: 25,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(15)),
                            // border: Border.all(width: 1.0, color: (Colors.grey[300])!),
                            color: Colors.orange[600],
                          ),
                          child: Text(
                            item.status!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
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
                                    utils.getTranslated('view', context).toUpperCase()+ ' >>',
                                    style: utils.getTextStyleRegular(fontSize: 14, color: Colors.white)
                                  )
                                ],
                              ),
                              onTap: () => {
                                Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => CourseTrackDetailsState(
                                  courseNo: item.no
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
      )
    );
  }

  Future<dynamic>? _getUserInfo() async {
    final userInfo = await _storage.read(key: 'userInfo');
    return json.decode(userInfo!);
  }
}