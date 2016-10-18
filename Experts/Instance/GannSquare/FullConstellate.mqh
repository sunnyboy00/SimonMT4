//+------------------------------------------------------------------+
//|                                              FullConstellate.mqh |
//|                                                            Simon |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Simon"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "Gann.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


class FullConstellate : public Gann
  {
private:
                  int mRunType;
                  double mBeginValue;
                  double mStep;
                  int mParts;
                  bool mArrangeResult;
public:
                     FullConstellate();
                    ~FullConstellate();
                    virtual void Run(GannValue* &values[]);
                    void SetDatas(int run_type, double begin_value, double step, double parts, bool arrange_result);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
FullConstellate::FullConstellate()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
FullConstellate::~FullConstellate()
  {
  }
//+------------------------------------------------------------------+
void FullConstellate::SetDatas(int run_type, double begin_value, double step, double parts, bool arrange_result){
   mRunType = run_type;
   mBeginValue = begin_value;
   mStep = step;
   mParts = parts;
   mArrangeResult = arrange_result;
}
void FullConstellate::Run(GannValue* &values[]){
   double Null[];
   GannValue *TempBefore1[];
   GannValue *TempBefore2[];
   GannValue *TempNow[];
   GannValue *ReturnArray[];
   int size_temp_b1 = ArraySize(TempBefore1);
   ArrayResize(TempBefore1, ++size_temp_b1);
   GannValue *cons0 = new GannValue();
   cons0.part = 0;
   cons0.value=mBeginValue;
   TempBefore1[0]=cons0;
   
   for(int i = 0; i<mParts; i++){
      int partNow = i+1;
      //開始跑前一段的90度
      for(int j = 0; j < ArraySize(TempBefore1); j++){ 
         int size_temp_now = ArraySize(TempNow);
         ArrayResize(TempNow, ++size_temp_now);
         double value = RunAngle(mRunType, TempBefore1[j].value, Null);
         GannValue *cons = new GannValue();
         cons.part = partNow;
         cons.value=value;
         TempNow[size_temp_now-1] = cons;
         //Alert("temp now => "+j+" value: "+value); 
         
         //同時放一份到欲回傳陣列         
         int size_returnarray = ArraySize(ReturnArray);
         ArrayResize(ReturnArray, ++size_returnarray);
         ReturnArray[size_returnarray-1]=cons;
      }
      
      //開始跑前二段的180度
      for(int k = 0; k < ArraySize(TempBefore2); k++){ 
         int size_temp_now = ArraySize(TempNow);
         ArrayResize(TempNow, ++size_temp_now);
         double value = RunCross(mRunType, TempBefore2[k].value, mStep, Null);
         GannValue *cons = new GannValue();
         cons.part = partNow;
         cons.value = value;
         TempNow[size_temp_now-1] = cons;
         //Alert("temp now => "+k+" value: "+value); 
         
         //同時放一份到欲回傳陣列         
         int size_returnarray = ArraySize(ReturnArray);
         ArrayResize(ReturnArray, ++size_returnarray);
         ReturnArray[size_returnarray-1]=cons;
      }
      ArrayFree(TempBefore2);
      ArrayCopy(TempBefore2, TempBefore1, 0, 0, WHOLE_ARRAY);
      ArrayCopy(TempBefore1, TempNow, 0, 0, WHOLE_ARRAY);
      ArrayFree(TempNow);
     
   }
   
   bool run_bool = FALSE;
   if(mRunType==RUN_HIGH){
      run_bool = TRUE;
   }
   // 篩選掉相近值
   if(mArrangeResult)MyMath::ArrangeConstellate(run_bool, ReturnArray);
   //Debug::PrintArray("ReturnArray", ReturnArray);
   ArrayCopy(values, ReturnArray, 0, 0 , WHOLE_ARRAY);
}