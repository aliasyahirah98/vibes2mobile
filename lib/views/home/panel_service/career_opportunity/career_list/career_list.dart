import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:myveteran/blocs/career/career_bloc.dart';
import 'package:myveteran/core/models/career/career_list_model.dart';
import 'package:myveteran/core/provider/response.dart';
import 'package:myveteran/shared/components/error_handling/error_sync.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';
import 'package:flutter/material.dart';
import 'package:myveteran/views/home/panel_service/career_opportunity/career_list/career_list_details.dart';
import 'package:shimmer/shimmer.dart';

class CareerListState extends StatefulWidget {
  const CareerListState({Key? key}) : super(key: key);
  
  @override
  _CareerListState createState() => _CareerListState();
}

class _CareerListState extends State<CareerListState> {
  final ScrollController scrollController = ScrollController();

  String? _token;
  CareerBloc? _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = CareerBloc();
    utils.getToken()!.then((value) {
      _token = value;
      _bloc!.loadCareerList(token: _token);
      // debugPrint('token $_token');
    });
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
        body: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width - 100,
                  height: 40,
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                      hintText: 'e.g. "Operator, Pengurus"',
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)
                      ),
                      hintStyle: utils.getTextStyleRegular(fontSize: 12, color: Colors.grey),
                    ),
                    style: utils.getTextStyleRegular(color: Colors.black, fontSize: 12),
                    // onChanged: _bloc.searchBillFilterList,
                  )
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: utils.cirlceRippleButton(
                    context,
                    icon: const Icon(CupertinoIcons.slider_horizontal_3, size: 30, color: secondColor),
                    color: Colors.grey[200],
                    onClick: () {
                      Navigator.of(context).pushNamed(careerListOption);
                    }
                  )
                ),
              ]
            ),
            Expanded(
              child: RefreshIndicator(
                color: mainColor,
                onRefresh: () {
                  return _bloc!.loadCareerList(token: _token);
                },
                child: StreamBuilder<Response<CareerListModel?>>(
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
                                margin: const EdgeInsets.fromLTRB(3.0, 10.0, 3.0, 0.0),
                                // constraints: new BoxConstraints.expand(),
                                height: 155.0,
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  enabled: true,
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 3.0, right: 3.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: Colors.grey[300],
                                      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                    ),
                                  ),
                                ),
                              ),
                              itemCount: 5,
                            )
                          );
                        case Status.completed:
                          return snapshot.data!.data!.careerList!.isNotEmpty ? ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: scrollController,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.data!.careerList!.length,
                            itemBuilder: (BuildContext context, int index) => _informationItem(snapshot.data!.data!.careerList![index])
                          ) : utils.noDataFound(context);
                        case Status.error:
                          return ErrorSync(
                            errorMessage: snapshot.data!.message,
                            onRetryPressed: () => _bloc!.loadCareerList(token: _token)
                          );
                      }
                    }
                    return Container();
                  }
                )
              )
            )
          ]
        )
      )
    );
  }

  Widget _informationItem(CareerInfoModel item) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: 260,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const Icon(CupertinoIcons.map_pin_ellipse, size: 18, color: secondColor),
                        const SizedBox(width: 10),
                        Text(
                          item.locationName!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: utils.getTextStyleRegular(color: Colors.black, fontSize: 15),
                        )
                      ]
                    ),
                    const SizedBox(height: 5),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item.name!, //find_me_object_clarify
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: utils.getTextStyleRegular(color: secondColor, fontSize: 18, weight: FontWeight.w700),
                      )
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: CircleAvatar(
                            child: Image.asset('assets/images/logo.png', fit: BoxFit.contain)
                          )
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                item.orgRegistrationName!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: utils.getTextStyleRegular(color: Colors.black, fontSize: 16, weight: FontWeight.w700),
                              ),
                              Text(
                                item.category!, //find_me_object_clarify
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: utils.getTextStyleRegular(color: Colors.black87, fontSize: 15),
                              )
                            ]
                          )
                        )
                      ]
                    ),
                    const SizedBox(height: 15),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item.jobSalary!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: utils.getTextStyleRegular(color: secondColor, fontSize: 16, weight: FontWeight.w700),
                      )
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              // width: 120,
                              height: 25,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(15)),
                                color: Colors.green[100]
                              ),
                              child: Text(
                                item.jobFullOrPartTime!, //find_me_object_clarify
                                style: utils.getTextStyleRegular(fontSize: 12, color: Colors.green[900]!)
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              utils.getTranslated('closeDate', context) + ' ' + item.registraterEndDate!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: utils.getTextStyleRegular(color: Colors.black54, fontSize: 14),
                            )
                          ]
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
                                Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => CareerListDetailsState(
                                  jobId: item.id,
                                  orgRegistrationName: item.orgRegistrationName
                                )))
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
    );
  }
}