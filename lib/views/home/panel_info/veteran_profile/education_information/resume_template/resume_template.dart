import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';

class ResumeTemplateState extends StatefulWidget {
  const ResumeTemplateState({Key? key}) : super(key: key);
  @override
  _ResumeTemplateState createState() => _ResumeTemplateState();
}

class _ResumeTemplateState extends State<ResumeTemplateState> {

  @override
  void initState() {
    super.initState();
    // loadDocument();
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
        appBar: AppBar(
          centerTitle: true,
          leading: utils.backHeaderButton(context, backIcon: CupertinoIcons.chevron_back),
          brightness: Brightness.light,
          title: Text(
            utils.getTranslated('generateResume', context),
            style: utils.getTextStyleRegular(color: mainColor, fontSize: 22, weight: FontWeight.bold)
          ),
          backgroundColor: Colors.white
        ),
        body: SizedBox(
          child: Image.asset(
            "assets/images/resume_template.png",
            // height: 80,
          )
          // _isLoading ? const Center(child: CircularProgressIndicator()) : PDFViewer(
          //   document: document!,
          //   zoomSteps: 1
          // )
          // )
        )
      )
    );
  }
}