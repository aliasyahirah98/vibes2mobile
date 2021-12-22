import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:myveteran/blocs/veteran/veteran_work_bloc.dart';
import 'package:myveteran/core/models/veteran/veteran_work_model.dart';
import 'package:myveteran/core/provider/response.dart';
import 'package:myveteran/shared/components/error_handling/error_sync.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';
import 'package:flutter/material.dart';
import 'package:myveteran/views/web_portal/portal_link/portal_link_direct.dart';
import 'package:shimmer/shimmer.dart';

class ServiceInformationState extends StatefulWidget {
  const ServiceInformationState({Key? key}) : super(key: key);
  
  @override
  _ServiceInformationState createState() => _ServiceInformationState();
}

class _ServiceInformationState extends State<ServiceInformationState> {
  final ScrollController scrollController = ScrollController();

  String? _token;
  double _offSet = 0.0;

  VeteranWorkBloc? _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = VeteranWorkBloc();
    utils.getToken()!.then((value) {
      _token = value;
      _bloc!.loadVeteranWork(token: _token);
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          leading: utils.backHeaderButton(context, backIcon: CupertinoIcons.chevron_back),
          brightness: Brightness.light,
          elevation: _offSet > 6 ? 1.0 : 0.0,
          title: Text(
            utils.getTranslated('servicesInformation', context),
            style: utils.getTextStyleRegular(color: mainColor, fontSize: 22, weight: FontWeight.bold)
          ),
          backgroundColor: Colors.white
        ),
        body: StreamBuilder<Response<VeteranWorkModel?>>(
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
                    onRetryPressed: () => _bloc!.loadVeteranWork(token: _token)
                  );
              }
            }
            return Container();
          }
        )
      )
    );
  }

  Widget _informationItem(VeteranWorkModel item) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: <Widget>[
          _itemDetails(label: utils.getTranslated('teamShippingBase', context), details: item.forceType, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('dateOfAccreditation', context), details: item.accreditationDate, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('ageOfCommencementOfService', context), details: item.ageWorkStart.toString(), hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('ageOfTerminationOfService', context), details: item.ageWorkEnd.toString(), hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('rank', context), details: item.rank, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('forceCategory', context), details: item.rankCategory, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('typeOfServices', context), details: item.serviceType, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('kor', context).toUpperCase(), details: item.kor, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('startingOfServicesDate', context), details: item.workStartDate, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('endDateOfServices', context), details: item.workEndDate, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('dateOfRetirement', context), details: item.retiredDate, hasMultiInfo: false),
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
}