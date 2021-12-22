import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';
import 'package:myveteran/views/home/panel_notice/panel_notice.dart';
import 'package:myveteran/views/web_portal/web_portal.dart';

List<StaggeredTile> staggeredTilesVeteran = const <StaggeredTile>[
  StaggeredTile.count(2, 2),
  StaggeredTile.count(2, 2),
  StaggeredTile.count(2, 2),
  StaggeredTile.count(2, 2),
  StaggeredTile.count(2, 2),
  StaggeredTile.count(2, 2)
];

List<StaggeredTile> staggeredTilesHeirs = const <StaggeredTile>[
  StaggeredTile.count(2, 2),
  StaggeredTile.count(2, 2),
  StaggeredTile.count(2, 2),
  StaggeredTile.count(2, 2),
  StaggeredTile.count(2, 2),
  StaggeredTile.count(2, 1)
];

class PanelServiceState extends StatefulWidget {
  final double? panelHeight;
  const PanelServiceState({Key? key, @required this.panelHeight}) : super(key: key);

  @override
  _PanelServiceState createState() => _PanelServiceState();
}

class _PanelServiceState extends State<PanelServiceState> {
  final _storage = const FlutterSecureStorage();

  List<dynamic>? homeMenu;
  List<StaggeredTile>? staggeredTiles;
  String? userType;

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
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.topCenter,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: widget.panelHeight!, left: 15, right: 15, bottom: 10),
              child: FutureBuilder<dynamic>(
                future: _getUserType(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    userType = snapshot.data;

                    List<dynamic> veteranMenu = [
                      {
                        'id': 1,
                        'path': 'assets/icons/payment_statement.png',
                        'title': utils.getTranslated('pensionStatement', context),
                        'titleHeight': 40,
                        'background': '0xFFF1F4FB'
                      },
                      {
                        'id': 2,
                        'path': 'assets/icons/career.png',
                        'title': utils.getTranslated('careerOffer', context),
                        'titleHeight': 40,
                        'background': '0xFFF1F4FB'
                      },
                      {
                        'id': 3,
                        'path': 'assets/icons/course.png',
                        'title': utils.getTranslated('trainingOffer', context),
                        'titleHeight': 40,
                        'background': '0xFFF1F4FB'
                      },
                      {
                        'id': 4,
                        'path': 'assets/icons/medicine.png',
                        'title': utils.getTranslated('medical', context),
                        'titleHeight': 40,
                        'background': '0xFFF1F4FB'
                      },
                      {
                        'id': 5,
                        'path': 'assets/icons/welfare.png',
                        'title': utils.getTranslated('welfare', context),
                        'titleHeight': 40,
                        'background': '0xFFF1F4FB'
                      },
                      {
                        'id': 6,
                        'path': 'assets/icons/bmj.png',
                        'title': utils.getTranslated('bmj', context),
                        'titleHeight': 40,
                        'background': '0xFFF1F4FB'
                      }
                    ];

                    List<dynamic> heirsMenu = [
                      {
                        'id': 1,
                        'path': 'assets/icons/payment_statement.png',
                        'title': utils.getTranslated('pensionStatement', context),
                        'titleHeight': 40,
                        'background': '0xFFF1F4FB'
                      },
                      {
                        'id': 2,
                        'path': 'assets/icons/course.png',
                        'title': utils.getTranslated('trainingOffer', context),
                        'titleHeight': 40,
                        'background': '0xFFF1F4FB'
                      },
                      {
                        'id': 3,
                        'path': 'assets/icons/medicine.png',
                        'title': utils.getTranslated('medical', context),
                        'titleHeight': 40,
                        'background': '0xFFF1F4FB'
                      },
                      {
                        'id': 4,
                        'path': 'assets/icons/welfare.png',
                        'title': utils.getTranslated('welfare', context),
                        'titleHeight': 40,
                        'background': '0xFFF1F4FB'
                      },
                      {
                        'id': 5,
                        'path': 'assets/icons/bmj.png',
                        'title': utils.getTranslated('bmj', context),
                        'titleHeight': 40,
                        'background': '0xFFF1F4FB'
                      }
                    ];

                    if (userType == '1') {
                      staggeredTiles = staggeredTilesVeteran;
                      homeMenu = veteranMenu;
                    } else if (userType == '2') {
                      staggeredTiles = staggeredTilesHeirs;
                      homeMenu = heirsMenu;
                    }
                    return StaggeredGridView.count(
                      crossAxisCount: 4,
                      staggeredTiles: staggeredTiles!,
                      children: _staggeredTile(homeMenu),
                      mainAxisSpacing: 1.0,
                      crossAxisSpacing: 1.0,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(4.0),
                    );
                  }
                  return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(secondColor)));
                }
              )
            ),
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 45,
                alignment: Alignment.centerLeft,
                color: const Color(0xFFF1F4FB),
                child: Text(
                  utils.getTranslated('notice', context).toUpperCase(),
                  style: utils.getTextStyleRegular(fontSize: 18, color: Colors.black, weight: FontWeight.w700)
                )
              )
            ),
            const PanelNoticeState()
          ]
        )
      )
    );
  }

  List<Widget> _staggeredTile(items) {
    List<Widget> widgets = [];
    for (var item in items) { 
      widgets.add(
        TileItems(tiles: item, userType: userType)
      );
    }
    return widgets;
  }

  Future<dynamic>? _getUserType() async {
    final token = await _storage.read(key: 'type');
    return token;
  }
}

