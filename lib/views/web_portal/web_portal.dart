import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';
import 'package:myveteran/views/web_portal/portal_link/portal_browse.dart';
import 'package:myveteran/views/web_portal/portal_track/portal_track.dart';
// import 'package:myveteran/views/web_portal/portal_link/portal_link.dart';

class WebPortalState extends StatefulWidget {
  final String? pageTitle;
  final String? pageLink;

  const WebPortalState({Key? key, @required this.pageTitle, @required this.pageLink}) : super(key: key);
  
  @override
  _WebPortalState createState() => _WebPortalState();
}

class _WebPortalState extends State<WebPortalState> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    List<dynamic> _tabs = <dynamic>[
      {
        'title': utils.getTranslated('application', context),
        'icon': CupertinoIcons.square_list
      },
      {
        'title': utils.getTranslated('statusReview', context),
        'icon': CupertinoIcons.doc_text_search
      }
    ];
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
          // leading: !_isSearching ? utils.backHeaderButton(context) : Container(),
          // titleSpacing: !_isSearching ? 0 : -10, //5
          leading: utils.backHeaderButton(context, backIcon: CupertinoIcons.chevron_back),
          brightness: Brightness.light,
          title: Text(
            widget.pageTitle!,
            style: utils.getTextStyleRegular(color: mainColor, fontSize: 22, weight: FontWeight.bold)
          ),
          backgroundColor: Colors.white
        ),
        body: DefaultTabController(
          length: _tabs.length, 
          child: CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            slivers: <Widget> [
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyTabBarDelegate(
                  TabBar(
                    labelColor: mainColor,
                    labelPadding: const EdgeInsets.only(bottom:10, top:10),
                    indicatorColor: mainColor,
                    indicatorWeight: 3,
                    unselectedLabelColor: Colors.grey[700],
                    controller: _tabController,
                    tabs: _tabs.map((item) => Tab(text: item['title'], icon: null)).toList(),
                  ),
                )
              ),
              SliverFillRemaining(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: <Widget>[
                    // PortalLinkState(pageName: widget.pageTitle, linkUrl: widget.pageLink),
                    PortalBrowseState(pageName: widget.pageTitle),
                    PortalTrackState(pageName: widget.pageTitle)
                  ]
                )
              ),
            ]
          )
        )
      )
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _StickyTabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, child: tabBar);
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}