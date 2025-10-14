import 'package:flutter/material.dart';

import '../models/expense.dart';
import 'tx_list_item.dart';

class TransactionList extends StatelessWidget {
  const TransactionList(this.txList, this.deleteTransaction, {super.key});

  final List<Expense> txList;
  final Function deleteTransaction;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 3),
      itemCount: txList.length,
      itemBuilder: (BuildContext context, int index) {
        return TxListItem(txList[index], deleteTransaction);
      },
    );
  }
}
