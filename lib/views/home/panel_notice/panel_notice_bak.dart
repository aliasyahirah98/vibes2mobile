import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';

class PanelNoticeBakState extends StatelessWidget {
  const PanelNoticeBakState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: <Widget>[
          Container(
            // elevation: 4.0,
            width: MediaQuery.of(context).size.width,
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              // border: Border.all(width: 1.0, color: (Colors.grey[300])!),
              color: Color(0xFFC2AA92),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 160,
            margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              border: Border.all(width: 1.0, color: (Colors.grey[300])!),
              color: const Color(0xFFD2D2D2),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border: Border.all(width: 1.0, color: (Colors.grey[300])!),
                      color: const Color(0xFFFFFFFF),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '10',
                          style: utils.getTextStyleRegular(fontSize: 15, color: Colors.black, weight: FontWeight.w700)
                        ),
                        // const SizedBox(height: 5),
                        Text(
                          'MAR',
                          style: utils.getTextStyleRegular(fontSize: 15, color: Colors.black, weight: FontWeight.w700)
                        )
                      ]
                    )
                  ),
                  const SizedBox(width: 10),
                  const VerticalDivider(color: Colors.black87),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          child: Text(
                            'MY VETERAN HERO CHARITY RUN 2020',
                            style: utils.getTextStyleRegular(fontSize: 15, color: Colors.black, weight: FontWeight.w700),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis
                          )
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Icon(CupertinoIcons.calendar, color: secondColor, size: 20),
                            const SizedBox(width: 10),
                            Text(
                              'AHAD',
                              style: utils.getTextStyleRegular(fontSize: 13, color: Colors.black)
                            )
                          ]
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Icon(CupertinoIcons.clock, color: secondColor, size: 20),
                            const SizedBox(width: 10),
                            Text(
                              '07:00 AM',
                              style: utils.getTextStyleRegular(fontSize: 13, color: Colors.black)
                            )
                          ]
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Icon(CupertinoIcons.location, color: secondColor, size: 20),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 195,
                              child: Text(
                              'Parking C, Bukit Jalil National Stadium',
                              style: utils.getTextStyleRegular(fontSize: 13, color: Colors.black),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis
                            ))
                          ]
                        )
                      ]
                    )
                  )
                ],
              )
            )
          )
        ]
      )
    );
  }
}