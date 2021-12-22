import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myveteran/shared/components/misc/image_color_filter.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';
import 'package:myveteran/views/home/panel_info/panel_info.dart';
import 'package:myveteran/views/home/panel_service/panel_service.dart';
import 'package:myveteran/views/home/panel_transaction/panel_transaction.dart';

class HomeState extends StatefulWidget {
  const HomeState({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeState> {
  final _imageHeight = 250;
  
  String _imagePath = '';
  double _paddingTop = 0.0, _backgroundHeight = 0.0, _serviceHeight = 0.0;

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
    _imagePath = 'https://media.timeout.com/images/101849899/image.jpg';
    _paddingTop = MediaQuery.of(context).padding.top;
    _backgroundHeight = _paddingTop + _imageHeight;
    _serviceHeight = _backgroundHeight + 45;

    final cachedImage = CachedNetworkImage(
      placeholder: (context, url) => const Center(
        child: SizedBox(
          width: 40.0,
          height: 40.0,
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(mainColor)),
        ),
      ),
      errorWidget: (context, url, error) => Center(
        child: Image.asset('assets/images/no-image.png', fit: BoxFit.contain)
      ),
      imageUrl: _imagePath,
      fit: BoxFit.cover
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        // For Android.
        // Use [light] for white status bar and [dark] for black status bar.
        statusBarIconBrightness: Brightness.light,
        // For iOS.
        // Use [dark] for white status bar and [light] for black status bar.
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Container(
          color: const Color(0xFFF1F4FB),
          child: Stack(
            children: <Widget>[
              PanelServiceState(panelHeight: _serviceHeight),
              ClipPath(
                clipper: ClippingClass(),
                child: imageFilter(
                  hue: 0.0,
                  brightness: -0.2,
                  saturation: 0.0,
                  child: SizedBox(
                    height: _backgroundHeight,
                    width: MediaQuery.of(context).size.width,
                    child: _imagePath != '' ? cachedImage : Image.asset('assets/images/no-image.png', fit: BoxFit.contain), 
                  )
                ),
              ),
              Container(
                height: 60,
                width: 60,
                margin: EdgeInsets.only(top: _paddingTop),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                  border: Border.all(width: 2.0, color: Colors.transparent)
                ),
                child: ClipOval(
                  child: Material(
                    shape: const StadiumBorder(),
                    color: Colors.transparent,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      child: const Icon(CupertinoIcons.line_horizontal_3, color: Colors.white, size: 30),
                      onTap: () => {
                        Scaffold.of(context).openDrawer()
                      }
                    )
                  )
                )
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.topRight,
                child: Container(
                  height: 40,
                  width: 40,
                  margin: EdgeInsets.only(top: _paddingTop + 15, right: 20),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image.network(
                        'https://www.occrp.org/assets/common/staff/male.png',
                        fit: BoxFit.cover,
                        width: 90,
                        height: 90,
                      ),
                    ),
                  ),
                )
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                margin: EdgeInsets.only(top: _backgroundHeight, left: 15),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
                  ),
                  color: const Color(0xFFF1F4FB),
                ),
                child: Text(
                  utils.getTranslated('services', context).toUpperCase(),
                  style: utils.getTextStyleRegular(fontSize: 18, color: Colors.black, weight: FontWeight.w700)
                )
              ),
              const PanelInfoState(),
              PanelTransactionState(paddingTop: _paddingTop)
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
