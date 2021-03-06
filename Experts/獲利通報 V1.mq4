//+------------------------------------------------------------------+
//|                                                      獲利通報 V1.mq4 |
//|                                                            Simon |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Simon"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property description "EA02-獲利通報助理EA"
#include "Transaction\MyTradeHelper.mqh"

//--- input parameters


MyTradeHelper tradeHelper;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
    if(IsTradeAllowed()){
       double profitPrice = tradeHelper.ProfitNotify();
       //Alert("獲利 "+profitPrice+" 美元中");
       if( profitPrice > 0)
       {
           SendNotification("["+Symbol()+"] 獲利 "+profitPrice+" 美元中");
       }
       else
       {
       }
    }
   
   
  }
//+------------------------------------------------------------------+
