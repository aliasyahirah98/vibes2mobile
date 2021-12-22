import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';
import 'package:flutter/material.dart';

final List<dynamic> spouseICList = [
  {
    'name': 'Wan Arneda Binti Wan Abbas',
    'image': 'assets/images/veteran_ic_2.png',
    'status': 'Aktif'
  },
  {
    'name': 'Rahana Bt Mahmud',
    'image': 'assets/images/veteran_ic_3.png',
    'status': 'Tidak Aktif'
  }
];

class VeteranCardBakState extends StatefulWidget {
  final String? userType;
  const VeteranCardBakState({Key? key, this.userType}) : super(key: key);
  
  @override
  _VeteranCardBakState createState() => _VeteranCardBakState();
}

class _VeteranCardBakState extends State<VeteranCardBakState> {
  final ScrollController scrollController = ScrollController();
  final CarouselController _controller = CarouselController();

  int _current = 0;
  double _offSet = 0.0;

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
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          leading: utils.backHeaderButton(context, backIcon: CupertinoIcons.chevron_back),
          brightness: Brightness.light,
          elevation: _offSet > 6 ? 1.0 : 0.0,
          title: Text(
            utils.getTranslated('veteranCard', context),
            style: utils.getTextStyleRegular(color: mainColor, fontSize: 22, weight: FontWeight.bold)
          ),
          backgroundColor: Colors.white
        ),
        body: SingleChildScrollView(
          controller: scrollController,
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  // height: 260,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.userType == '1' ? utils.getTranslated('veteranPension', context) : utils.getTranslated('dependent', context),
                          style: utils.getTextStyleRegular(fontSize: 16, color: Colors.black, weight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.userType == '1' ? 'Azli Bin Ahmad' : 'Wan Arneda Binti Wan Abbas',
                          style: utils.getTextStyleRegular(fontSize: 18, color: secondColor, weight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.centerLeft,
                        child: _itemBadge(label: 'Aktif')
                      ),
                      const SizedBox(height: 10),
                      Divider(height: 5, color: Colors.grey[400]),
                      const SizedBox(height: 10),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            child: Image.asset(
                              widget.userType == '1' ? 'assets/images/veteran_ic_1.png' : 'assets/images/veteran_ic_2.png', fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width - 50,
                            )
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return _displayCard(widget.userType == '1' ? 'assets/images/veteran_ic_1.png' : 'assets/images/veteran_ic_2.png');
                              },
                              barrierDismissible: true
                            );
                          },
                        )
                      )
                    ]
                  )
                ),
                widget.userType == '1' ? Column(
                  children: <Widget>[
                    const SizedBox(height: 10),
                    Container(
                      height: 330,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 10),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              utils.getTranslated('husbandWife', context),
                              style: utils.getTextStyleRegular(fontSize: 16, color: Colors.black, weight: FontWeight.w700),
                            ),
                          ),
                          Expanded(
                            child: CarouselSlider.builder(
                              options: CarouselOptions(
                                height: 300,
                                autoPlay: true,
                                enlargeCenterPage: true,
                                viewportFraction: 1,
                                // aspectRatio: 2.0,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _current = index;
                                  });
                                }
                              ),
                              itemCount: spouseICList.length,
                              itemBuilder: (BuildContext context, int index, _) => _cardSlider(context, spouseICList[index]),
                            )
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: spouseICList.asMap().entries.map((entry) {
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
                                        .withOpacity(_current == entry.key ? 0.9 : 0.4)
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ]
                      )
                    ),
                    const SizedBox(height: 10),
                  ]
                ) : const SizedBox(height: 10),
                Container(
                  height: 250,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/qr_sample.png', fit: BoxFit.cover,
                          height: 150,
                        )
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/qr_barcode_sample.png', fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width - 200,
                        )
                      )
                    ]
                  )
                ),
              ]
            )
          )
        )
      )
    );
  }

  Widget _cardSlider(BuildContext context, item) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        child: Stack(
          children: <Widget>[
            Text(
              item['name'],
              style: utils.getTextStyleRegular(fontSize: 16, color: secondColor, weight: FontWeight.w700),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: _itemBadge(label: item['status'])
            ),
            Container(
              margin: const EdgeInsets.only(top: 70),
              child: Divider(height: 5, color: Colors.grey[400])
            ),
            Container(
              // height: 180,
              margin: const EdgeInsets.only(top: 100),
              child: Image.asset(item['image'], fit: BoxFit.cover)
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return _displayCard(item['image']);
                      },
                      barrierDismissible: true
                    );
                  },
                )
              )
            )
          ],
        )
      ),
    );
  }

  Widget _displayCard(String path) {
    return Center(
      child: Dialog(
        insetPadding: const EdgeInsets.all(10),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Image.asset(
            path, fit: BoxFit.cover
          )
        ),
      )
    );
  }

  Widget _itemBadge({@required String? label}) {
    return Container(
      width: 100,
      height: 25,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        // border: Border.all(width: 1.0, color: (Colors.grey[300])!),
        color: label == 'Aktif' ? Colors.green : alertColor
      ),
      child: Text(
        label!,
        style: utils.getTextStyleRegular(fontSize: 12, color: const Color(0xFFFFFFFF)),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}