import 'package:flutter/material.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';

class DirectDialogState extends StatefulWidget {
  final String? title;
  final String? messages;
  final String? buttonName;
  final Function? onCallback;

  const DirectDialogState({Key? key, @required this.title, @required this.messages, @required this.buttonName, @required this.onCallback}) : super(key: key);
  
  @override
  _DirectDialogState createState() => _DirectDialogState();
}

class _DirectDialogState extends State<DirectDialogState> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(widget.title!,
                  style: utils.getTextStyleRegular(color: Colors.black, fontSize: 18, weight: FontWeight.bold)
                ),
                const SizedBox(height: 10),
                Text(widget.messages!,
                  style: utils.getTextStyleRegular(color: Colors.black54, fontSize: 15)
                ),
                const SizedBox(height: 5),
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 150,
                    alignment: Alignment.centerRight,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        side: const BorderSide(color: secondColor, width: 2)
                      ),
                      onPressed: () {
                        widget.onCallback!();
                      },
                      child: Text(
                        widget.buttonName!,
                        style: utils.getTextStyleRegular(fontSize: 15, color: secondColor)
                      )
                    )
                  )
                )
              ]
            )
          )
        ]
      )
    );
  }
}