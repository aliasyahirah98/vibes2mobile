import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';
import 'package:flutter/material.dart';

class ButtonCircle extends StatefulWidget {
  final String? btnName;
  final double? size;
  final Color? borderColor;
  final Widget? btnWidget;
  final VoidCallback? onSubmit;
  final bool? isActive;
  final Color? colorTitle;
  final Color? btnColor;

  const ButtonCircle({Key? key, @required this.btnName, this.size, this.borderColor, this.btnWidget, this.onSubmit, this.isActive, this.colorTitle, this.btnColor})  : super(key: key);

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<ButtonCircle> with SingleTickerProviderStateMixin {
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
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: enableBtn ? widget.btnColor : Colors.grey[400],
                borderRadius: BorderRadius.circular(100.0),
                border: Border.all(width: 2.0, color: enableBtn ? (widget.borderColor)! : Colors.white),
                // boxShadow: [
                //   BoxShadow(
                //     // color: widget.btnColor != null ? widget.btnColor : Colors.white,
                //     offset: Offset(0.0, 1.0),
                //     blurRadius: 2.0,
                //     spreadRadius: 0.25,
                //   ),
                // ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        widget.btnWidget!
                      ]
                    ),
                  ]
                )              
              )
            ),
            widget.btnName != '' ? Column(
              children: <Widget>[
                const SizedBox(height: 5),
                Text(
                  widget.btnName!,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: utils.getTextStyleRegular(fontSize: 12, color: enableBtn ? (widget.colorTitle ?? mainColor) : (Colors.grey[500])!)
                )
              ]
            ) : Container()
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