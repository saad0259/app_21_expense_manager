import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String _label;
  final double spentAmount, spentPercentage;
  const ChartBar(this._label, this.spentAmount, this.spentPercentage);
  @override
  Widget build(BuildContext context) { 
    return LayoutBuilder(builder: (ctx, constraints){

      return Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: constraints.maxHeight*0.15,
              child:
              FittedBox(child: Text('\$${spentAmount.toStringAsFixed(0)}'))),
          SizedBox(
            height: constraints.maxHeight*0.05,
          ),
          Container(
            height: constraints.maxHeight*0.6,
            width: 10,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xff666666), width: 1),
                    color: Color(0xffbbbbbb),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: spentPercentage,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: constraints.maxHeight*0.05,
          ),
          Container(
            height: constraints.maxHeight*0.15,
            child: FittedBox(
              child: Text(
                _label,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ),
        ],
      );
    });
      
  }
}
