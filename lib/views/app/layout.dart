import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myveteran/views/home/home.dart';
import 'dart:ui';

import 'package:myveteran/views/sidebar/sidebar.dart';

class LayoutState extends StatefulWidget {
  const LayoutState({Key? key}) : super(key: key);
  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<LayoutState> {
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
    return const AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        // For Android.
        // Use [light] for white status bar and [dark] for black status bar.
        statusBarIconBrightness: Brightness.dark,
        // For iOS.
        // Use [dark] for white status bar and [light] for black status bar.
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        drawer: SidebarState(),
        body: HomeState()
      )
    );
  }
}