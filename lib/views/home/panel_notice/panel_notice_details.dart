import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';

class PanelNoticeDetailsState extends StatefulWidget {
  final String? title;
  final String? published;
  final String? imagePath;

  const PanelNoticeDetailsState({Key? key, @required this.title, @required this.published, this.imagePath}) : super(key: key);
  
  @override
  _PanelNoticeDetailsState createState() => _PanelNoticeDetailsState();
}

class _PanelNoticeDetailsState extends State<PanelNoticeDetailsState> {
  final ScrollController scrollController = ScrollController();
  final double _imageHeight = 200;

  double _offSet = 0.0, _paddingTop = 0.0;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() => 
      setState(() {
        //<-----------------------------
        _offSet = scrollController.offset;
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
    _paddingTop = MediaQuery.of(context).padding.top;
    String? _imagePath = widget.imagePath ?? '';

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
        body: NestedScrollView(
          controller: scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.white,
                expandedHeight: _imageHeight,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  background: Column(
                    children: <Widget>[
                      Container(
                        height: _imageHeight + _paddingTop,
                        width: MediaQuery.of(context).size.width,
                        child: _imagePath != '' ? cachedImage : Image.asset('assets/images/no-image.png', fit: BoxFit.contain), 
                        decoration: const BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 15.0,
                              offset: Offset(0.0, 0.75)
                            )
                          ]
                        )
                      ),
                    ]
                  )
                ),
                leading: utils.backHeaderButton(context, backIcon: CupertinoIcons.chevron_back),
                brightness: Brightness.light,
                elevation: _offSet > 6 ? 1.0 : 0.0,
                // title: Text('Details', style: utils.getTextStyleRegular(color: mainColor, fontSize: 24, weight: FontWeight.bold)),
                // backgroundColor: Colors.white,
                actions: <Widget>[
                  _headerTransform()
                ]
              )
            ];
          },
          body: ListView(
            children: <Widget>[
              // _offSet > 6 ? SizedBox(height: 70) : SizedBox(height: 70 - _offSet),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Text(
                  widget.title!,
                  style: utils.getTextStyleRegular(color: secondColor, fontSize: 18, weight: FontWeight.bold),
                )
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Text(
                  widget.published!,
                  style: utils.getTextStyleRegular(color: Colors.grey[600]!, fontSize: 15, weight: FontWeight.w500, fontStyle: FontStyle.italic),
                )
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Text(
                  'aaaaavvvv',
                  style: utils.getTextStyleRegular(color: Colors.black, fontSize: 14),
                )
              ),
            ],
          )
        )
      )
    );
  }

  Widget _headerTransform() {
    Widget headerTitle = Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(70, 0, 70, 0),
      child: Text(
        'Pemberitahuan', 
        // maxLines: 1,
        // overflow: TextOverflow.ellipsis,
        style: utils.getTextStyleRegular(color: mainColor, fontSize: 22, weight: FontWeight.bold)
      )
    );

    double scale = 1.0;
    if (scrollController.hasClients) {
      scale = _offSet / (_imageHeight + _paddingTop);

      if (scale < 0.55) {
        scale = 0.0;
      } else {
        scale = 1.0;
      }
    } else {
      scale = 0.0;
    }

    return Transform(
      transform: Matrix4.identity()..scale(scale, scale),
      // alignment: Alignment.center,
      child: headerTitle,
    );
  }
}