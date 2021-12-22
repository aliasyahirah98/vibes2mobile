import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:myveteran/blocs/career/career_bloc.dart';
import 'package:myveteran/core/models/career/career_details_model.dart';
import 'package:myveteran/core/provider/response.dart';
import 'package:myveteran/core/services/career/career_service.dart';
import 'package:myveteran/shared/components/custom_button/button_round.dart';
import 'package:myveteran/shared/components/dialog/direct_dialog.dart';
import 'package:myveteran/shared/components/error_handling/error_sync.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';
import 'package:myveteran/views/home/panel_service/career_opportunity/career_opportunity.dart';
import 'package:shimmer/shimmer.dart';

class CareerListDetailsState extends StatefulWidget {
  final int? jobId;
  final String? orgRegistrationName;

  const CareerListDetailsState({Key? key, required this.jobId, this.orgRegistrationName}) : super(key: key);
  
  @override
  _CareerListDetailsState createState() => _CareerListDetailsState();
}

class _CareerListDetailsState extends State<CareerListDetailsState> {
  final ScrollController scrollController = ScrollController();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  String? _token;
  double _offSet = 0.0;

  CareerBloc? _bloc;
  CareerService? _careerService;

  @override
  void initState() {
    super.initState();

    _bloc = CareerBloc();
    _careerService = CareerService();

    utils.getToken()!.then((value) {
      _token = value;
      _bloc!.loadCareerDetails(token: _token, jobId: widget.jobId.toString());
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
        body: StreamBuilder<Response<CareerDetailsModel?>>(
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
                    onRetryPressed: () => _bloc!.loadCareerDetails(token: _token, jobId: widget.jobId.toString())
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
                'JobId': widget.jobId.toString()
              };

              utils.showLoadingDialog(context, _keyLoader);
              _careerService?.applyCareerData(token: _token, body: _body).then((response) {
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
                            debugPrint('Semakan Kerjaya');
                            // int count = 0;
                            // Navigator.of(context).popUntil((_) => count++ >= 2);
                            Navigator.of(context).popUntil((route) => route.isFirst);
                            Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => const CareerOpportunityState(selectedTab: 1)));
                          },    
                        )
                      );
                    }
                  );
                } else {
                  utils.showSnackBar(context, response.responseMessage!, 'fail');
                }
              }).catchError((onError) {
                debugPrint('errrr career $onError');
                Navigator.of(_keyLoader.currentContext!).pop();
                utils.showSnackBar(context, 'Network server error', 'fail');
              });
            }
          ),
        )
      )
    );
  }

  Widget _informationItem(CareerDetailsModel item) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: <Widget>[
          _headerCareerInfo(item),
          const SizedBox(height: 15),
          _itemDetails(label: utils.getTranslated('field', context), details: item.name, hasMultiInfo: false), //find_me_object_clarify
          _itemDetails(label: utils.getTranslated('jobDescription', context), details: item.description, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('jobType', context), details: '-', hasMultiInfo: false), //item.jobType //find_me_no_object
          _itemDetails(label: utils.getTranslated('minimumQualification', context), details: item.qualify, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('expertise', context), details: item.expertise, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('ageLimit', context), details: item.ageRange, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('bmi', context), details: item.bmi, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('vacancyNo', context), details: item.noOfPosition.toString(), hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('benefit', context), details: item.benefit, hasMultiInfo: false)
        ]
      )
    );
  }

  Widget _headerCareerInfo(CareerDetailsModel item) {
    return Column(
      children: <Widget>[
        Container(
          height: 280,
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
                  item.name!, //find_me_object_clarify
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: utils.getTextStyleRegular(color: Colors.black, fontSize: 20, weight: FontWeight.w700),
                )
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.orgRegistrationName!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: utils.getTextStyleRegular(color: Colors.black87, fontSize: 16),
                )
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  item.jobSalary!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: utils.getTextStyleRegular(color: Colors.black, fontSize: 18, weight: FontWeight.w700),
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