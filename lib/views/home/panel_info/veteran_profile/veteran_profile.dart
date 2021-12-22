import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myveteran/shared/components/misc/image_color_filter.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';
import 'package:myveteran/views/home/panel_info/veteran_profile/heirs_and_dependent_information/heirs_and_dependent_information.dart';

class VeteranProfileState extends StatefulWidget {
  final Map<String, dynamic>? userInfo;
  const VeteranProfileState({Key? key, this.userInfo}) : super(key: key);

  @override
  _VeteranProfileState createState() => _VeteranProfileState();
}

class _VeteranProfileState extends State<VeteranProfileState> {
  final _imageHeight = 250;
  double _paddingTop = 0.0, _backgroundHeight = 0.0, _directionHeight = 0.0;

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
    _paddingTop = MediaQuery.of(context).padding.top;
    _backgroundHeight = _paddingTop + _imageHeight;
    _directionHeight = _backgroundHeight + 30;

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
          // leading: !_isSearching ? utils.backHeaderButton(context) : Container(),
          // titleSpacing: !_isSearching ? 0 : -10, //5
          leading: utils.backHeaderButton(context, backIcon: CupertinoIcons.chevron_back),
          brightness: Brightness.light,
          title: Text(
            utils.getTranslated('veteranInfo', context),
            style: utils.getTextStyleRegular(color: mainColor, fontSize: 22, weight: FontWeight.bold)
          ),
          backgroundColor: Colors.white
        ),
        body: SizedBox(
          // color: const Color(0xFFF1F4FB),
          child: Stack(
            children: <Widget>[
              ClipPath(
                clipper: ClippingClass(),
                child: Container(
                  height: _backgroundHeight + 15,
                  width: MediaQuery.of(context).size.width,
                  color: const Color(0xFFC2AA92)
                )
              ),
              ClipPath(
                clipper: ClippingClass(),
                child: Container(
                  height: _backgroundHeight,
                  width: MediaQuery.of(context).size.width,
                  color: const Color(0xFFF1F4FB),
                  child: Image.asset('assets/images/veteran_2.png', fit: BoxFit.contain), 
                )
              ),
              Container(
                padding: EdgeInsets.only(top: _directionHeight, left: 15, right: 15, bottom: 10),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        utils.getTranslated('personalInformation', context),
                        style: utils.getTextStyleRegular(fontSize: 14, color: Colors.black),
                      ),
                      trailing: const Icon(
                        CupertinoIcons.arrow_right_circle,
                        color: secondColor,
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed(personalInformation);
                      }
                    ),
                    const Divider(height: 3.0),
                    ListTile(
                      title: Text(
                        utils.getTranslated('servicesInformation', context),
                        style: utils.getTextStyleRegular(fontSize: 14, color: Colors.black),
                      ),
                      trailing: const Icon(
                        CupertinoIcons.arrow_right_circle,
                        color: secondColor,
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed(serviceInformation);
                      }
                    ),
                    const Divider(height: 3.0),
                    ListTile(
                      title: Text(
                        utils.getTranslated('educationAndSkillsInformation', context),
                        style: utils.getTextStyleRegular(fontSize: 14, color: Colors.black),
                      ),
                      trailing: const Icon(
                        CupertinoIcons.arrow_right_circle,
                        color: secondColor,
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed(educationInformation);
                      }
                    ),
                    const Divider(height: 3.0),
                    ListTile(
                      title: Text(
                        utils.getTranslated('dependentsInformation', context),
                        style: utils.getTextStyleRegular(fontSize: 14, color: Colors.black),
                      ),
                      trailing: const Icon(
                        CupertinoIcons.arrow_right_circle,
                        color: secondColor,
                      ),
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => HeirsAndDependentInformationState(
                          userInfo: widget.userInfo,
                        )));
                      }
                    ),
                    const Divider(height: 3.0)
                  ]
                )
              )
            ],
          ),
        )
      )
    );
  }
  
  Widget imageFilter({brightness, saturation, hue, child}) {
    return ColorFiltered(
      colorFilter: ColorFilter.matrix(
        ImageColorFilter.brightnessAdjustMatrix(
          value: brightness,
        )!
      ),
      child: ColorFiltered(
        colorFilter: ColorFilter.matrix(
          ImageColorFilter.saturationAdjustMatrix(
            value: saturation,
          )
        ),
        child: ColorFiltered(
          colorFilter: ColorFilter.matrix(
            ImageColorFilter.hueAdjustMatrix(
              value: hue,
            )
          ),
          child: child,
        )
      )
    );
  }
}

class ClippingClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height-40);
    path.quadraticBezierTo(size.width / 4, size.height,
        size.width / 2, size.height);
    path.quadraticBezierTo(size.width - (size.width / 4), size.height,
        size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
