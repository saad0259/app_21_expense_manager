import 'package:app_21_expense_manager/Widgets/transactionTile.dart';
import 'package:flutter/material.dart';
import '../Models/transactions.dart';

class TransactionList extends StatelessWidget {
  final List<Transactions> transactions;
  final Function delTx;

  TransactionList(this.transactions, this.delTx);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text('No transaction added yet!',
                    style: Theme.of(context).textTheme.headline6),
                const SizedBox(
                  height: 20,
                ),
                Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    )),
              ],
            );
          })
        : ListView.builder(
            itemBuilder: (context, i) {
              return TransactionTile(key: ValueKey(transactions[i].id),transactions: transactions,i: i,delTx: delTx,);
            },
            itemCount: transactions.length,
          );
  }
}