class TileItems extends StatefulWidget {
  final Map<String, dynamic>? tiles;
  final String? userType;

  const TileItems({ Key? key, this.tiles, this.userType }) : super(key: key);

  @override
  _TileItems createState() => _TileItems();
}

class _TileItems extends State<TileItems> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _animationController?.addListener(() {
      setState(() {});
    });
  }

  @override
  dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double scale = 1 - _animationController!.value;
    
    final _imageBackground = Stack(
      children: <Widget>[
        Positioned.fill(
          child: Container(
            padding: const EdgeInsets.only(top: 20, bottom: 50, right: 50, left: 50),
            child: Image.asset(widget.tiles?['path'])
          ),
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: Stack(
            children: <Widget> [
              Container(
                height: widget.tiles?['titleHeight'].toDouble(),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8)
                  )
                )
              ),
              Container(
                height: widget.tiles?['titleHeight'].toDouble(),
                alignment: Alignment.center,
                padding: const EdgeInsets.only(bottom: 5), 
                child: Text(widget.tiles?['title'], style: utils.getTextStyleRegular(color: Colors.white, fontSize: 15))
              ),
            ]
          )
        )
      ],
    );
    return GestureDetector(
      onTapUp: _onTapUp,
      onTapDown: _onTapDown,
      onTapCancel: () {
        _animationController?.reverse();
      },
      onTap: () {
        debugPrint('title tiles ${widget.tiles?['title']}');
        if (widget.userType == '1') {
          if (widget.tiles?['id'] == 1) {
            Navigator.of(context).pushNamed(paymentStatement);
          } else if (widget.tiles?['id'] == 2) {
            Navigator.of(context).pushNamed(careerOpportunity);
          } else if (widget.tiles?['id'] == 3) {
            Navigator.of(context).pushNamed(courseOpportunity);
          } else if (widget.tiles?['id'] == 4) {
            Navigator.of(context).pushNamed(medical);
          } else if (widget.tiles?['id'] == 5) {
            // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => WebPortalState(pageTitle: widget.tiles?['title'], pageLink: 'https://vibes2uat.jhev.gov.my/vibes2dev/portal/default.asp')));
            Navigator.of(context).pushNamed(welfare);
          } else if (widget.tiles?['id'] == 6) {
            // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => WebPortalState(pageTitle: widget.tiles?['title'], pageLink: 'https://vibes2uat.jhev.gov.my/vibes2dev/portal/default.asp')));
            Navigator.of(context).pushNamed(bmj);
          }
        } else {
          if (widget.tiles?['id'] == 1) {
            Navigator.of(context).pushNamed(paymentStatement);
          } else if (widget.tiles?['id'] == 2) {
            Navigator.of(context).pushNamed(courseOpportunity);
          } else if (widget.tiles?['id'] == 3) {
            // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => WebPortalState(pageTitle: widget.tiles?['title'], pageLink: 'https://vibes2uat.jhev.gov.my/vibes2dev/portal/default.asp')));
            Navigator.of(context).pushNamed(medical);
          } else if (widget.tiles?['id'] == 4) {
            // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => WebPortalState(pageTitle: widget.tiles?['title'], pageLink: 'https://vibes2uat.jhev.gov.my/vibes2dev/portal/default.asp')));
            Navigator.of(context).pushNamed(welfare);
          } else if (widget.tiles?['id'] == 5) {
            // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => WebPortalState(pageTitle: widget.tiles?['title'], pageLink: 'https://vibes2uat.jhev.gov.my/vibes2dev/portal/default.asp')));
            Navigator.of(context).pushNamed(bmj);
          }
        }
      },
      child: Transform.scale(
        scale: scale,
        child: Card(
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white70, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(int.parse(widget.tiles?['background'])), Color(int.parse(widget.tiles?['background']))]
              ),
              // color: Colors.grey,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300]!.withOpacity(0.8),
                  // spreadRadius: 0.8,
                  blurRadius: 2,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Center(
              child: _imageBackground
            )
          )
        )
      ),
    );
  }

  void _onTapDown(TapDownDetails details) {
    _animationController?.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController?.reverse();
  }
}