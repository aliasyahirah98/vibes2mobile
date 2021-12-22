import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:myveteran/shared/components/custom_button/button_round.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';

class GroupModel {
  String? text;
  int? index;
  bool? selected;

  GroupModel({this.text, this.index, this.selected});
}

class CourseListOptionState extends StatefulWidget {
  const CourseListOptionState({Key? key}) : super(key: key);
  
  @override
  _CourseListOptionState createState() => _CourseListOptionState();
}

class _CourseListOptionState extends State<CourseListOptionState> {
  final ScrollController scrollController = ScrollController();

  double _offSet = 0.0;

  int _radioValue1 = 1;
  final List<GroupModel> _radioGroup1 = [
    GroupModel(text: 'Pusat Binaan & Kejuruteraan', index: 1, selected: true),
    GroupModel(text: 'Pusat Kejuruteraan & Automatif', index: 2, selected: false),
    GroupModel(text: 'Pusat Kejuruteraan Elektrik & Elektronik', index: 3, selected: false),
    GroupModel(text: 'Pusat Pengurusan Pelancongan & Perhotelan', index: 4, selected: false),
    GroupModel(text: 'Pusat Media & ICT', index: 5, selected: false),
    GroupModel(text: 'Pusat Pengurusan Perkhidmatan Makanan dan Sajian', index: 6, selected: false),
    GroupModel(text: 'Bahagian Pengajian Pengurusan', index: 7, selected: false),
    GroupModel(text: 'Lain-lain', index: 8, selected: false)
  ];

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() => 
      setState(() {
        //<-----------------------------
        _offSet = scrollController.offset;
        // print('_offSet $_offSet');
        // force a refresh so the app bar can be updated
      })
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          leading: utils.backHeaderButton(context, backIcon: CupertinoIcons.chevron_back),
          brightness: Brightness.light,
          elevation: _offSet > 6 ? 1.0 : 0.0,
          title: Text(
            utils.getTranslated('courseList', context),
            style: utils.getTextStyleRegular(color: mainColor, fontSize: 22, weight: FontWeight.bold)
          ),
          backgroundColor: Colors.white
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
                      ),
                      color: const Color(0xFFEBEBEB),
                    ),
                    child: Text(
                      utils.getTranslated('categoryOfCourse', context),
                      style: utils.getTextStyleRegular(fontSize: 17, color: secondColor, weight: FontWeight.w700)
                    )
                  ),
                  makeRadioTiles(_radioGroup1, 'Group1')
                ]
              )
            ]
          )
        ),
        bottomNavigationBar: Container(
          height: 90,
          decoration: BoxDecoration(
          // color: Colors.red,
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10)
            )
          ),
          child: ButtonRound(
            width: MediaQuery.of(context).size.width - 30,
            btnName: utils.getTranslated('next', context),
            borderColor: Colors.white,
            btnColor: secondColor,
            colorTitle: Colors.white,
            onSubmit: () {
              Navigator.of(context).pop();
            }
          ),
        )
      )
    );
  }

  Widget makeRadioTiles(List<GroupModel> radioGroup, String groupName) {
    List<Widget> radioItem = [];

    for (int i = 0; i < radioGroup.length; i++) {
      radioItem.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: RadioListTile<int>(
            value: radioGroup[i].index!,
            groupValue: _radioValue1,
            selected: radioGroup[i].selected!,
            onChanged: (int? val) {
              setState(() {
                for (int i = 0; i < radioGroup.length; i++) {
                  radioGroup[i].selected = false;
                }
                _radioValue1 = val!;
                radioGroup[i].selected = true;
              });
            },
            activeColor: secondColor,
            controlAffinity: ListTileControlAffinity.trailing,
            title: Text(
              ' ${radioGroup[i].text}',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: utils.getTextStyleRegular(
                color: radioGroup[i].selected! ? secondColor : Colors.grey,
                fontSize: 15,
                weight: radioGroup[i].selected! ? FontWeight.w500 : FontWeight.normal
              ),
              textAlign: TextAlign.left,
            ),
          )
        )
      );

      radioItem.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: const Divider(height: 3)
        )
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: radioItem,
    );
  }
}