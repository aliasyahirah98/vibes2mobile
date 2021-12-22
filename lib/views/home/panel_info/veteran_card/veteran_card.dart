import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:myveteran/blocs/veteran/veteran_card_bloc.dart';
import 'package:myveteran/core/models/veteran/veteran_card_model.dart';
import 'package:myveteran/core/provider/response.dart';
import 'package:myveteran/shared/components/error_handling/error_sync.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class VeteranCardState extends StatefulWidget {
  final String? userType;
  const VeteranCardState({Key? key, this.userType}) : super(key: key);
  
  @override
  _VeteranCardState createState() => _VeteranCardState();
}

class _VeteranCardState extends State<VeteranCardState> {
  final ScrollController scrollController = ScrollController();

  String? _token;
  double _offSet = 0.0;

  VeteranCardBloc? _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = VeteranCardBloc();
    utils.getToken()!.then((value) {
      _token = value;
      _bloc!.loadVeteranCard(token: _token);
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
            utils.getTranslated('veteranCard', context),
            style: utils.getTextStyleRegular(color: mainColor, fontSize: 22, weight: FontWeight.bold)
          ),
          backgroundColor: Colors.white
        ),
        body: StreamBuilder<Response<VeteranCardModel?>>(
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
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 - 60,
                              height: 8.0,
                              color: Colors.white
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: MediaQuery.of(context).size.width / 3 - 30,
                              height: 8.0,
                              color: Colors.white
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: MediaQuery.of(context).size.width - 120,
                              height: 8.0,
                              color: Colors.white
                            )
                          ],
                        ),
                      ),
                      itemCount: 4,
                    )
                  );
                case Status.completed:
                  return snapshot.data!.data!.returnCode == 200 ? _informationCard(snapshot.data!.data!) : utils.noDataFound(context);
                case Status.error:
                  return ErrorSync(
                    errorMessage: snapshot.data!.message,
                    onRetryPressed: () => _bloc!.loadVeteranCard(token: _token)
                  );
              }
            }
            return Container();
          }
        )
      )
    );
  }

  Widget _informationCard(VeteranCardModel item) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              // height: 260,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      widget.userType == '1' ? utils.getTranslated('veteranPension', context) : utils.getTranslated('dependent', context),
                      style: utils.getTextStyleRegular(fontSize: 20, color: Colors.black, weight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item.veteranName!,
                      style: utils.getTextStyleRegular(fontSize: 18, color: secondColor, weight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item.veteranMyKad!,
                      style: utils.getTextStyleRegular(fontSize: 16, color: Colors.black, weight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _cardInfo(utils.getTranslated('veteranArmyNo', context), item.veteranMilitaryNo!),
                  _cardInfo(utils.getTranslated('rank', context), item.veteranRank!),
                  _cardInfo(utils.getTranslated('ttp', context).toUpperCase(), item.veteranTTP!),
                  _spouseInfo(utils.getTranslated('spouseList', context), item.spouseList!)
                ]
              )
            ),
            const SizedBox(height: 10),
            Container(
              height: 250,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/qr_sample.png', fit: BoxFit.cover,
                      height: 150,
                    )
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/qr_barcode_sample.png', fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width - 200,
                    )
                  )
                ]
              )
            ),
          ]
        )
      )
    );
  }

  Widget _cardInfo(String item1, String item2) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox(
            width: 170,
            child: Text(
              item1,
              style: utils.getTextStyleRegular(fontSize: 14, color: Colors.black, weight: FontWeight.w700)
            )
          ),
          Expanded(
            child: Text(
              item2,
              textAlign: TextAlign.left,
              style: utils.getTextStyleRegular(fontSize: 14, color: Colors.black),
              maxLines: 1,
              overflow: TextOverflow.ellipsis
            )
          )
        ]
      )
    );
  }

  Widget _spouseInfo(String item1, List<SpouseListModel?> item2) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 170,
            child: Text(
              item1,
              style: utils.getTextStyleRegular(fontSize: 14, color: Colors.black, weight: FontWeight.w700)
            )
          ),
          Expanded(
            // height: 200,
            child: item2.isNotEmpty ? ListView.builder(
              shrinkWrap: true,
              itemCount: item2.length,
              itemBuilder: (context, index) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    (index + 1).toString() + '.   ' + item2[index]!.name!,
                    style: utils.getTextStyleRegular(fontSize: 14, color: Colors.black),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis
                  ),
                  const SizedBox(height: 5)
                ]
              )
            ) : Text(utils.getTranslated('noSpouse', context), style: utils.getTextStyleRegular(fontSize: 14, color: Colors.black))
          )
        ]
      )
    );
  }
}