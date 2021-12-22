import 'package:flutter/material.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';

class ErrorSync extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback? onRetryPressed;

  const ErrorSync({Key? key, this.errorMessage, this.onRetryPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            errorMessage!,
            textAlign: TextAlign.center,
            style: utils.getTextStyleRegular(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: onRetryPressed,
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.resolveWith(
                (states) {
                  return states.contains(MaterialState.pressed)
                    ? Colors.green[500]
                    : null;
                },
              ),
              elevation: MaterialStateProperty.all<double>(1.0),
              backgroundColor: MaterialStateProperty.all<Color>(mainColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))
                )
              )
            ),
            child: Text(
              "Retry",
              style: utils.getTextStyleRegular(fontSize: 14, color: Colors.white)
            ),
          )
        ],
      ),
    );
  }
}