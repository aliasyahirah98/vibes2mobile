import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';

class NotificationsState extends StatefulWidget {
  const NotificationsState({Key? key}) : super(key: key);
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<NotificationsState> {
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
          elevation: _offSet > 6 ? 1.0 : 0.0,
          leading: utils.backHeaderButton(context, backIcon: CupertinoIcons.chevron_back),
          brightness: Brightness.light,
          title: Text(
            utils.getTranslated('notification', context),
            style: utils.getTextStyleRegular(color: mainColor, fontSize: 22, weight: FontWeight.bold)
          ),
          backgroundColor: Colors.white
        ),
        body: ListView.builder(
          controller: scrollController,
          itemCount: 10,
          itemBuilder: (context, index) => _notifItem()
        )
      )
    );
  }

  Widget _notifItem() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
        ),
        elevation: 5.0,
        color: Colors.white,
        child: Container(
          height: 125,
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 1.4,
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Tarikh akhir pengemaskinian bagi kelayakan bayaran khas',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: utils.getTextStyleRegular(color: secondColor, fontSize: 16, height: 1.3)
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '10-06-2021',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: utils.getTextStyleRegular(color: Colors.black87, fontSize: 13)
                    )
                  ],
                )
              ),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                  border: Border.all(width: 2.0, color: secondColor)
                ),
                child: Material(
                  shape: const StadiumBorder(),
                  color: Colors.grey[200],
                  child: const InkWell(
                    customBorder: CircleBorder(),
                    child: Icon(CupertinoIcons.mail_solid, color: secondColor, size: 25)
                  )
                )
              ),
              const SizedBox(width: 10),
              // const Icon(Icons.location_pin, size: 50, color: mainColor)
            ]
          )
        )
      )
    );
  }
}