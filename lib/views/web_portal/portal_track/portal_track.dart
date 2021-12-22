import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';
import 'package:flutter/material.dart';

class PortalTrackState extends StatefulWidget {
  final String? pageName;

  const PortalTrackState({Key? key, this.pageName}) : super(key: key);
  
  @override
  _PortalTrackState createState() => _PortalTrackState();
}

class _PortalTrackState extends State<PortalTrackState> {

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
        body: ListView.builder(
          itemBuilder: (_, __) => Container(
            margin: const EdgeInsets.all(10),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      height: 170,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              utils.getTranslated('lastModified', context) + ': 28-02-2020',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: utils.getTextStyleRegular(fontSize: 13, color: Colors.black, fontStyle: FontStyle.italic),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Permohonan Tuntutan ${widget.pageName} Veteran',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: utils.getTextStyleRegular(fontSize: 17, color: secondColor, weight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: 100,
                                height: 25,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                                  // border: Border.all(width: 1.0, color: (Colors.grey[300])!),
                                  color: Colors.green[400],
                                ),
                                child: Text(
                                  'Lulus', //Gagal
                                  style: utils.getTextStyleRegular(fontSize: 12, color: Colors.white)
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 4,
                                height: 35,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  // border: Border.all(width: 1.0, color: (Colors.grey[300])!),
                                  color: secondColor,
                                ),
                                child: Material(
                                  shape: const StadiumBorder(),
                                  color: Colors.transparent,
                                  child: InkWell(
                                    // customBorder: const CircleBorder(),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          utils.getTranslated('view', context).toUpperCase() + ' >>',
                                          style: utils.getTextStyleRegular(fontSize: 14, color: Colors.white)
                                        )
                                      ],
                                    ),
                                    onTap: () => {
                                      if (widget.pageName == 'Perubatan' || widget.pageName == 'Medical') {
                                        Navigator.of(context).pushNamed(portalTrackMedical)
                                      } else  if (widget.pageName == 'Kebajikan' || widget.pageName == 'Welfare') {
                                        Navigator.of(context).pushNamed(portalTrackWelfare)
                                      } else  if (widget.pageName == 'BMJ') {
                                        Navigator.of(context).pushNamed(portalTrackBmj)
                                      }
                                    }
                                  )
                                )
                              ),
                            ]
                          )
                        ]
                      )
                    )
                  ]
                )
              ]
            ),
          ),
          itemCount: 5
        )
      )
    );
  }
}