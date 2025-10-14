import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/expense.dart';
import 'chartbar.dart';

class Chart extends StatelessWidget {
  const Chart(this.txList, {super.key});

  final List<Expense> txList;

  List<Expense> get recentTransaction {
    DateTime sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));

    return txList.where((Expense tx) {
      return tx.date.isAfter(sevenDaysAgo);
    }).toList();
  }

  List<Map<String, Object>> get groupedTransaction {
    return List.generate(7, (int index) {
      DateTime date = DateTime.now().subtract(Duration(days: index));
      double amount = 0;

      for (var tx in recentTransaction) {
        if (date.day == tx.date.day) amount += tx.amount;
      }

      return {
        'amount': amount.toStringAsFixed(0),
        'weekDay': DateFormat.E().format(date).substring(0, 1),
      };
    }).reversed.toList();
  }

  double get highestSpending {
    double amount = 0;

    for (var tx in groupedTransaction) {
      if (double.parse(tx['amount'] as String) > amount) {
        amount = double.parse(tx['amount'] as String);
      }
    }

    return amount;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        margin: const EdgeInsets.only(
          top: 15,
          left: 20,
          right: 20,
          bottom: 10,
        ),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (index) {
              return Expanded(
                child: ChartBar(groupedTransaction[index], highestSpending),
              );
            }),
          ),
        ),
      ),
    );
  }
}
