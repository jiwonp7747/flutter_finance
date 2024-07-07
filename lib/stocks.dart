import 'package:http/http.dart' as http;
import 'dart:convert';

class Stock{
  late String code;
  late String name;
  late String market;
  late String marketId;
  late String isuCd;
  late int amount;
  late double chagesRatio;
  late String changeCode;
  late int changes;
  late String close;
  late String dept;
  late int high;
  late int low;
  late int marcap;
  late int open;
  late int stocks;
  late int volume;

  // "Amount": 568418611400,
  //     "ChagesRatio": -0.12,
  //     "ChangeCode": "2",
  //     "Changes": -100,
  //     "Close": "81700",
  //     "Code": "005930",
  //     "Dept": "",
  //     "High": 82300,
  //     "ISU_CD": "KR7005930003",
  //     "Low": 81000,
  //     "Marcap": 487731234335000,
  //     "Market": "KOSPI",
  //     "MarketId": "STK",
  //     "Name": "\uc0bc\uc131\uc804\uc790",
  //     "Open": 82300,
  //     "Stocks": 5969782550,
  //     "Volume": 6969818
  Stock({
      required this.code,
      required this.name,
      required this.market,
      required this.marketId,
      required this.isuCd,
      required this.amount,
      required this.chagesRatio,
      required this.changeCode,
      required this.changes,
      required this.close,
      required this.dept,
      required this.high,
      required this.low,
      required this.marcap,
      required this.open,
      required this.stocks,
      required this.volume,
    });

  factory Stock.fromJson(Map<String, dynamic> json){
    return Stock(
      code: json['Code'] ?? '',
      name: json['Name'] ?? '',
      market: json['Market']?? '',
      marketId: json['MarketId']?? '',
      isuCd: json['IsuCd']?? '',
      amount: json['Amount']?? 0,
      chagesRatio: json['ChagesRatio']?? 0.0,
      changeCode: json['ChangeCode']?? '',
      changes: json['Changes']?? 0,
      close: json['Close']?? '',
      dept: json['Dept']?? '',
      high: json['High']?? 0,
      low: json['Low']?? 0,
      marcap: json['Marcap']?? 0,
      open: json['Open']?? 0,
      stocks: json['Stocks']?? 0,
      volume: json['Volume']?? 0

    );
  }
}

class StockService{
  Future<List<Stock>> getStocks({int page=1, int ppv=20}) async{
    String url='http://223.194.153.183:8070/stocks?page=$page&ppv=$ppv'; //외부 접속 ip 주소 
    print('Requesting stocks from URL: $url');

    final response = await http.get(Uri.parse(url)); // http 응답 받기 
    
    if(response.statusCode==200){
      
      Map<String, dynamic> body = jsonDecode(response.body); // 문자열 json 데이터를 파싱하여 원하는 형태로 받음
      List<dynamic> data=body['data']; // json 데이터의 data 부분만 추출
      List<Stock> stocks = data.map((dynamic item) => Stock.fromJson(item)).toList(); // Json 데이터를 Stock 객체로 매핑 
      
      return stocks;
    }else{
      throw Exception('Failed to load stocks');
    }
  }

//   Future<List<Stock>>(String code) async{
//     //String url='http://
// }
}
