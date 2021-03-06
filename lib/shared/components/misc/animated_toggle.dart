import 'package:flutter/material.dart';

class AnimatedToggle extends StatefulWidget {
  final List<String>? values;
  final ValueChanged? onToggleCallback;
  final bool? initialPosition;
  final Color backgroundColor;
  final Color buttonColor;
  final Color textColor;

  const AnimatedToggle({
    Key? key,
    @required this.values,
    @required this.onToggleCallback,
    @required this.initialPosition,
    this.backgroundColor = const Color(0xFFe7e7e8),
    this.buttonColor = const Color(0xFFFFFFFF),
    this.textColor = const Color(0xFF000000),
  }) : super(key: key);
  @override
  _AnimatedToggleState createState() => _AnimatedToggleState();
}

class _AnimatedToggleState extends State<AnimatedToggle> {
  // bool initialPosition = true;
  bool? initialPosition;

  @override
  void initState() {
    super.initState();
    initialPosition = widget.initialPosition!;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _appSize = 200;

    return Container(
      width: _appSize * 0.4,
      height: _appSize * 0.13,
      margin: const EdgeInsets.all(20),
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              initialPosition = !initialPosition!;
              var index = 0;
              if (!initialPosition!) {
                index = 1;
              }
              widget.onToggleCallback!(index);
              setState(() {});
            },
            child: Container(
              width: _appSize * 0.4,
              height: _appSize * 0.13,
              decoration: ShapeDecoration(
                color: widget.backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_appSize * 0.1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  widget.values!.length,
                  (index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: _appSize * 0.05),
                    child: Text(
                      widget.values![index],
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: _appSize * 0.045,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xAA000000),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.decelerate,
            alignment:
                initialPosition! ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: _appSize * 0.2,
              height: _appSize * 0.13,
              decoration: ShapeDecoration(
                color: widget.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_appSize * 0.1),
                ),
              ),
              child: Text(
                initialPosition! ? widget.values![0] : widget.values![1],
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 12,
                  color: widget.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }
}