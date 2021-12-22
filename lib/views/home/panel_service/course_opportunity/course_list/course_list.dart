import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:myveteran/blocs/course/course_bloc.dart';
import 'package:myveteran/core/models/course/course_list_model.dart';
import 'package:myveteran/core/provider/response.dart';
import 'package:myveteran/shared/components/error_handling/error_sync.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';
import 'package:flutter/material.dart';
import 'package:myveteran/views/home/panel_service/course_opportunity/course_list/course_list_details.dart';
import 'package:shimmer/shimmer.dart';

class CourseListState extends StatefulWidget {
  const CourseListState({Key? key}) : super(key: key);
  
  @override
  _CourseListState createState() => _CourseListState();
}

class _CourseListState extends State<CourseListState> {
  final ScrollController scrollController = ScrollController();

  String? _token;
  CourseBloc? _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = CourseBloc();
    utils.getToken()!.then((value) {
      _token = value;
      _bloc!.loadCourseList(token: _token);
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
        body: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width - 100,
                  height: 40,
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                      hintText: 'e.g. "Operator, Pengurus"',
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)
                      ),
                      hintStyle: utils.getTextStyleRegular(fontSize: 12, color: Colors.grey),
                    ),
                    style: utils.getTextStyleRegular(color: Colors.black, fontSize: 12),
                    // onChanged: _bloc.searchBillFilterList,
                  )
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: utils.cirlceRippleButton(
                    context,
                    icon: const Icon(CupertinoIcons.slider_horizontal_3, size: 30, color: secondColor),
                    color: Colors.grey[200],
                    onClick: () {
                      Navigator.of(context).pushNamed(courseListOption);
                    }
                  )
                ),
              ]
            ),
            Expanded(
              child: RefreshIndicator(
                color: mainColor,
                onRefresh: () {
                  return _bloc!.loadCourseList(token: _token);
                },
                child: StreamBuilder<Response<CourseListModel?>>(
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
                          return snapshot.data!.data!.courseList!.isNotEmpty ? ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: scrollController,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.data!.courseList!.length,
                            itemBuilder: (BuildContext context, int index) => _informationItem(snapshot.data!.data!.courseList![index])
                          ) : utils.noDataFound(context);
                        case Status.error:
                          return ErrorSync(
                            errorMessage: snapshot.data!.message,
                            onRetryPressed: () => _bloc!.loadCourseList(token: _token)
                          );
                      }
                    }
                    return Container();
                  }
                )
              )
            )
          ]
        )
      )
    );
  }

  Widget _informationItem(CourseInfoModel item) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: 260,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                item.organizationEventTypeCode!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: utils.getTextStyleRegular(color: Colors.black54, fontSize: 14),
                              ),
                              Text(
                                item.name!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: utils.getTextStyleRegular(color: secondColor, fontSize: 18, weight: FontWeight.w700),
                              )
                            ]
                          )
                        ),
                        SizedBox(
                          height: 60,
                          width: 60,
                          child: CircleAvatar(
                            child: Image.asset('assets/images/logo.png', fit: BoxFit.contain)
                          )
                        )
                      ]
                    ),
                    const SizedBox(height: 5),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item.orgRegistrationName!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: utils.getTextStyleRegular(color: secondColor, fontSize: 16),
                      )
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(CupertinoIcons.location, size: 18, color: Colors.grey[600]),
                        const SizedBox(width: 10),
                        Text(
                          item.orgAddressTown!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: utils.getTextStyleRegular(color: Colors.black, fontSize: 14),
                        )
                      ]
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(CupertinoIcons.calendar, size: 18, color: Colors.grey[600]),
                        const SizedBox(width: 10),
                        Text(
                          item.eventStartDate! + ' ' + item.eventEndDate!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: utils.getTextStyleRegular(color: Colors.black, fontSize: 14),
                        )
                      ]
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(CupertinoIcons.clock, size: 18, color: Colors.grey[600]),
                        const SizedBox(width: 10),
                        Text(
                          item.eventStartTime! + ' - ' + item.eventEndTime!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: utils.getTextStyleRegular(color: Colors.black, fontSize: 14),
                        )
                      ]
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 100,
                              height: 25,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(15)),
                                color: Colors.green[100]
                              ),
                              child: Text(
                                item.cTrainingTargetGroup!, //find_me_no_object
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: utils.getTextStyleRegular(fontSize: 12, color: Colors.green[900]!)
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 100,
                              height: 25,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(15)),
                                color: Colors.brown[100]
                              ),
                              child: Text(
                                item.qualify!, //find_me_no_object
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: utils.getTextStyleRegular(fontSize: 12, color: Colors.brown[900]!)
                              ),
                            ),
                          ]
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
                                Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => CourseListDetailsState(
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
      ),
    );
  }
}