import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';
import 'package:flutter/material.dart';

class HeaderTitle extends StatelessWidget {
  final String? title;
  final double? paddingTitle;
  final IconData? icon;
  final String? notif;
  final Color? iconColor;
  final VoidCallback? onPressed;

  const HeaderTitle({Key? key, @required this.title, @required this.paddingTitle, this.icon, this.notif, this.iconColor, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: icon != null
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: paddingTitle!),
          child: Text(
            title!,
            style: utils.getTextStyleRegular(
              // color: Colors.black,
              color: mainColor,
              fontSize: 22,
              // letterSpacing: 2.0,
              weight: FontWeight.bold
            )
          ),
        ),
        if (icon != null)
          Container(
            width: 55,
            margin: const EdgeInsets.only(top: 5),
            child: Stack(
              children: <Widget>[
                utils.cirlceRippleButton(
                  context,
                  icon: Icon(icon, color: iconColor ?? Colors.black),
                  color: Colors.transparent,
                  onClick: onPressed
                ),
                notif != null ? Positioned(
                  right: 15.0,
                  top: 0.0,
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: const BoxDecoration(
                      color: mainColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      notif!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                      ),
                    ),
                  ),
                ) : Container(),
              ],
            )
          ),
      ],
    );
  }
}