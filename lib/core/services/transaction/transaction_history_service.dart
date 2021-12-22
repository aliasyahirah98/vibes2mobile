import 'dart:async';
import 'package:myveteran/core/models/transaction/transaction_history_model.dart';
import 'package:myveteran/core/provider/api_sync.dart';
// import 'package:flutter/material.dart';

class TransactionHistoryService {
  final ApiSync _provider = ApiSync();

  Future<TransactionHistoryModel> fetchTransactionHistoryData({String? token, String? monthYear}) async {
    final response = await _provider.getWithHeader('profile/transaction/history?monthYear=' + monthYear!, token!); //api_transaction_history
    // debugPrint('transaction_history $response');
    return TransactionHistoryModel.fromJson(response);
  }
}