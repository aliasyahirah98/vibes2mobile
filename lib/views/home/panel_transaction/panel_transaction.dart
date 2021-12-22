import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myveteran/blocs/transaction/transaction_history_bloc.dart';
import 'package:myveteran/core/models/transaction/transaction_history_model.dart';
import 'package:myveteran/core/provider/response.dart';
import 'package:myveteran/shared/components/error_handling/error_sync.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';

class PanelTransactionState extends StatefulWidget {
  final double? paddingTop;

  const PanelTransactionState({Key? key, @required this.paddingTop}) : super(key: key);

  @override
  _PanelTransactionState createState() => _PanelTransactionState();
}

class _PanelTransactionState extends State<PanelTransactionState> {
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
    return StreamBuilder<Response<TransactionHistoryModel?>>(
      stream: _bloc!.resultStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status!) {
            case Status.loading:
              return Container(
                padding: const EdgeInsets.only(bottom: 5),
                child: const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(mainColor))),
              );
            case Status.completed:
              return snapshot.data!.data!.returnCode == 200 ? _currentTransaction(snapshot.data!.data!) : utils.noDataFound(context);
            case Status.error:
              return Stack(
                children: <Widget>[
                  Container(
                    // elevation: 4.0,
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    margin: EdgeInsets.only(top: widget.paddingTop! + 190, left: 15.0, right: 15.0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      // border: Border.all(width: 1.0, color: (Colors.grey[300])!),
                      color: Color(0xFFC2AA92),
                    )
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                    margin: EdgeInsets.only(top: widget.paddingTop! + 160, left: 15.0, right: 15.0),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border: Border.all(width: 1.0, color: (Colors.grey[300])!),
                      color: const Color(0xFFD2D2D2),
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 1.5,
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              snapshot.data!.message!,
                              style: utils.getTextStyleRegular(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            )
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => _bloc!.loadTransactionHistory(token: _token, monthYear: selectedYear.toString() + (selectedMonth! > 9 ? selectedMonth.toString() : '0' + selectedMonth.toString())),
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
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    )
                  )
                ]
              );
          }
        }
        return Container();
      }
    );
  }

  Widget _currentTransaction(TransactionHistoryModel item) {
    return Stack(
      children: <Widget>[
        Container(
          // elevation: 4.0,
          width: MediaQuery.of(context).size.width,
          height: 60,
          margin: EdgeInsets.only(top: widget.paddingTop! + 190, left: 15.0, right: 15.0),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            // border: Border.all(width: 1.0, color: (Colors.grey[300])!),
            color: Color(0xFFC2AA92),
          )
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 80,
          margin: EdgeInsets.only(top: widget.paddingTop! + 160, left: 15.0, right: 15.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            border: Border.all(width: 1.0, color: (Colors.grey[300])!),
            color: const Color(0xFFD2D2D2),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  utils.getTranslated('latestPaymentOn', context) + ' ' + monthly[selectedMonth! - 1] + '-' + selectedYear.toString(),
                  style: utils.getTextStyleRegular(fontSize: 12, color: Colors.black87, fontStyle: FontStyle.italic)
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(text: 'RM ', style: utils.getTextStyleRegular(fontSize: 15, color: secondColor, weight: FontWeight.w700)),
                          TextSpan(text: item.totalPaid!.toStringAsFixed(2), style: utils.getTextStyleRegular(fontSize: 22, color: secondColor, weight: FontWeight.w700))
                        ]
                      )
                    ),
                    Container(
                      width: 150,
                      height: 25,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        // border: Border.all(width: 1.0, color: (Colors.grey[300])!),
                        color: Color(0xFFFFFFFF),
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
                                utils.getTranslated('transactionHistory', context) + ' >>',
                                style: utils.getTextStyleRegular(fontSize: 12, color: secondColor)
                              ),
                            ],
                          ),
                          onTap: () => {
                            Navigator.of(context).pushNamed(transactionHistory)
                          }
                        )
                      )
                    ),
                  ]
                ),
              ],
            )
          )
        )
      ]
    );
  }
}