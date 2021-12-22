import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';
import 'package:myveteran/views/web_portal/portal_link/portal_link_direct.dart';

class PortalTrackWelfareState extends StatefulWidget {
  const PortalTrackWelfareState({Key? key}) : super(key: key);
  
  @override
  _PortalTrackWelfareState createState() => _PortalTrackWelfareState();
}

class _PortalTrackWelfareState extends State<PortalTrackWelfareState> {
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
            utils.getTranslated('welfare', context),
            style: utils.getTextStyleRegular(color: mainColor, fontSize: 22, weight: FontWeight.bold)
          ),
          backgroundColor: Colors.white
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: <Widget>[
              _headerCareerInfo(),
              const SizedBox(height: 15),
              _itemDetails(label: utils.getTranslated('applicantName', context), details: 'Azli Bin Rahman', hasMultiInfo: false),
              _itemDetails(label: utils.getTranslated('applicantMyKadNo', context), details: '560518148956', hasMultiInfo: false),
              _itemDetails(label: utils.getTranslated('applicationDate', context), details: '31-Jan-2020', hasMultiInfo: false),
              _itemDetails(label: utils.getTranslated('bankName', context), details: 'Maybank', hasMultiInfo: false),
              _itemDetails(label: utils.getTranslated('bankAccountNo', context), details: '1234 4523 5636 8956', hasMultiInfo: false),
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
        )
      )
    );
  }

  Widget _headerCareerInfo() {
    return Column(
      children: <Widget>[
        Container(
          height: 100,
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
                  'Skim Bantuan',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: utils.getTextStyleRegular(color: secondColor, fontSize: 20, weight: FontWeight.w700),
                )
              ),
              const SizedBox(height: 5),
              Row(
                children: <Widget>[
                  Text(
                    utils.getTranslated('status', context),
                    style: utils.getTextStyleRegular(fontSize: 15, color: Colors.black, weight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(width: 5),
                  Container(
                    width: 60,
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
                      'Lulus',
                      style: utils.getTextStyleRegular(fontSize: 12, color: const Color(0xFFFFFFFF)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
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