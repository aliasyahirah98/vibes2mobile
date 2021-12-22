import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:myveteran/blocs/career/career_bloc.dart';
import 'package:myveteran/core/models/career/career_track_details_model.dart';
import 'package:myveteran/core/provider/response.dart';
import 'package:myveteran/shared/components/error_handling/error_sync.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';
import 'package:myveteran/views/web_portal/portal_link/portal_link_direct.dart';
import 'package:shimmer/shimmer.dart';

class CareerTrackDetailsState extends StatefulWidget {
  final String? applyJobNo;
  
  const CareerTrackDetailsState({Key? key, required this.applyJobNo}) : super(key: key);
  
  @override
  _CareerTrackDetailsState createState() => _CareerTrackDetailsState();
}

class _CareerTrackDetailsState extends State<CareerTrackDetailsState> {
  final ScrollController scrollController = ScrollController();

  String? _token;
  double _offSet = 0.0;

  CareerBloc? _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = CareerBloc();
    utils.getToken()!.then((value) {
      _token = value;
      _bloc!.loadCareerTrackDetails(token: _token, applyJobNo: widget.applyJobNo.toString());
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
            utils.getTranslated('careerOffer', context),
            style: utils.getTextStyleRegular(color: mainColor, fontSize: 22, weight: FontWeight.bold)
          ),
          backgroundColor: Colors.white
        ),
        backgroundColor: Colors.white,
        body: StreamBuilder<Response<CareerTrackDetailsModel?>>(
          stream: _bloc!.resultStreamTrackDetails,
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
                    onRetryPressed: () => _bloc!.loadCareerTrackDetails(token: _token, applyJobNo: widget.applyJobNo.toString())
                  );
              }
            }
            return Container();
          }
        )
      )
    );
  }

  Widget _informationItem(CareerTrackDetailsModel item) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: <Widget>[
          _headerCareerInfo(item),
          const SizedBox(height: 15),
          _itemDetails(label: utils.getTranslated('companyName', context), details: '-', hasMultiInfo: false), //item.companyName //find_me_no_object
          _itemDetails(label: utils.getTranslated('applicationDeadline', context), details: item.registraterEndDate, hasMultiInfo: false), //item.applicationDeadline //find_me_no_object
          _itemDetails(label: utils.getTranslated('position', context), details: '-', hasMultiInfo: false), //item.position //find_me_no_object
          _itemDetails(label: utils.getTranslated('field', context), details: item.category, hasMultiInfo: false), //item.field //find_me_no_object
          _itemDetails(label: utils.getTranslated('jobDescription', context), details: item.description, hasMultiInfo: false), //find_me_object_clarify
          _itemDetails(label: utils.getTranslated('minimumQualification', context), details: item.qualify, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('expertise', context), details: item.expertise, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('jobType', context), details: item.jobFullOrPartTime, hasMultiInfo: false), //find_me_no_object
          _itemDetails(label: utils.getTranslated('salaryOffer', context), details: item.jobSalary, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('vacancyNo', context), details: item.noOfPosition.toString(), hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('bmiRequirement', context), details: item.bmi, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('ageLimit', context), details: item.ageRange, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('jobLocation', context), details: item.companyInterviewLocation, hasMultiInfo: false), //find_me_object_clarify
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
      )
    );
  }

  Widget _headerCareerInfo(CareerTrackDetailsModel item) {
    return Column(
      children: <Widget>[
        Container(
          height: 155,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[300]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  item.description!, //find_me_object_clarify
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: utils.getTextStyleRegular(color: secondColor, fontSize: 20, weight: FontWeight.w700),
                )
              ),
              const SizedBox(height: 5),
              Row(
                children: <Widget>[
                  Text(
                    utils.getTranslated('applicantStatus', context) + ' :',
                    style: utils.getTextStyleRegular(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(width: 5),
                  Container(
                    // width: 100,
                    height: 25,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      // border: Border.all(width: 1.0, color: (Colors.grey[300])!),
                      color: Colors.deepPurpleAccent[700],
                    ),
                    child: Text(
                      item.status!,
                      style: utils.getTextStyleRegular(fontSize: 12, color: const Color(0xFFFFFFFF)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ]
              ),
              const SizedBox(height: 5),
              Row(
                children: <Widget>[
                  Text(
                    utils.getTranslated('applicationNo', context) + ' :',
                    style: utils.getTextStyleRegular(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    item.no!,
                    style: utils.getTextStyleRegular(fontSize: 14, weight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ]
              ),
              const SizedBox(height: 5),
              Row(
                children: <Widget>[
                  Text(
                    utils.getTranslated('applicationDate', context) + ' :',
                    style: utils.getTextStyleRegular(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    item.registraterDate!,
                    style: utils.getTextStyleRegular(fontSize: 14, weight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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