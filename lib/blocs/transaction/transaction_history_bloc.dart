import 'package:flutter/material.dart';
import 'package:myveteran/core/models/transaction/transaction_history_model.dart';
import 'dart:async';
import 'package:myveteran/core/provider/response.dart';
import 'package:myveteran/core/services/transaction/transaction_history_service.dart';

class TransactionHistoryBloc {
  TransactionHistoryService? _transactionHistoryService;
  final _resultController = StreamController<Response<TransactionHistoryModel>>();

  StreamSink<Response<TransactionHistoryModel>> get resultSink => _resultController.sink;
  Stream<Response<TransactionHistoryModel?>> get resultStream => _resultController.stream;

  TransactionHistoryBloc() {
    _transactionHistoryService = TransactionHistoryService();
  }

  loadTransactionHistory({String? token, String? monthYear}) async {
    resultSink.add(Response.loading('Getting record...'));
    try {
      TransactionHistoryModel record = await _transactionHistoryService!.fetchTransactionHistoryData(token: token, monthYear: monthYear);
      resultSink.add(Response.completed(record));
    } catch (e) {
      resultSink.add(Response.error(e.toString()));
      debugPrint(e.toString());
    }
  }

  dispose() {
    _resultController.close();
  }
}