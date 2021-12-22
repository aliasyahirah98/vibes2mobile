import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:myveteran/blocs/course/course_bloc.dart';
import 'package:myveteran/core/models/course/course_details_model.dart';
import 'package:myveteran/core/provider/response.dart';
import 'package:myveteran/core/services/course/course_service.dart';
import 'package:myveteran/shared/components/custom_button/button_round.dart';
import 'package:myveteran/shared/components/dialog/direct_dialog.dart';
import 'package:myveteran/shared/components/error_handling/error_sync.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';
import 'package:myveteran/views/home/panel_service/course_opportunity/course_opportunity.dart';
import 'package:shimmer/shimmer.dart';

class CourseListDetailsState extends StatefulWidget {
  final String? courseNo;

  const CourseListDetailsState({Key? key, required this.courseNo}) : super(key: key);
  
  @override
  _CourseListDetailsState createState() => _CourseListDetailsState();
}

class _CourseListDetailsState extends State<CourseListDetailsState> {
  final ScrollController scrollController = ScrollController();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  String? _token;
  double _offSet = 0.0;

  CourseBloc? _bloc;
  CourseService? _courseService;

  @override
  void initState() {
    super.initState();

    _bloc = CourseBloc();
    _courseService = CourseService();

    utils.getToken()!.then((value) {
      _token = value;
      _bloc!.loadCourseDetails(token: _token, courseNo: widget.courseNo);
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
            utils.getTranslated('trainingOffer', context),
            style: utils.getTextStyleRegular(color: mainColor, fontSize: 22, weight: FontWeight.bold)
          ),
          backgroundColor: Colors.white
        ),
        backgroundColor: Colors.white,
        body: StreamBuilder<Response<CourseDetailsModel?>>(
          stream: _bloc!.resultStreamDetails,
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
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 80,
                              height: 8.0,
                              color: Colors.white
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              height: 8.0,
                              color: Colors.white
                            )
                          ],
                        ),
                      ),
                      itemCount: 15,
                    )
                  );
                case Status.completed:
                  return snapshot.data!.data!.returnCode == 200 ? _informationItem(snapshot.data!.data!) : utils.noDataFound(context);
                case Status.error:
                  return ErrorSync(
                    errorMessage: snapshot.data!.message,
                    onRetryPressed: () => _bloc!.loadCourseDetails(token: _token, courseNo: widget.courseNo)
                  );
              }
            }
            return Container();
          }
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
            btnName: utils.getTranslated('apply', context),
            borderColor: Colors.white,
            btnColor: secondColor,
            colorTitle: Colors.white,
            onSubmit: () {
              Map _body = {
                'CourseId': widget.courseNo
              };

              utils.showLoadingDialog(context, _keyLoader);
              _courseService?.applyCourseData(token: _token, body: _body).then((response) {
                Navigator.of(_keyLoader.currentContext!).pop();

                if (response.returnCode == 200) {
                  utils.showSnackBar(context, response.responseMessage!, 'success');
                  
                  showDialog(
                    barrierColor: Colors.transparent.withOpacity(0.3),
                    context: context,
                    builder: (BuildContext context) {
                      return WillPopScope(
                        onWillPop: () {
                          return Future(() => true);
                        },
                        child: DirectDialogState(
                          title: utils.getTranslated('applicationInProcess', context).toUpperCase(),
                          messages: utils.getTranslated('viewApplicationProcessMsg', context),
                          buttonName: utils.getTranslated('statusReview', context).toUpperCase(),
                          onCallback: () {
                            debugPrint('Semakan Kursus');
                            // int count = 0;
                            // Navigator.of(context).popUntil((_) => count++ >= 2);
                            Navigator.of(context).popUntil((route) => route.isFirst);
                            Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => const CourseOpportunityState(selectedTab: 1)));
                          },    
                        )
                      );
                    }
                  );
                } else {
                  utils.showSnackBar(context, response.responseMessage!, 'fail');
                }
              }).catchError((onError) {
                debugPrint('errrr course $onError');
                Navigator.of(_keyLoader.currentContext!).pop();
                utils.showSnackBar(context, 'Network server error', 'fail');
              });
            }
          ),
        )
      )
    );
  }

  Widget _informationItem(CourseDetailsModel item) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: <Widget>[
          _headerCareerInfo(item),
          const SizedBox(height: 15),
          _itemDetails(label: utils.getTranslated('location', context), details: item.locationName, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('dateOfCourse', context), details: item.eventStartDate! + ' ' + item.eventEndDate!, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('timeOfCourse', context), details: item.eventStartTime! + ' - ' + item.eventEndTime!, hasMultiInfo: false),
          const SizedBox(height: 15),
          const Divider(height: 3),
          const SizedBox(height: 15),
          _itemDetails(label: utils.getTranslated('categoryOfCourse', context), details: item.category, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('targetGroup', context), details: item.cTrainingTargetGroup, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('syllabus', context), details: item.learningMtd, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('moduleList', context), details: item.modulList, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('potentialForCareerFields', context), details: item.careerProspect, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('vacancyNo', context), details: item.noOfAttendance, hasMultiInfo: false),
          const SizedBox(height: 15),
          const Divider(height: 3),
          Container(
            padding: const EdgeInsets.only(top: 20, bottom: 15, left: 20, right: 20),
            child: Text(
              utils.getTranslated('officersDetailsWhoManagesTheRecruitmentOfTrainingParticipants', context),
              style: utils.getTextStyleRegular(fontSize: 14, color: secondColor, fontStyle: FontStyle.italic),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          ),
          _itemDetails(label: utils.getTranslated('officerName', context), details: item.contactName, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('officerEmail', context), details: item.contactEmel, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('officerPhoneNo', context), details: item.contactNo, hasMultiInfo: false),
        ]
      )
    );
  }

  Widget _headerCareerInfo(CourseDetailsModel item) {
    return Column(
      children: <Widget>[
        Container(
          height: 250,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[300]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 60,
                width: 60,
                child: CircleAvatar(
                  child: Image.asset('assets/images/logo.png', fit: BoxFit.contain)
                )
              ),
              const SizedBox(height: 15),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  item.category!, //item.description!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: utils.getTextStyleRegular(color: Colors.black, fontSize: 17, weight: FontWeight.w700),
                )
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  item.name!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: utils.getTextStyleRegular(color: Colors.black87, fontSize: 14),
                )
              ),
              const SizedBox(height: 15),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  item.locationName!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: utils.getTextStyleRegular(color: Colors.black, fontSize: 14, weight: FontWeight.w700),
                )
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(text: utils.getTranslated('broadcastAt', context) + ' ', style: utils.getTextStyleRegular(fontSize: 14, color: Colors.black54, fontStyle: FontStyle.italic)),
                        TextSpan(text: item.eventStartDate!, style: utils.getTextStyleRegular(fontSize: 14, color: Colors.black54, fontStyle: FontStyle.italic, weight: FontWeight.w700))
                      ]
                    ),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(text: utils.getTranslated('closedAt', context) + ' ', style: utils.getTextStyleRegular(fontSize: 14, color: Colors.black54, fontStyle: FontStyle.italic)),
                        TextSpan(text: item.eventEndDate!, style: utils.getTextStyleRegular(fontSize: 14, color: Colors.black54, fontStyle: FontStyle.italic, weight: FontWeight.w700))
                      ]
                    ),
                  ),
                ]
              ),
            ]
          )
        )
      ]
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
            child: Text(
              label!,
              style: utils.getTextStyleRegular(fontSize: 14, color: secondColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ),
          details != '' ? Container(
            padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
            child: Text(
              details!,
              style: utils.getTextStyleRegular(fontSize: 16, color: Colors.black),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          ) : Container(),
          if (hasMultiInfo!) 
            moreDetails!
          else 
            Container(),
        ]
      ),
    );
  }
}