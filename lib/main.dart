import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/finance_card.dart';
import 'stocks.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({Key? key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:  'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget{
  const MyHomePage({super.key});
  
  @override
  State<StatefulWidget> createState() => _MyHomePageState();

  
}

class _MyHomePageState extends State<MyHomePage>{

  late Future<List<Stock>> futureStocks; // 비동기 처리를 위한 Future 객체

  @override
  void initState(){
    super.initState();
    futureStocks = StockService().getStocks(); // 비동기 처리를 위한 Future 객체 초기화
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('주식 정보 조회'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // SizedBox(height: 8,),
          const Padding(padding: EdgeInsets.all(8.0),),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, //spaceBetween: 각 요소 사이에 동일한 공간을 배분
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2, // 비율
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('종목명'),
                    Text('종목코드'),
                  
                  ],
                ),
              ),
              Expanded(
                flex: 1, 
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('현재가'),
                
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('전일비'),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('거래량'),
                  ],
                ),
              ),
            
            ],
          ),
          const SizedBox(height: 8,),
          Expanded(
            child: FutureBuilder<List<Stock>>(
              future: futureStocks, //data,
              builder: (context, snapshot) { // snapshot: 비동기 처리 결과
                if(snapshot.hasData){
                  return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index){ 
                      Stock stock = snapshot.data![index]; //
                      return FinanceCard(stock: stock); // 
                  },
                );
                }else if(snapshot.hasError){
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator(); // 로딩 중
              },
            ),
          ),
        ],
      ),
    );
  }
}







