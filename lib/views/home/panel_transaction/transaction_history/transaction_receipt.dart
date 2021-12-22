import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myveteran/shared/components/dialog/direct_dialog.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';

class TransactionReceiptState extends StatefulWidget {
  const TransactionReceiptState({Key? key}) : super(key: key);
  @override
  _TransactionReceiptState createState() => _TransactionReceiptState();
}

class _TransactionReceiptState extends State<TransactionReceiptState> {
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  PDFDocument? document;
  bool _isLoading = true;

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
          leading: utils.backHeaderButton(context, type: 'close'),
          brightness: Brightness.light,
          title: Text(
            utils.getTranslated('paymentStatement', context),
            style: utils.getTextStyleRegular(color: mainColor, fontSize: 22, weight: FontWeight.bold)
          ),
          backgroundColor: Colors.white,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: utils.cirlceRippleButton(
                context,
                icon: const Icon(CupertinoIcons.cloud_download, size: 25, color: secondColor),
                color: Colors.transparent,
                onClick: () {
                  showDialog(
                    barrierColor: Colors.transparent.withOpacity(0.3),
                    context: context,
                    builder: (BuildContext context) {
                      return WillPopScope(
                        onWillPop: () {
                          return Future(() => true);
                        },
                        child: DirectDialogState(
                          title: 'BERJAYA DIMUAT TURUN',
                          messages: 'Penyata bayaran anda telah berjaya dimuat turun.',
                          buttonName: 'TUTUP',
                          onCallback: () {
                            debugPrint('Muat turun berjaya');
                            int count = 0;
                            Navigator.of(context).popUntil((_) => count++ >= 2);
                          },    
                        )
                      );
                    }
                  );
                }
              )
            ),
          ],
        ),
        body: SizedBox(
          child: Image.asset(
            "assets/images/receipt_sample.png",
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

  loadDocument() async {
    // utils.showLoadingDialog(context, _keyLoader);
    document = await PDFDocument.fromURL('http://www.africau.edu/images/default/sample.pdf');
    // Navigator.of(_keyLoader.currentContext!).pop();
    setState(() => _isLoading = false);
  }
}