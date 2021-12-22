import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myveteran/blocs/announcement/announcement_bloc.dart';
import 'package:myveteran/core/models/announcement/announcement_model.dart';
import 'package:myveteran/core/provider/response.dart';
import 'package:myveteran/shared/components/error_handling/error_sync.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';
import 'package:myveteran/views/home/panel_notice/panel_notice_details.dart';
import 'package:shimmer/shimmer.dart';

final List<dynamic> announcementList = [
  {
    'title': 'Majlis Penyampaian Pingat Jasa Malaysia Kepada Veteran Negeri Perak',
    'content': 'Ketua Pengarah Jabatan Hal Ehwal Veteran ATM (JHEV),....',
    'published': '12-Jul-2021',
    'image': 'https://www.minia.edu.eg/images/alsun/alsun2020-12-038282715.jpg'
  },
  {
    'title': 'My Veteran My Hero Charity Golf Kempen Tabung Pahlawan',
    'content': 'Ketua Pengarah Jabatan Hal Ehwal Veteran ATM (JHEV),....',
    'published': '15-Sep-2021',
    'image': 'https://www.minia.edu.eg/images/alsun/alsun2020-12-038282715.jpg'
  }
];

class PanelNoticeState extends StatefulWidget {
  const PanelNoticeState({Key? key}) : super(key: key);
  @override
  _PanelNoticeState createState() => _PanelNoticeState();
}
class _PanelNoticeState extends State<PanelNoticeState> {
  final CarouselController _controller = CarouselController();

  String? _token;
  int _current = 0;
  AnnouncementBloc? _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = AnnouncementBloc();
    utils.getToken()!.then((value) {
      _token = value;
      _bloc!.loadAnnouncement(token: _token);
      // debugPrint('token $_token');
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Response<AnnouncementModel?>>(
      stream: _bloc!.resultStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status!) {
            case Status.loading:
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      enabled: true,
                      child: Container(
                        margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.grey[300],
                          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30)
                ]
              );
            case Status.completed:
              return snapshot.data!.data!.announcementList!.isNotEmpty ? Stack(
                children: <Widget>[
                  CarouselSlider.builder(
                    carouselController: _controller,
                    options: CarouselOptions(
                      height: 260,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 0.8,
                      // aspectRatio: 16/9,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }
                    ),
                    itemCount: snapshot.data!.data!.announcementList!.length,
                    itemBuilder: (BuildContext context, int index, _) => _cardSlider(snapshot.data!.data!.announcementList![index]),
                  ),
                  Positioned(
                    bottom: 20,
                    child: Container(
                      width: MediaQuery.of(context).size.width, 
                      alignment: Alignment.center, 
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: snapshot.data!.data!.announcementList!.map((item) {
                          int index = snapshot.data!.data!.announcementList!.indexOf(item);
                          return Container(
                            width: _current == index ? 20.0 : 8.0,
                            height: 6.0,
                            margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                              // shape: BoxShape.circle,
                              color: _current == index
                                ? mainColor
                                : const Color.fromRGBO(0, 0, 0, 0.4),
                              borderRadius: _current == index
                                  ? const BorderRadius.all(Radius.circular(20.0))
                                  : const BorderRadius.all(Radius.circular(8.0)),
                            ),
                          );
                        }).toList(),
                      )
                    )
                  )
                ]
              ) : SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 150, 
                child: Image.asset('assets/images/no-image.png', fit: BoxFit.contain)
              );
            case Status.error:
              return ErrorSync(
                errorMessage: snapshot.data!.message,
                onRetryPressed: () => _bloc!.loadAnnouncement(token: _token),
              );
          }
        }
        return Container();
      },
    );
  }

  Widget _cardSlider(AnnouncementInfoModel item) {
    String? title = item.contentName ?? '-';
    String? published = item.contentStartDate ?? '-';
    String? _imagePath = item.contentFileUpload1 ?? '';

    final cachedImage = CachedNetworkImage(
      placeholder: (context, url) => const Center(
        child: SizedBox(
          width: 40.0,
          height: 40.0,
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(mainColor)),
        ),
      ),
      errorWidget: (context, url, error) => Center(
        child: Image.asset('assets/images/no-image.png', fit: BoxFit.cover)
      ),
      imageUrl: _imagePath,
      fit: BoxFit.cover
    );
    return Container(
      margin: const EdgeInsets.fromLTRB(2, 5, 2, 5),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: 110,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)
                  ),
                  child: _imagePath != '' ? cachedImage : Image.asset('assets/images/no-image.png', fit: BoxFit.contain), //BoxFit.cover
                ),
                decoration: BoxDecoration(
                  // color: Colors.grey,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300]!.withOpacity(0.8),
                      // spreadRadius: 0.8,
                      blurRadius: 2,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                )
              ),
              Container(
                height: 95,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: utils.getTextStyleRegular(color: Colors.black, fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                        child: Text(
                          published,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: utils.getTextStyleRegular(color: secondColor, fontSize: 12, weight: FontWeight.w700),
                        ),
                      ),
                    )
                  ]
                )
              )
            ]
          ),
          Positioned.fill(
            bottom: 40,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => PanelNoticeDetailsState(
                  title: title, published: published, imagePath: _imagePath)
                ))
              )
            )
          )
        ]
      ),
    );
  }
}