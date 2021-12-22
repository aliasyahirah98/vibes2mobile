import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:myveteran/blocs/transaction/transaction_history_bloc.dart';
import 'package:myveteran/core/models/transaction/transaction_history_model.dart';
import 'package:myveteran/core/provider/response.dart';
import 'package:myveteran/shared/components/error_handling/error_sync.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';
import 'package:myveteran/views/home/panel_transaction/transaction_history/transaction_receipt.dart';

class TransactionHistoryState extends StatefulWidget {
  const TransactionHistoryState({Key? key}) : super(key: key);
  @override
  _TransactionHistoryState createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistoryState> {
  final ScrollController scrollController = ScrollController();
  final List<dynamic> monthly = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  DateTime now = DateTime.now();
  int? selectedYear, selectedMonth;

  String? _token;

  TransactionHistoryBloc? _bloc;

  @override
  void initState() {
    super.initState();
    selectedYear = now.year;
    selectedMonth = now.month;

    _bloc = TransactionHistoryBloc();
    utils.getToken()!.then((value) {
      _token = value;
      _bloc!.loadTransactionHistory(token: _token, monthYear: selectedYear.toString() + (selectedMonth! > 9 ? selectedMonth.toString() : '0' + selectedMonth.toString()));
      // debugPrint('token $_token');
    });
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
          leading: Padding(
            padding: const EdgeInsets.all(5),
            child: Material(
              shape: const StadiumBorder(),
              color: const Color(0xFFD2D2D2),
              child: InkWell(
                customBorder: const CircleBorder(),
                child: const ClipOval(
                  child: Icon(CupertinoIcons.chevron_back, size: 40, color: secondColor)
                ),
                onTap: () async {
                  Navigator.pop(context, true);
                }
              )
            )
          ),
          elevation: 0.0,
          brightness: Brightness.light,
          title: Text(
            utils.getTranslated('transactionHistory', context),
            style: utils.getTextStyleRegular(color: mainColor, fontSize: 22, weight: FontWeight.bold)
          ),
          backgroundColor: const Color(0xFFD2D2D2)
        ),
        body: StreamBuilder<Response<TransactionHistoryModel?>>(
          stream: _bloc!.resultStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data!.status!) {
                case Status.loading:
                  return Container(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(mainColor))),
                  );
                  // return Shimmer.fromColors(
                  //   baseColor: Colors.grey[300]!,
                  //   highlightColor: Colors.grey[100]!,
                  //   // enabled: _enabled,
                  //   child: ListView.builder(
                  //     itemBuilder: (_, __) => Container(
                  //       padding: const EdgeInsets.all(20),
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: <Widget>[
                  //           Container(
                  //             width: 80,
                  //             height: 8.0,
                  //             color: Colors.white
                  //           ),
                  //           const SizedBox(height: 10),
                  //           Container(
                  //             width: double.infinity,
                  //             height: 8.0,
                  //             color: Colors.white
                  //           )
                  //         ],
                  //       ),
                  //     ),
                  //     itemCount: 15,
                  //   )
                  // );
                case Status.completed:
                  return snapshot.data!.data!.returnCode == 200 ? _itemList(snapshot.data!.data!) : utils.noDataFound(context);
                case Status.error:
                  return ErrorSync(
                    errorMessage: snapshot.data!.message,
                    onRetryPressed: () => _bloc!.loadTransactionHistory(token: _token, monthYear: selectedYear.toString() + (selectedMonth! > 9 ? selectedMonth.toString() : '0' + selectedMonth.toString()))
                  );
              }
            }
            return Container();
          }
        )
      )
    );
  }

  Widget _itemList(TransactionHistoryModel item) {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: 130,
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          color: const Color(0xFFD2D2D2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                utils.getTranslated('totalPaymentAsOf', context) + ' ' + monthly[selectedMonth! - 1] + '-' + selectedYear.toString(),
                style: utils.getTextStyleRegular(fontSize: 15, color: Colors.black, fontStyle: FontStyle.italic),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: 'RM ', style: utils.getTextStyleRegular(fontSize: 15, color: secondColor, weight: FontWeight.w700)),
                    TextSpan(text: item.totalPaid!.toStringAsFixed(2), style: utils.getTextStyleRegular(fontSize: 30, color: secondColor, weight: FontWeight.w700))
                  ]
                )
              )
            ]
          )
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 15,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
            ),
            color: const Color(0xFFC2AA92),
          )
        ),
        Container(
          height: 120,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: Colors.grey[200]!),
            ),
            color: const Color(0xFFFFFFFF),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      utils.getTranslated('paymentStatement', context),
                      style: utils.getTextStyleRegular(fontSize: 16, color: Colors.grey[700]!)
                    )
                  ),
                  Container(
                    width: 100,
                    height: 30,
                    margin: const EdgeInsets.all(5),
                    child: Material(
                      shape: const StadiumBorder(),
                      color: Colors.transparent,
                      child: InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              monthly[selectedMonth! - 1] + ' ' + selectedYear.toString(),
                              style: utils.getTextStyleRegular(fontSize: 14, color: Colors.black, weight: FontWeight.w700)
                            ),
                            const Icon(CupertinoIcons.arrowtriangle_down_fill, size: 15, color: secondColor)
                          ]
                        ),
                        onTap: () async {
                          var datePicked = await DatePicker.showSimpleDatePicker(
                            context,
                            initialDate: DateTime(selectedYear!, selectedMonth!, now.day),
                            firstDate: DateTime(2010),
                            lastDate: DateTime(2030),
                            dateFormat: 'MMMM-yyyy',
                            locale: DateTimePickerLocale.en_us,
                            looping: true,
                            titleText: utils.getTranslated('pleaseSelectDate', context),
                            cancelText: utils.getTranslated('cancel', context),
                            confirmText: utils.getTranslated('save', context),
                            itemTextStyle: utils.getTextStyleRegular(fontSize: 15, color: Colors.black)
                          );

                          if (datePicked != null) {
                            setState(() {
                              selectedYear = datePicked.year;
                              selectedMonth = datePicked.month;
                            });

                            _bloc!.loadTransactionHistory(token: _token, monthYear: selectedYear.toString() + (selectedMonth! > 9 ? selectedMonth.toString() : '0' + selectedMonth.toString()));
                          }

                          // final snackBar = SnackBar(content: Text('Tarikh Dipilih $datePicked'));
                          // ScaffoldMessenger.of(context).showSnackBar(snackBar); 
                        }
                      )
                    )
                  ),
                  Container(
                    width: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: const Divider(height: 3)
                  )
                ],
              ),
              const SizedBox(width: 20),
              Container(
                width: MediaQuery.of(context).size.width / 2 - 100,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  border: Border.all(width: 2.0, color: secondColor),
                  color: const Color(0xFFFFFFFF),
                ),
                child: Material(
                  shape: const StadiumBorder(),
                  color: Colors.transparent,
                  child: InkWell(
                    // customBorder: const CircleBorder(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          utils.getTranslated('statement', context).toUpperCase(),
                          style: utils.getTextStyleRegular(fontSize: 14, color: Colors.black87)
                        ),
                      ],
                    ),
                    onTap: () => {
                      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => const TransactionReceiptState(), fullscreenDialog: true))
                    }
                  )
                )
              )
            ],
          )
        ),
        item.paymentList!.isNotEmpty ? Expanded(
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: scrollController,
            shrinkWrap: true,
            itemCount: item.paymentList!.length,
            itemBuilder: (context, index) => _transactionItem(item.paymentList![index])
          )
        ) : utils.noDataFound(context)
      ]
    );
  }

  Widget _transactionItem(PaymentListModel item) {
    String paymentDate = item.paymentDate!;
    String day = paymentDate.substring(6, 8);
    String month = paymentDate.substring(4, 6);
    String year = paymentDate.substring(0, 4);

    return Container(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      alignment: Alignment.centerLeft,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                item.description!,
                style: utils.getTextStyleRegular(fontSize: 14, color: Colors.black87)
              ),
              Text(
                day + '-' + monthly[int.parse(month) - 1] + '-' + year,
                style: utils.getTextStyleRegular(fontSize: 14, color: Colors.black87)
              ),
            ],
          ),
          Theme(
            data: ThemeData().copyWith(dividerColor: Colors.transparent),
            child: ListTileTheme(
              contentPadding: const EdgeInsets.all(0),
              dense: true,
              child: ExpansionTile(
                tilePadding: const EdgeInsets.all(0),
                title: Text(
                  'RM' + item.paidAmount!,
                  style: utils.getTextStyleRegular(fontSize: 20, color: secondColor, weight: FontWeight.w700)
                ),
                children: <Widget>[
                  ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    title: Text(
                      'Amaun Kasar: RM' + item.grossAmount!,
                      style: utils.getTextStyleRegular(fontSize: 13, color: Colors.grey[600]!)
                    ),
                    trailing: Text(
                      'Potongan: RM' + item.deductionAmount!,
                      style: utils.getTextStyleRegular(fontSize: 13, color: Colors.grey[600]!)
                    ),
                    visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                  )
                ],
              )
            )
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: <Widget>[
          //     Text(
          //       'RM255.00',
          //       style: utils.getTextStyleRegular(fontSize: 20, color: secondColor, weight: FontWeight.w700)
          //     ),
          //     Material(
          //       shape: const StadiumBorder(),
          //       color: Colors.transparent,
          //       child: InkWell(
          //         customBorder: const CircleBorder(),
          //         child: const ClipOval(
          //           child: Icon(CupertinoIcons.arrowtriangle_down_circle, size: 30, color: secondColor)
          //         ),
          //         onTap: () async {
          //           debugPrint('aaa');
          //         }
          //       )
          //     )
          //     // const Icon(CupertinoIcons.arrowtriangle_down_circle, size: 20, color: secondColor)
          //   ],
          // ),
          const SizedBox(height: 10),
          const Divider(height: 10)
        ]
      ),
    );
  }
}