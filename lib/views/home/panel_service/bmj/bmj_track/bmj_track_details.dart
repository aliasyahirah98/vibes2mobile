import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:myveteran/core/models/bmj/bmj_track_list_model.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';
import 'package:myveteran/views/web_portal/portal_link/portal_link_direct.dart';

class BmjTrackDetailsState extends StatefulWidget {
  final BmjTrackInfoModel? bmjItem;

  const BmjTrackDetailsState({Key? key, required this.bmjItem}) : super(key: key);
  
  @override
  _BmjTrackDetailsState createState() => _BmjTrackDetailsState();
}

class _BmjTrackDetailsState extends State<BmjTrackDetailsState> {
  final ScrollController scrollController = ScrollController();

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
        appBar: AppBar(
          centerTitle: true,
          leading: utils.backHeaderButton(context, backIcon: CupertinoIcons.chevron_back),
          brightness: Brightness.light,
          elevation: _offSet > 6 ? 1.0 : 0.0,
          title: Text(
            utils.getTranslated('bmj', context),
            style: utils.getTextStyleRegular(color: mainColor, fontSize: 22, weight: FontWeight.bold)
          ),
          backgroundColor: Colors.white
        ),
        backgroundColor: Colors.white,
        body: _informationItem(widget.bmjItem!)
      )
    );
  }

  Widget _informationItem(BmjTrackInfoModel item) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: <Widget>[
          _headerCareerInfo(item),
          const SizedBox(height: 15),
          _itemDetails(label: utils.getTranslated('type', context), details: item.applicationType, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('fullname', context), details: item.deceasedName, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('armyNo', context), details: '-', hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('icNoPassportNo', context), details: item.deceasedMyKad, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('dateOfBirth', context), details: item.deceasedBirthDate, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('age', context), details: item.deceasedAge, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('race', context), details: item.deceasedRace, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('gender', context), details: item.deceasedGender, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('dateOfDeath', context), details: item.deathDate, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('deathCertificateNoBurialPermitNo', context), details: item.deathCertNo, hasMultiInfo: false),
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

  Widget _headerCareerInfo(BmjTrackInfoModel item) {
    return Column(
      children: <Widget>[
        Container(
          height: 185,
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
                  item.applicationName!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
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
                    // width: 60,
                    height: 25,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      // border: Border.all(width: 1.0, color: (Colors.grey[300])!),
                      color: Colors.green[400],
                    ),
                    child: Text(
                      item.applicationStatusCode!,
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
                    item.applicationNo!,
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
                    item.applicationDate!,
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