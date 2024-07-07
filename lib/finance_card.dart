import 'package:flutter/material.dart';
import 'package:flutter_application_2/stocks.dart';
import 'package:intl/intl.dart';

class FinanceCard extends StatelessWidget {
  late Stock stock;

  FinanceCard({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0');

    return GestureDetector( // 클릭 이벤트를 위한 GestureDetector
      onTap: () {
        print('touched!!!');
      },
      child: Card(
        //color: stock.chagesRatio > 0 ? Colors.red : stock.chagesRatio < 0 ? Colors.blue : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(stock.name, style: TextStyle(),),
                    Text(stock.code),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(formatter.format(int.parse(stock.close))),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${stock.chagesRatio.toString()}%', style: TextStyle(color: stock.chagesRatio > 0 ? Colors.red : stock.chagesRatio < 0 ? Colors.blue : Colors.black,),), 
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(stock.volume.toString()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class MyText extends StatelessWidget{
 final String text;
 final double condition;
 final double fontSize;

  

 MyText({required this.text, required this.condition, this.fontSize=16});
    //super(data, style:style);

    @override
    Widget build(BuildContext context){
      Color color=Colors.black;
      if(condition==1){
        color=Colors.red;
    }else if(condition==2){
      color=Colors.blue;
    }

    return Text(text, style: TextStyle(color: color, fontSize: fontSize));
  }
}