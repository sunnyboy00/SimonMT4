//+------------------------------------------------------------------+
//|                                                   HelloTimer.mq4 |
//|                                                            Simon |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Simon"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "Utils\MyTimer.mqh"

//--- input parameters
input string   啟動時間="00:00";
input string   結束時間="23:59";

MyTimer timer;
bool IsEAShouldBeRun;
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
//---
  if(IsTradeAllowed()){
  
     //if(timer.IsTimeMatch(StringSubstr(啟動時間, 0, 2), StringSubstr(啟動時間, 3, 2))){
       if(timer.IsTimeMatch(啟動時間)){
         IsEAShouldBeRun = true;
         Alert("EA On");
      }
      if(timer.IsTimeMatch(StringSubstr(結束時間, 0, 2), StringSubstr(結束時間, 3, 2))){
         IsEAShouldBeRun = false;
          Alert("EA Off");
      }
  }
  

  }
//+------------------------------------------------------------------+
