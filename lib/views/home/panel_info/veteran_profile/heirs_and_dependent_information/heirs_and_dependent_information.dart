import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:myveteran/blocs/veteran/veteran_dependent_bloc.dart';
import 'package:myveteran/core/models/veteran/veteran_dependent_model.dart';
import 'package:myveteran/core/provider/response.dart';
import 'package:myveteran/shared/components/dialog/direct_dialog.dart';
import 'package:myveteran/shared/components/error_handling/error_sync.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HeirsAndDependentInformationState extends StatefulWidget {
  final Map<String, dynamic>? userInfo;
  const HeirsAndDependentInformationState({Key? key, this.userInfo}) : super(key: key);
  
  @override
  _HeirsAndDependentInformationState createState() => _HeirsAndDependentInformationState();
}

class _HeirsAndDependentInformationState extends State<HeirsAndDependentInformationState> {
  final ScrollController scrollController = ScrollController();

  String? _token;
  double _offSet = 0.0;

  VeteranDependentBloc? _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = VeteranDependentBloc();
    utils.getToken()!.then((value) {
      _token = value;
      _bloc!.loadVeteranDependent(token: _token);
      debugPrint('token $_token');
    });

    scrollController.addListener(() => 
      setState(() {
        //<-----------------------------
        _offSet = scrollController.offset;
        // print('_offSet $_offSet');
        // force a refresh so the app bar can be updated
      })
    );

    debugPrint('aas ${widget.userInfo}');
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
            utils.getTranslated('dependentsInformation', context),
            style: utils.getTextStyleRegular(color: mainColor, fontSize: 22, weight: FontWeight.bold)
          ),
          backgroundColor: Colors.white,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: utils.cirlceRippleButton(
                context,
                icon: const Icon(CupertinoIcons.info_circle_fill, size: 25, color: secondColor),
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
                          title: utils.getTranslated('attention', context).toUpperCase(),
                          messages: utils.getTranslated('pleaseUpdateYourDependentsInformationOnPortalVibes', context),
                          buttonName: utils.getTranslated('yes', context),
                          onCallback: () {
                            debugPrint('Ya');
                            Navigator.of(context).pop();
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
        body: StreamBuilder<Response<VeteranDependentModel?>>(
          stream: _bloc!.resultStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data!.status!) {
                case Status.loading:
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    // enabled: _enabled,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 70,
                          // margin: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Colors.white
                          )
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
                            ),
                            color: Colors.white
                          )
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: (_, __) => Container(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        width: MediaQuery.of(context).size.width - 150,
                                        height: 8.0,
                                        padding: const EdgeInsets.only(top: 10, left: 20),
                                        color: Colors.white
                                      ),
                                      Container(
                                        width: 60,
                                        height: 8.0,
                                        padding: const EdgeInsets.only(top: 10, right: 20),
                                        color: Colors.white
                                      )
                                    ]
                                  ),
                                  const SizedBox(height: 15),
                                  Container(
                                    width: 100,
                                    height: 8.0,
                                    padding: const EdgeInsets.only(bottom: 5, left: 20, right: 20),
                                    color: Colors.white
                                  )
                                ],
                              )
                            ),
                            itemCount: 5,
                          )
                        )
                      ],
                    )
                  );
                case Status.completed:
                  return snapshot.data!.data!.returnCode == 0 ? _informationItem(snapshot.data!.data!) : utils.noDataFound(context);
                case Status.error:
                  return ErrorSync(
                    errorMessage: snapshot.data!.message,
                    onRetryPressed: () => _bloc!.loadVeteranDependent(token: _token)
                  );
              }
            }
            return Container();
          }
        )
      )
    );
  }

  Widget _informationItem(VeteranDependentModel item) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                // elevation: 4.0,
                width: MediaQuery.of(context).size.width,
                height: 50,
                margin: const EdgeInsets.only(top: 50, left: 10.0, right: 10.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  // border: Border.all(width: 1.0, color: (Colors.grey[300])!),
                  color: Color(0xFFC2AA92),
                )
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 70,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 20, bottom: 20, left: 10.0, right: 10.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  border: Border.all(width: 1.0, color: (Colors.grey[300])!),
                  color: const Color(0xFFD2D2D2),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    utils.getTranslated('family', context).toUpperCase() + ': ' + widget.userInfo?['fullname'],
                    textAlign: TextAlign.center,
                    style: utils.getTextStyleRegular(fontSize: 18, color: Colors.black, weight: FontWeight.w700),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis
                  ),
                )
              )
            ]
          ),
          _headerLabel(label: utils.getTranslated('listOfSpouse', context)),
          Wrap(
            children: item.spouse!.map((elem) => _itemDetails(name: elem.name, icNo: elem.icNo, relationship: elem.relationship)).toList()
          ),
          _headerLabel(label: utils.getTranslated('listOfParents', context)),
          Wrap(
            children: item.parent!.map((elem) => _itemDetails(name: elem.name, icNo: elem.icNo, relationship: elem.relationship)).toList()
          ),
          _headerLabel(label: utils.getTranslated('listOfChildren', context)),
          Wrap(
            children: item.children!.map((elem) => _itemDetails(name: elem.name, icNo: elem.icNo, relationship: elem.relationship)).toList()
          ),
          const SizedBox(height: 20)
        ]
      ),
    );
  }

  Widget _headerLabel({@required String? label}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 20, bottom: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
        ),
        color: const Color(0xFFEBEBEB),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        padding: const EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        child: Text(
          label!,
          style: utils.getTextStyleRegular(fontSize: 17, color: Colors.black, weight: FontWeight.w700) //fontStyle: FontStyle.italic
        )
      )
    );
  }

  Widget _itemDetails({@required String? name, @required String? icNo, String? relationship}) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width - 100,
                padding: const EdgeInsets.only(top: 10, left: 20),
                child: Text(
                  name!,
                  style: utils.getTextStyleRegular(fontSize: 16, color: secondColor, weight: FontWeight.w700),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              ),
              Container(
                width: 100,
                padding: const EdgeInsets.only(top: 10, right: 20),
                child: Text(
                  relationship!,
                  textAlign: TextAlign.right,
                  style: utils.getTextStyleRegular(fontSize: 14, color: Colors.black54),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              ),
            ]
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 5, left: 20, right: 20),
            child: Text(
              icNo!,
              style: utils.getTextStyleRegular(fontSize: 14, color: Colors.black),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          )
        ]
      ),
    );
  }
}