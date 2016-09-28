//+------------------------------------------------------------------+
//|                                                        我還能胚嗎.mq4 |
//|                                                            Simon |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Simon"
#property link      "https://www.mql5.com"
#property link      "mailto:lp43simonATgmail.com"
#property version   "1.00"
#property strict
#property show_inputs

input int 請輸入可承受步數=3000;
double totalOpenLots;
double totalBuyLots;
double totalSellLots;
double totalSwap;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
int OnStart()
  {

   
     int total = OrdersTotal();
     for(int i=total-1;i>=0;i--)
     {
       bool res = OrderSelect(i, SELECT_BY_POS);
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
     }
 
     totalOpenLots = totalBuyLots+ totalSellLots;
     
     Alert("===========================================================");
     double safeSlots = AccountEquity()/請輸入可承受步數;
     if(totalOpenLots>safeSlots){
         Alert("***您已超出安全手數"+DoubleToStr(totalOpenLots-safeSlots,2)+"手，請留意***");
     }else{
         Alert("***您尚有"+DoubleToStr(safeSlots-totalOpenLots,2)+"步的安全手數空間***");
     }
     Alert(" ");
     Alert("您的安全手數為=>   "+"淨值"+DoubleToStr(AccountEquity(),2)+" ÷ "+"可承受步數"+IntegerToString(請輸入可承受步數)+" = "+DoubleToStr(safeSlots,2)+"手");
     Alert("目前可承受步數=>   "+"淨值"+DoubleToStr(AccountEquity(),2)+" ÷ "+"總手數"+DoubleToStr(totalOpenLots,2)+" = "+DoubleToStr((AccountEquity()/totalOpenLots),0)+"步");
     Alert("總庫存費=>                 "+(totalSwap>0?"+":"-")+DoubleToStr(totalSwap,2)+"/天");
     Alert("--------------------------------------------------");
     Alert("BUY單總手數=>         "+DoubleToStr(totalBuyLots,2)+"手");
     Alert("SELL單總手數=>        "+DoubleToStr(totalSellLots,2)+"手");
     Alert(" ");
     Alert("總手數=>                    "+DoubleToStr(totalOpenLots,2)+"手");
     Alert("--------------------------------------------------");
     Alert("現在時間=>               "+TimeToString(TimeLocal()));
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
