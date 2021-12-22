import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PortalLinkState extends StatefulWidget {
  final String? pageName;
  final String? linkUrl;
  const PortalLinkState({Key? key, @required this.pageName, @required this.linkUrl}) : super(key: key);
  
  @override
  _PortalLinkState createState() => _PortalLinkState();
}

class _PortalLinkState extends State<PortalLinkState> {
  InAppWebViewController? webViewController;
  String url = "";
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
        // appBar: AppBar(
        //   centerTitle: true,
        //   leading: utils.backHeaderButton(context, type: 'close'),
        //   brightness: Brightness.light,
        //   elevation: 0.0,
        //   title: Text(widget.pageName!, style: utils.getTextStyleRegular(color: mainColor, fontSize: 22, weight: FontWeight.bold)),
        //   backgroundColor: Colors.white
        // ),
        body: SizedBox(
          child: Column(
            children: <Widget>[
              Container(
                // padding: EdgeInsets.all(10.0),
                child: progress < 1.0
                  ? LinearProgressIndicator(value: progress)
                  : Container()
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  decoration:
                  BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                  child: InAppWebView(
                    initialUrlRequest: URLRequest(
                      url: Uri.parse(widget.linkUrl!)
                    ),
                    initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                        
                      ),
                      ios: IOSInAppWebViewOptions(

                      ),
                      android: AndroidInAppWebViewOptions(
                        useHybridComposition: true
                      )
                    ),
                    onWebViewCreated: (InAppWebViewController controller) {
                      webViewController = controller;
                    },
                    onDownloadStart: (InAppWebViewController controller, Uri url) {
                      setState(() {
                        this.url = url.toString();
                      });
                    },
                    onLoadStop: (InAppWebViewController controller, url) async {
                      setState(() {
                        this.url = url.toString();
                      });
                    },
                    onProgressChanged: (InAppWebViewController controller, int progress) {
                      setState(() {
                        this.progress = progress / 100;
                      });
                    },
                  ),
                ),
              )
            ]
          )
        )
      ),
    );
  }
}