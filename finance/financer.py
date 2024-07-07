import FinanceDataReader as fdr #주식 정보 제공하는 파이썬 라이브러리 
from flask import Flask, request, jsonify
from flask_cors import CORS
from datetime import datetime, timedelta #날짜, 시간 정보 제공하는 파이썬 라이브러리 


app= Flask(__name__)
CORS(app)

# /api/

@app.route('/stock/<string:stock_code>', methods=['GET'])
def get_stock_info(stock_code):
    try:
        req_page=request.args.get('page') #페이지 번호를 줘서 요청 # ?page=xx => 정수형으로 변환 필요
        req_days=request.args.get('days') #일자를 줘서 요청 # ?days=xx => 정수형으로 변환 필요
        
        if len(stock_code) != 6: #주식 코드가 6자리가 아닌 경우 
            return jsonify({'error': 'stock code should be 6 digits'}), 400
        
        #start_date, end_date
        end_date = datetime.now() #현재 날짜, 시간 정보
        start_date = end_date - timedelta(req_days) #현재 날짜에서 30일 이전 날짜
        
        df=fdr.DataReader(stock_code, start=start_date, end=end_date) #주식 코드를 기반으로 데이터 가져오기
        
        # 날짜 형식을 문자열 형식으로 변경 
        df.index = df.index.strftime('%Y-%m-%d')
        
        # 데이터를 리스트 형식으로 변환 
        # all_stock = [] #주식 정보를 가져올 리스트 
        # for i in range(start_idx, end_idx):
        #     stock_data = stock.iloc[i].to_dict() # 데이터프레임의 한 행을(종목) 딕셔너리로 변환 
        #     all_stock.append(stock_data)
        
        #데이터프레임을 딕셔너리(Map 형식)로 변환하여 반환
        # output = {}
        # output['total_count'] =count
        # pages= count//view_count
        # output['total_page'] = pages if count % view_count ==0 else pages +1 
        # output['data'] = all_stock
        
        return jsonify(df.to_dict(orient='index')), 200 
        
    except Exception as e:
        return jsonify({'error':str(e)}), 500

# http://127.0.0.1:8070/stock?code=005930
@app.route('/stock', methods=['GET']) 
def get_stock():
    stock_code = request.args.get('code') # 주식 코드를 기반으로 데이터 가져오기 
    if stock_code is None:
        return jsonify({'error': 'code is required'}), 400 
    
    try:
        # stock=fdr.DataReader(stock_code)
        # return jsonify(stock.to_dict()), 200
        stock = fdr.DataReader(stock_code).head(1) # 압축 코드에 대한 거래 변동 내역 가져오기 head로 최대한개 가져오기.
        stock_dict = stock.reset_index().to_dict(orient='records')
        return jsonify(stock_dict), 200
    except Exception as e:
        return jsonify({'error':str(e)}), 500

#http://127.0.0.1:8070/stocks?page=1&ppv=20

@app.route('/stocks', methods=['GET'])
def get_all_stock():
    req_page=request.args.get('page') #페이지 번호를 줘서 요청 
    if isinstance(req_page, str): # 문자열이면 
        req_page=int(req_page) # int 변환
        
    if req_page is None: 
        req_page=1
    
    if req_page < 1:
        return jsonify({'error': 'page should be grater than 0'}), 400 #에러 메시지 json 화 
    
    view_count = request.args.get('ppv')
    if isinstance(view_count, str):
        view_count = int(view_count)
        
    if view_count is None: 
        view_count=20 
        
    if view_count < 1:
        return jsonify({'error': 'ppv should be grater than 0'}), 400
    
    
    start_idx = (req_page-1)*view_count
    end_idx=start_idx+view_count
    try:
        stock=fdr.StockListing('KRX') #한국거래소 상장종목 전체 #stock 엑셀 표 
        count= stock.shape[0]  #조회된 주식 종목의 총 개수, 데이터프레임의 행 수를 반환 
        
        
        all_stock = [] #주식 정보를 가져올 리스트 
        for i in range(start_idx, end_idx):
            stock_data = stock.iloc[i].to_dict() # 데이터프레임의 한 행을(종목) 딕셔너리로 변환 
            all_stock.append(stock_data)
            
        output = {}
        output['total_count'] =count
        pages= count//view_count
        output['total_page'] = pages if count % view_count ==0 else pages +1 
        output['data'] = all_stock
        
        return jsonify(output), 200

            
    except Exception as e:
        return jsonify({'error':str(e)}), 500
        

if __name__=='__main__':
    app.run(debug=True, host='0.0.0.0', port=8070) #debug는 개발자 모드 
    