//+------------------------------------------------------------------+
//|                                                 TrailingStop.mq4 |
//|                                                            Simon |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Simon"
#property link      "https://www.mql5.com"
#property version   "5.00"
#property strict
#property description "第四版︰添加鎖定MagicNumber功能，手操單代號為0\n第五版︰修復有時候sell沒動作問題"

#include "Transaction\MyTradeHelper.mqh"
#include "Utils\MyTimer.mqh"

//--- input parameters
input int     start_after_point=50;//獲利幾步後啟動
input int     stop_loss_point=30;//追蹤止損步數
input int     magic_number = NULL; //鎖定MagicNumber(手操代號為0)
input int     update=0;//更新頻率(秒)


MyTradeHelper tradeHelper;
MyTimer timer1;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   //Print("Trailingstop OnInit");
   //EventSetTimer(1);
   
//---
   return(INIT_SUCCEEDED);
  }
  
//void OnStart()
  //{
    //  Alert("開始追蹤步數: "+IntegerToString(開始追蹤步數));
  //}
    
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   //--- destroy timer
   //Print("Trailingstop OnDeinit");
   //EventKillTimer();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
  //Print("Trailingstop OnTick");
//---
    if(IsTradeAllowed()){
      if(start_after_point<stop_loss_point)MessageBox("[追蹤止損步數]不得小於[獲利幾步後啟動]!!", NULL, 0);
      if(update>0 && timer1.IsTimeAfterSec(update)==FALSE) return;
      
      //Alert("trailing stop");
      tradeHelper.TrailingStop(start_after_point, stop_loss_point, magic_number);
      
    }
  }
//+------------------------------------------------------------------+
void onTimer()
  {
   //Print("Trailingstop onTimer");
     // Alert("onTimer");
  }