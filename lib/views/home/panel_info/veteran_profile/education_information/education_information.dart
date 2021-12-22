import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:myveteran/blocs/veteran/veteran_education_bloc.dart';
import 'package:myveteran/core/models/veteran/veteran_education_model.dart';
import 'package:myveteran/core/provider/response.dart';
import 'package:myveteran/shared/components/custom_button/button_round.dart';
import 'package:myveteran/shared/components/error_handling/error_sync.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class EducationInformationState extends StatefulWidget {
  const EducationInformationState({Key? key}) : super(key: key);
  
  @override
  _EducationInformationState createState() => _EducationInformationState();
}

class _EducationInformationState extends State<EducationInformationState> {
  final ScrollController scrollController = ScrollController();
  final CarouselController _controller = CarouselController();

  int _currentLangIdx = 0, _currentEducationIdx = 0, _currentJobIdx = 0;

  String? _token;
  double _offSet = 0.0;

  VeteranEducationBloc? _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = VeteranEducationBloc();
    utils.getToken()!.then((value) {
      _token = value;
      _bloc!.loadVeteranEducation(token: _token);
      // debugPrint('token $_token');
    });

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
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          leading: utils.backHeaderButton(context, backIcon: CupertinoIcons.chevron_back),
          brightness: Brightness.light,
          elevation: _offSet > 6 ? 1.0 : 0.0,
          title: Text(
            utils.getTranslated('educationAndSkillsInformation', context),
            style: utils.getTextStyleRegular(color: mainColor, fontSize: 20, weight: FontWeight.bold)
          ),
          backgroundColor: Colors.white
        ),
        body: StreamBuilder<Response<VeteranEducationModel?>>(
          stream: _bloc!.resultStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data!.status!) {
                case Status.loading:
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    // enabled: _enabled,
                    child: ListView.builder(
                      itemBuilder: (_, __) => Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 80,
                              height: 8.0,
                              color: Colors.white
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              height: 8.0,
                              color: Colors.white
                            )
                          ],
                        ),
                      ),
                      itemCount: 15,
                    )
                  );
                case Status.completed:
                  return snapshot.data!.data!.returnCode == 200 ? _informationItem(snapshot.data!.data!) : utils.noDataFound(context);
                case Status.error:
                  return ErrorSync(
                    errorMessage: snapshot.data!.message,
                    onRetryPressed: () => _bloc!.loadVeteranEducation(token: _token)
                  );
              }
            }
            return Container();
          }
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // const SizedBox(height: 10),
              ButtonRound(
                width: (MediaQuery.of(context).size.width / 2) - 15,
                btnName: utils.getTranslated('generateResume', context),
                borderColor: Colors.white,
                btnColor: secondColor,
                colorTitle: Colors.white,
                // iconBtn: Icon(Icons.camera_alt_outlined, size: 20, color: mainColor),
                onSubmit: () {
                  Navigator.of(context).pushNamed(resumeTemplate);
                }
              ),
              const SizedBox(width: 10),
              ButtonRound(
                width: (MediaQuery.of(context).size.width / 2) - 15,
                btnName: utils.getTranslated('update', context),
                borderColor: secondColor,
                btnColor: Colors.white,
                colorTitle: secondColor,
                // iconBtn: Icon(Icons.camera_alt_outlined, size: 20, color: mainColor),
                onSubmit: () {
                  Navigator.of(context).pushNamed(updateEducation);
                }
              ),
            ]
          )
        )        
      )
    );
  }

  Widget _informationItem(VeteranEducationModel item) {
    List<dynamic> languageList = [];
    if (item.malayWrite != '') {
      languageList.add({
        'Lang': 'Bahasa Melayu',
        'Write': item.malayWrite ?? '-',
        'Linten': item.malayLinten ?? '-',
        'Read': item.malayRead ?? '-'
      });
    }

    if (item.englishWrite != '') {
      languageList.add({
        'Lang': 'Bahasa Inggeris',
        'Write': item.englishWrite ?? '-',
        'Linten': item.englishLinten ?? '-',
        'Read': item.englishRead ?? '-'
      });
    }

    if (item.chineseWrite != '') {
      languageList.add({
        'Lang': 'Bahasa Cina',
        'Write': item.chineseWrite ?? '-',
        'Linten': item.chineseLinten ?? '-',
        'Read': item.chineseRead ?? '-'
      });
    }

    if (item.otherLanguage1 != '') {
      languageList.add({
        'Lang': item.otherLanguage1,
        'Write': item.otherLanguage1Write ?? '-',
        'Linten': item.otherLanguage1Linten ?? '-',
        'Read': item.otherLanguage1Read ?? '-'
      });
    }

    if (item.otherLanguage2 != '') {
      languageList.add({
        'Lang': item.otherLanguage2,
        'Write': item.otherLanguage2Write ?? '-',
        'Linten': item.otherLanguage2Linten ?? '-',
        'Read': item.otherLanguage2Read ?? '-'
      });
    }

    List<dynamic> educationList = [];
    if (item.educationlevel1SchoolName != '') {
      educationList.add({
        'Educationlevel__study_level': item.educationlevel1StudyLevel,
        'Educationlevel__field_study': item.educationlevel1FieldStudy,
        'Educationlevel_school_name': item.educationlevel1SchoolName,
        'Educationlevel_CGPA_pangkat': item.educationlevel1CGPApangkat,
        'Educationlevel_graduation_year': item.educationlevel1GraduationYear
      });
    }
    if (item.educationlevel2SchoolName != '') {
      educationList.add({
        'Educationlevel__study_level': item.educationlevel2StudyLevel,
        'Educationlevel__field_study': item.educationlevel2FieldStudy,
        'Educationlevel_school_name': item.educationlevel2SchoolName,
        'Educationlevel_CGPA_pangkat': item.educationlevel2CGPApangkat,
        'Educationlevel_graduation_year': item.educationlevel2GraduationYear
      });
    }
    if (item.educationlevel3SchoolName != '') {
      educationList.add({
        'Educationlevel__study_level': item.educationlevel3StudyLevel,
        'Educationlevel__field_study': item.educationlevel3FieldStudy,
        'Educationlevel_school_name': item.educationlevel3SchoolName,
        'Educationlevel_CGPA_pangkat': item.educationlevel3CGPApangkat,
        'Educationlevel_graduation_year': item.educationlevel3GraduationYear
      });
    }

    List<dynamic> jobList = [];
    if (item.jobHist1CompanyName != '') {
      jobList.add({
        'JobHistCompanyName': item.jobHist1CompanyName,
        'JobHistPosition': item.jobHist1Position,
        'JobHistStartDate': item.jobHist1StartDate,
        'JobHistEndDate': item.jobHist1EndDate
      });
    }
    if (item.jobHist2CompanyName != '') {
      jobList.add({
        'JobHistCompanyName': item.jobHist2CompanyName,
        'JobHistPosition': item.jobHist2Position,
        'JobHistStartDate': item.jobHist2StartDate,
        'JobHistEndDate': item.jobHist2EndDate
      });
    }

    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _itemDetails(label: utils.getTranslated('height', context) + ' (CM)', details: item.height, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('weight', context) + ' (KG)', details: item.weight, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('currentOccupation', context), details: item.jobCurrentPosition, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('employer', context), details: item.jobCurrentCompanyName, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('currentSalary', context) + ' (RM)', details: item.jobCurrentSalary, hasMultiInfo: false),
          _itemDetails(label: utils.getTranslated('expectedSalary', context) + ' (RM)', details: item.expectedSalary, hasMultiInfo: false),
          _spacer(),
          _itemDetails(label: utils.getTranslated('generalSkills', context), details: '', hasMultiInfo: false),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 5),
              item.strengthTechnical1 != '' ? _itemTechnical('1', item.strengthTechnical1!) : Container(),
              item.strengthTechnical2 != '' ? _itemTechnical('2', item.strengthTechnical2!) : Container(),
              item.strengthTechnical3 != '' ? _itemTechnical('3', item.strengthTechnical3!) : Container(),
              item.strengthTechnical4 != '' ? _itemTechnical('4', item.strengthTechnical4!) : Container(),
              item.strengthTechnical5 != '' ? _itemTechnical('5', item.strengthTechnical5!) : Container(),
            ]
          ),
          _spacer(),
          _itemDetails(label: utils.getTranslated('courseSkills', context), details: '', hasMultiInfo: false),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 5),
              item.strengthTechnicalSpecial1 != '' ? _itemTechnical('1', item.strengthTechnicalSpecial1!) : Container(),
              item.strengthTechnicalSpecial2 != '' ? _itemTechnical('2', item.strengthTechnicalSpecial2!) : Container(),
              item.strengthTechnicalSpecial3 != '' ? _itemTechnical('3', item.strengthTechnicalSpecial3!) : Container(),
              item.strengthTechnicalSpecial4 != '' ? _itemTechnical('4', item.strengthTechnicalSpecial4!) : Container(),
              item.strengthTechnicalSpecial5 != '' ? _itemTechnical('5', item.strengthTechnicalSpecial5!) : Container(),
            ]
          ),
          _spacer(),
          _itemDetails(label: utils.getTranslated('languages', context), details: '', hasMultiInfo: false),
          Column(
            children: <Widget>[
              CarouselSlider.builder(
                options: CarouselOptions(
                  height: 120,
                  autoPlay: false,
                  enlargeCenterPage: false,
                  viewportFraction: 1,
                  // aspectRatio: 2.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentLangIdx = index;
                    });
                  }
                ),
                itemCount: languageList.length,
                itemBuilder: (BuildContext context, int index, _) => Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _showLanguage(languageList[index]['Lang'], languageList[index]['Write'], languageList[index]['Linten'], languageList[index]['Read'])
                    ]
                  )
                ),
              ),
              languageList.length > 1 ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: languageList.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: Container(
                      width: 12.0,
                      height: 12.0,
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black)
                            .withOpacity(_currentLangIdx == entry.key ? 0.9 : 0.4)
                      ),
                    )
                  );
                }).toList(),
              ) : Container()
            ]
          ),
          _spacer(),
          _itemDetails(label: utils.getTranslated('educationInformation', context), details: '', hasMultiInfo: true, moreDetails: educationList.isNotEmpty ? Column(
            children: <Widget>[
              educationList.length > 1 ? CarouselSlider.builder(
                options: CarouselOptions(
                  height: 210,
                  autoPlay: false,
                  enlargeCenterPage: false,
                  viewportFraction: 1,
                  // aspectRatio: 2.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentEducationIdx = index;
                    });
                  }
                ),
                itemCount: educationList.length,
                itemBuilder: (BuildContext context, int index, _) => Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _moreItemDetails(label: utils.getTranslated('educationLevel', context), details: educationList[index]['Educationlevel__study_level']),
                      _moreItemDetails(label: utils.getTranslated('fieldOfStudy', context), details: educationList[index]['Educationlevel__field_study']),
                      _moreItemDetails(label: utils.getTranslated('instituteSchool', context), details: educationList[index]['Educationlevel_school_name']),
                      _moreItemDetails(label: utils.getTranslated('cgpaRank', context), details: educationList[index]['Educationlevel_CGPA_pangkat']),
                      _moreItemDetails(label: utils.getTranslated('year', context), details: educationList[index]['Educationlevel_graduation_year'])
                    ]
                  )
                ),
              ) : Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _moreItemDetails(label: utils.getTranslated('educationLevel', context), details: educationList[0]['Educationlevel__study_level']),
                    _moreItemDetails(label: utils.getTranslated('fieldOfStudy', context), details: educationList[0]['Educationlevel__field_study']),
                    _moreItemDetails(label: utils.getTranslated('instituteSchool', context), details: educationList[0]['Educationlevel_school_name']),
                    _moreItemDetails(label: utils.getTranslated('cgpaRank', context), details: educationList[0]['Educationlevel_CGPA_pangkat']),
                    _moreItemDetails(label: utils.getTranslated('year', context), details: educationList[0]['Educationlevel_graduation_year'])
                  ]
                )
              ),
              educationList.length > 1 ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: educationList.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: Container(
                      width: 12.0,
                      height: 12.0,
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black)
                            .withOpacity(_currentEducationIdx == entry.key ? 0.9 : 0.4)
                      ),
                    )
                  );
                }).toList(),
              ) : Container()
            ],
          ) : Container()),
          _spacer(),
          _itemDetails(label: utils.getTranslated('workingExperience', context), details: '', hasMultiInfo: true, moreDetails: jobList.isNotEmpty ? Column(
            children: <Widget>[
              jobList.length > 1 ? CarouselSlider.builder(
                options: CarouselOptions(
                  height: 190,
                  autoPlay: false,
                  enlargeCenterPage: false,
                  viewportFraction: 1,
                  // aspectRatio: 2.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentJobIdx = index;
                    });
                  }
                ),
                itemCount: jobList.length,
                itemBuilder: (BuildContext context, int index, _) => Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _moreItemDetails(label: utils.getTranslated('company', context), details: jobList[index]['JobHistCompanyName']),
                      _moreItemDetails(label: utils.getTranslated('position', context), details: jobList[index]['JobHistPosition']),
                      _moreItemDetails(label: utils.getTranslated('startDate', context), details: jobList[index]['JobHistStartDate']),
                      _moreItemDetails(label: utils.getTranslated('endDate', context), details: jobList[index]['JobHistEndDate'])
                    ]
                  )
                )
              ) : Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _moreItemDetails(label: utils.getTranslated('company', context), details: jobList[0]['JobHistCompanyName']),
                    _moreItemDetails(label: utils.getTranslated('position', context), details: jobList[0]['JobHistPosition']),
                    _moreItemDetails(label: utils.getTranslated('startDate', context), details: jobList[0]['JobHistStartDate']),
                    _moreItemDetails(label: utils.getTranslated('endDate', context), details: jobList[0]['JobHistEndDate'])
                  ]
                )
              ),
              jobList.length > 1 ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: jobList.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: Container(
                      width: 12.0,
                      height: 12.0,
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black)
                            .withOpacity(_currentJobIdx == entry.key ? 0.9 : 0.4)
                      ),
                    ),
                  );
                }).toList(),
              ) : Container()
            ],
          ) : Container()),
          _spacer(),
          _itemDetails(label: utils.getTranslated('vehicleLicenses', context), details: item.drivingLicense, hasMultiInfo: false),
          const SizedBox(height: 10)
        ]
      ),
    );
  }

  Widget _itemDetails({@required String? label, @required String? details, bool? hasMultiInfo, Widget? moreDetails}) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              label!,
              style: utils.getTextStyleRegular(fontSize: 16, color: Colors.black, weight: FontWeight.w700),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ),
          details != '' ? Container(
            padding: const EdgeInsets.only(bottom: 5, left: 20, right: 20),
            child: Text(
              details!,
              style: utils.getTextStyleRegular(fontSize: 14, color: Colors.black),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          ) : Container(),
          if (hasMultiInfo!) 
            moreDetails!
          else 
            Container(),
        ]
      ),
    );
  }

  Widget _moreItemDetails({@required String? label, @required String? details}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget> [
        Container(
          width: 190,
          padding: const EdgeInsets.only(top: 10, bottom: 5, left: 25),
          child: Text(
            label!,
            style: utils.getTextStyleRegular(fontSize: 14, color: Colors.black, weight: FontWeight.w500), //fontStyle: FontStyle.italic
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ),
        Expanded(
          child: Container(
          padding: const EdgeInsets.only(top: 10, bottom: 5),
          child: Text(
            details!,
            style: utils.getTextStyleRegular(fontSize: 14, color: Colors.black),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          )
        ))
      ]
    );
  }

  Widget _spacer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 10,
      margin: const EdgeInsets.only(top: 20, bottom: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
        ),
        color: const Color(0xFFEBEBEB),
      )
    );
  }

  Widget _itemTechnical(String number, String item) {
    return Container(
      padding: const EdgeInsets.only(left: 20, bottom: 3),
      child: Text(
        number + '. ' + item,
        style: utils.getTextStyleRegular(fontSize: 14, color: Colors.black),
        maxLines: 1,
        overflow: TextOverflow.ellipsis
      )
    );
  }

  Widget _languages(String item1, String item2) { //String item3
    return Container(
      padding: const EdgeInsets.only(left: 10, bottom: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox(
            width: 95,
            child: Text(
              item1,
              style: utils.getTextStyleRegular(fontSize: 14, color: Colors.black)
            )
          ),
          SizedBox(
            width: 140,
            child: Text(
              item2,
              textAlign: TextAlign.center,
              style: utils.getTextStyleRegular(fontSize: 14, color: Colors.black, weight: item1 == '' ? FontWeight.w700 : FontWeight.normal),
              maxLines: 1,
              overflow: TextOverflow.ellipsis
            )
          ),
          // SizedBox(
          //   width: 115,
          //   child: Text(
          //     item3,
          //     textAlign: TextAlign.center,
          //     style: utils.getTextStyleRegular(fontSize: 14, color: Colors.black),
          //     maxLines: 1,
          //     overflow: TextOverflow.ellipsis
          //   )
          // )
        ]
      )
    );
  }

  Widget _showLanguage(String lang, String write, String linten, String read) {
    return Column(
      children: <Widget>[
        _languages('', lang),
        _languages(utils.getTranslated('write', context), write),
        _languages(utils.getTranslated('listen', context), linten),
        _languages(utils.getTranslated('read', context), read)
      ]
    );
  }
}