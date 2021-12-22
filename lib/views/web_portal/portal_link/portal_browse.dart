import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:myveteran/shared/components/custom_button/button_round.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class PortalBrowseState extends StatefulWidget {
  final String? pageName;
  const PortalBrowseState({Key? key, @required this.pageName}) : super(key: key);
  
  @override
  _PortalBrowseState createState() => _PortalBrowseState();
}

class _PortalBrowseState extends State<PortalBrowseState> {
  InAppWebViewController? webViewController;
  String url = '';
  double progress = 0;

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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Image.asset(
                  'assets/images/browse_portal.png'
                )
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                margin: const EdgeInsets.all(15.0),
                child: Text(
                  utils.getTranslated('toMakeApplicationGoToPortalVibes', context) + ' ' + widget.pageName! + '.',
                  style: utils.getTextStyleRegular(fontSize: 16, color: secondColor),
                  textAlign: TextAlign.center,
                ),
              ),
              ButtonRound(
                width: MediaQuery.of(context).size.width - 50,
                btnName: 'Portal',
                borderColor: Colors.white,
                btnColor: secondColor,
                colorTitle: Colors.white,
                onSubmit: () {
                  _launchURL('https://vibes2uat.jhev.gov.my/vibes2dev/portal/default.asp');
                }
              ),
              const SizedBox(height: 50)
            ]
          )
        )
      ),
    );
  }

  void _launchURL(String? _url) async => await canLaunch(_url!) ? await launch(_url) : throw 'Could not launch $_url';
}