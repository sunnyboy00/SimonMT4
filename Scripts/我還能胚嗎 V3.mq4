//+------------------------------------------------------------------+
//|                                                        我還能胚嗎.mq4 |
//|                                                            Simon |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Simon Pan"
#property link      "https://www.mql5.com"
#property link      "mailto:lp43simonATgmail.com"
#property version   "2.00"
#property description "點擊兩下，輕鬆幫你計算倉位。"

#property strict
#property show_inputs

enum ENUM_COMPUTER_TYPE
{
   依照全部幣別 = 1,
   依照目前視窗幣別 = 2
};
double totalOpenLots;
double totalBuyLots;
double totalSellLots;
double totalSwap;
string symbol; //幣別

input unsigned int 請輸入可承受步數 = 3000;
input ENUM_COMPUTER_TYPE 請選擇倉位計算方式 = 依照全部幣別;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
int OnStart()
  {
     int total = OrdersTotal();
     for(int i=total-1;i>=0;i--)
     {
       bool res = OrderSelect(i, SELECT_BY_POS);
       
       if(請選擇倉位計算方式 == 依照全部幣別){
            symbol = "全部幣別";
            Compute();
       }else if(請選擇倉位計算方式 == 依照目前視窗幣別){
           symbol = Symbol();
           if(OrderSymbol() == symbol)
           {
              Compute();
           }
       }
       
     }
      AlertResult(); 
      return(INIT_SUCCEEDED);
  }
  
void Compute()
{
       int type   = OrderType();
       double lots = OrderLots();
       double swap = OrderSwap();
       if(type==OP_BUY)
       {
         totalBuyLots +=lots;
       }else if(type==OP_SELL){
         totalSellLots+=lots;       
       }
       totalSwap +=swap;
       totalOpenLots = totalBuyLots+ totalSellLots;
}

void AlertResult()
{    
   if(totalOpenLots==0){
        Alert("=================================================");
        Alert("您場上未持有"+symbol+"任何手數。");
        Alert("----------------------------------------------------------------------------------");
        Alert("["+symbol+"]"+"                    "+"現在時間"+"  "+TimeToString(TimeLocal()));
   }else{
        Alert("=================================================");
         
      if(symbol=="全部幣別"){
        double safeSlots = AccountEquity()/請輸入可承受步數;
        if(totalOpenLots>safeSlots){
            Alert("                                    "+"***您已超出安全手數"+DoubleToStr(totalOpenLots-safeSlots,2)+"手，請留意***");
        }else{
            Alert("                                    "+"***您尚有"+DoubleToStr(safeSlots-totalOpenLots,2)+"手的安全手數空間***");
        }
        Alert(" ");
        Alert("您的安全手數為"+"           "+"淨值"+DoubleToStr(AccountEquity(),2)+" ÷ "+"可承受步數"+IntegerToString(請輸入可承受步數)+" = "+DoubleToStr(safeSlots,2)+"手");
        Alert("目前可承受步數"+"           "+"淨值"+DoubleToStr(AccountEquity(),2)+" ÷ "+"總手數"+DoubleToStr(totalOpenLots,2)+" = "+DoubleToStr((AccountEquity()/totalOpenLots),0)+"步");
        Alert("爆倉安全手數"+"               "+"淨值"+DoubleToStr(AccountEquity(),2)+" ÷ "+"50 * 100% ÷ 2 * 0.01"+" = "+DoubleToStr((AccountEquity()/50*100/2*0.01),2)+"手"+" (在未對鎖狀況下)");
      }
        Alert("累積庫存費"+"                  "+(totalSwap>=0?"+":"-")+DoubleToStr(totalSwap,2)+"美元");
        Alert("----------------------------------------------------------------------------------");
        Alert("BUY單總手數"+"                "+DoubleToStr(totalBuyLots,2)+"手");
        Alert("SELL單總手數"+"               "+DoubleToStr(totalSellLots,2)+"手");
        Alert(" ");
        Alert("總手數"+"                          "+DoubleToStr(totalOpenLots,2)+"手");
        Alert("----------------------------------------------------------------------------------");
        Alert("["+symbol+"]"+"                    "+"現在時間"+"  "+TimeToString(TimeLocal()));
    }

}
//+------------------------------------------------------------------+
