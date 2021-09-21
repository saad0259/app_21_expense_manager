import 'package:app_21_expense_manager/Widgets/ChartBar.dart';
import 'package:flutter/material.dart';
import '../Models/transactions.dart';
import 'package:intl/intl.dart';
import './ChartBar.dart';

class Chart extends StatelessWidget {
  final List<Transactions> transactions;

  const Chart(this.transactions);

  List<Map<String, dynamic>> get groupedTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalExpense = 0.0;
      for (var i = 0; i < transactions.length; i++) {
        if (transactions[i].date.day == weekDay.day &&
            transactions[i].date.month == weekDay.month &&
            transactions[i].date.year == weekDay.year) {
          totalExpense += transactions[i].amount;
        }
      }

      // print('${DateFormat.E().format(weekDay)} $totalExpense');
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalExpense
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactions.fold(0.0, (previousValue, element) {
      return previousValue + element['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTransactions);
    return Card(

      elevation: 2,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding:const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: groupedTransactions.map((e) {
            return Flexible(

                fit: FlexFit.tight,
                child: ChartBar(
                    e['day'].toString(),
                    e['amount'],
                    totalSpending == 0
                        ? 0
                        : (e['amount'] as double) / totalSpending));
          }).toList(),
        ),
      ),
    );
  }
}
