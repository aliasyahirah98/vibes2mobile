import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';
import 'package:flutter/material.dart';

class ButtonRound extends StatefulWidget {
  final String? btnName;
  final bool? textBold;
  final double? height;
  final double? width;
  final Color? borderColor;
  final Widget? iconBtn;
  final VoidCallback? onSubmit;
  final bool? isActive;
  final Color? colorTitle;
  final Color? btnColor;

  const ButtonRound({Key? key, @required this.btnName, this.textBold, this.height, this.width, this.borderColor, this.iconBtn, this.onSubmit, this.isActive, this.colorTitle, this.btnColor})  : super(key: key);

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<ButtonRound> with SingleTickerProviderStateMixin {
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
    bool enableBtn = widget.isActive ?? true;

    return GestureDetector(
      onTapUp: _onTapUp,
      onTapDown: _onTapDown,
      onTapCancel: () {
        _animationController?.reverse();
      },
      onTap: enableBtn ? widget.onSubmit : null,
      child: Transform.scale(
        scale: scale,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[ 
            Container(
              width: widget.width ?? 170,
              height: widget.height ?? 50,
              decoration: BoxDecoration(
                color: enableBtn ? widget.btnColor : Colors.grey[300],
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(width: 2.0, color: enableBtn ? (widget.borderColor)! : Colors.white),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0.0, 1.0),
                    blurRadius: 2.0,
                    spreadRadius: 0.25,
                  ),
                ],
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    widget.iconBtn ?? Container(),
                    widget.iconBtn != null ? const SizedBox(width: 10) : Container(),
                    Text(
                      widget.btnName ?? '',
                      textAlign: TextAlign.center,
                      style: utils.getTextStyleRegular(fontSize: 16, color: enableBtn ? (widget.colorTitle ?? mainColor) : Colors.grey, 
                        weight: widget.textBold != null ? FontWeight.w700 : FontWeight.normal
                      )
                    )
                  ]
                )
              )
            )
          ]
        )
      )
    );
  }

  void _onTapDown(TapDownDetails details) {
    _animationController?.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController?.reverse();
  }
}