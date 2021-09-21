import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Models/transactions.dart';

class TransactionTile extends StatefulWidget {
  final int? i;
  final List<Transactions> transactions;
  final Function delTx;

  const TransactionTile({Key? key, this.i,required this.transactions,required this.delTx}):super(key: key);

  @override
  _TransactionTileState createState() => _TransactionTileState();
}

class _TransactionTileState extends State<TransactionTile> {

  late Color _bgColor;


  @override
  void initState() {
    super.initState();
    const _availableColors=[Colors.deepOrangeAccent, Colors.blue, Colors.pinkAccent];
    _bgColor=_availableColors[Random().nextInt(3)];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: _bgColor,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: FittedBox(
                child: Text(
                    '\$ ${widget.transactions[widget.i!].amount.toStringAsFixed(2)}')),
          ),
        ),
        title: Text(
          widget.transactions[widget.i!].title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle:
        Text(DateFormat.yMMMd().format(widget.transactions[widget.i!].date)),
        trailing: IconButton(
          onPressed: () => widget.delTx(widget.transactions[widget.i!].id),
          icon: Icon(
            Icons.delete,
            color: Theme.of(context).errorColor,
          ),
        ),
      ),
    );
  }
}
