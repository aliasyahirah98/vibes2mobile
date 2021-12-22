import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';
import 'package:myveteran/views/home/panel_service/career_opportunity/career_list/career_list.dart';
import 'package:myveteran/views/home/panel_service/career_opportunity/career_track/career_track.dart';

class CareerOpportunityState extends StatefulWidget {
  final int? selectedTab;

  const CareerOpportunityState({Key? key, @required this.selectedTab}) : super(key: key);
  
  @override
  _CareerOpportunityState createState() => _CareerOpportunityState();
}

class _CareerOpportunityState extends State<CareerOpportunityState> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.selectedTab!);
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
        'title': utils.getTranslated('careerList', context),
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
            utils.getTranslated('careerOffer', context),
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
                  controller: _tabController,
                  children: const <Widget>[
                    CareerListState(),
                    CareerTrackState()
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