//+------------------------------------------------------------------+
//|                                                         趨勢轉向.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "http://www.mql4.com"
#property version   "1.00"
#property strict
#property indicator_chart_window

double         ExtUppperBuffer[];
double         ExtLowerBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
    ChartApplyTemplate(0,"BB.tpl");
    
    DrawLable("bars", "Bar Size: "+Bars,16, ANCHOR_RIGHT,10, 10, clrWhite);
    
    //---- 2 allocated indicator buffers
    SetIndexBuffer(0,ExtUppperBuffer);
    SetIndexBuffer(1,ExtLowerBuffer);
   
    //---- drawing parameters setting
    SetIndexStyle(0,DRAW_ARROW);
    SetIndexArrow(0,233);
    SetIndexStyle(1,DRAW_ARROW);
    SetIndexArrow(1,234);
//---
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
void DrawLable(string Name, string text, int size, int right_left, int x_distance, int y_distance, color clr)
{
   ObjectCreate(Name, OBJ_LABEL, 0, 0, 0);
   ObjectSet(Name, OBJPROP_CORNER, right_left);
   ObjectSet(Name, OBJPROP_XDISTANCE, x_distance);
   ObjectSet(Name, OBJPROP_YDISTANCE, y_distance);
   ObjectSet(Name, OBJPROP_ALIGN, ALIGN_RIGHT);

   ObjectSetText(Name,text,size,"Arial",clr);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
      

    //--- Get the number of bars available for the current symbol and chart period
   int bars=Bars(Symbol(),0);
   Print("Bars = ",bars,", rates_total = ",rates_total,",  prev_calculated = ",prev_calculated);
   Print("time[0] = ",time[0]," time[rates_total-1] = ",time[rates_total-1]);
//--- return value of prev_calculated for next call
   return(rates_total);
  }