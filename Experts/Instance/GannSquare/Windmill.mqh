//+------------------------------------------------------------------+
//|                                                     Windmill.mqh |
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
class Windmill : public Gann
  {
private:
                     
                     double mCompareNum, mBaseNum;
                     void InsertBladeDegrees();
                     void InsertCrossBlades();
                     void InsertAngleBlades();
                   
public:
                     Windmill();
                    ~Windmill();
                    void SetDatas(double compare_num , double base_num);
                    virtual void Run(GannValue* &values[]);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double mCompareNum = 0;
double mBaseNum = 0;
Windmill::Windmill()
  {
  
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Windmill::~Windmill()
  {
  }

//+------------------------------------------------------------------+
void Windmill::SetDatas(double compare_num,double base_num){
   mCompareNum = compare_num;
   mBaseNum = base_num;
}

void Windmill::Run(GannValue* &values[]){
     int BasePosition[2];
     cursor.GetPositionByValue(mBaseNum, BasePosition);
     int ComparePosition[2];
     cursor.GetPositionByValue(mCompareNum, ComparePosition);
     
     //int angledegree = IsWindmillAngleNum(compare_num, base_num);
     //int angledegree = MyAngle::GetAngleDegree(ComparePosition, BasePosition);
     //Alert("angledegree: "+angledegree);
     
    InsertBladeDegrees();
    
}

 void Windmill::InsertBladeDegrees(){
      
   // ====處理角線====
   InsertAngleBlades();
   //Debug::PrintArray("Blade Info: ",cursor);
   
   // ====處理十字線====
   InsertCrossBlades();
   
   //將指針歸還回中間
   cursor.SetCursorTo(cursor.GetCenterIdx());

 }
//---計算角線上葉片範圍---
 void Windmill::InsertAngleBlades(){
   double CenterValue = cursor.GetValueByIdx(cursor.GetCenterIdx());
   //Alert("CenterValue: "+CenterValue);
   double AngleNums[];
   GetAngleNums(RUN_BOTH, CenterValue,AngleNums);
   //Debug::PrintArray("center_value "+center_value+"'s anglenums",AngleNums, 0);
   for(int i = 0 ; i <ArraySize(AngleNums);i++){
      double value = AngleNums[i];
      int circlenum = cursor.GetCircleNumByValue(value);
      int bladeRange = circlenum%2==0?(circlenum/2)-1:((circlenum+1)/2)-1;
      int BasePosition[2];
      cursor.GetPositionByIdx(cursor.GetCenterIdx(), BasePosition);
      //Debug::PrintPosition(cursor,BasePosition);
      int ComparePosition[2];
      cursor.GetPositionByValue(value, ComparePosition);
      //Debug::PrintPosition(cursor,ComparePosition);
      int degree = MyAngle::GetDegree(ComparePosition,BasePosition);
      CursorValue* crValue = cursor.GetCursorValueByValue(value);
      //Alert("before cursorblade is: "+crValue.blade_degree);
      crValue.blade_degree = degree;
      //Alert(value+"'s circle num is: "+circlenum+", BladeRange is: "+bladeRange+", degree is: "+degree);
      switch(degree){
         case ANGLE_45:{
            //---往下處理X---
            cursor.SetCursorTo(ComparePosition);
            //Alert("set cursor to value: "+DoubleToStr(value, 0)+" ==>");
            //Debug::PrintPosition(cursor,ComparePosition);
            for(int i = 0; i < bladeRange;i++){
               cursor.Down();
               CursorValue* crValue = cursor.GetCursorValue();
               crValue.blade_degree = degree;
               //Alert("down value is: "+crValue.value);
            }
            //---往右處理Y---
            cursor.SetCursorTo(ComparePosition);
            //Alert("set cursor to value: "+DoubleToStr(value, 0)+" ==>");
            //Debug::PrintPosition(cursor,ComparePosition);
            for(int i = 0; i < bladeRange;i++){
               cursor.Right();
               CursorValue* crValue = cursor.GetCursorValue();
               crValue.blade_degree = degree;
               //Alert("Right value is: "+crValue.value);
            }
            break;
         }
         case ANGLE_135:{
            //---往下處理X---
            cursor.SetCursorTo(ComparePosition);
            //Alert("set cursor to value: "+DoubleToStr(value, 0)+" ==>");
            //Debug::PrintPosition(cursor,ComparePosition);
            for(int i = 0; i < bladeRange;i++){
               cursor.Down();
               CursorValue* crValue = cursor.GetCursorValue();
               crValue.blade_degree = degree;
               //Alert("down value is: "+crValue.value);
            }
            //---往左處理Y---
            cursor.SetCursorTo(ComparePosition);
            //Alert("set cursor to value: "+DoubleToStr(value, 0)+" ==>");
            //Debug::PrintPosition(cursor,ComparePosition);
            for(int i = 0; i < bladeRange;i++){
               cursor.Left();
               CursorValue* crValue = cursor.GetCursorValue();
               crValue.blade_degree = degree;
               //Alert("Left value is: "+crValue.value);
            }
         break;
         }
         case ANGLE_225:{
            //---往上處理X---
            cursor.SetCursorTo(ComparePosition);
            //Alert("set cursor to value: "+DoubleToStr(value, 0)+" ==>");
            //Debug::PrintPosition(cursor,ComparePosition);
            for(int i = 0; i < bladeRange;i++){
               cursor.Up();
               CursorValue* crValue = cursor.GetCursorValue();
               crValue.blade_degree = degree;
               //Alert("Up value is: "+crValue.value);
            }
            //---往左處理Y---
            cursor.SetCursorTo(ComparePosition);
            //Alert("set cursor to value: "+DoubleToStr(value, 0)+" ==>");
            //Debug::PrintPosition(cursor,ComparePosition);
            for(int i = 0; i < bladeRange;i++){
               cursor.Left();
               CursorValue* crValue = cursor.GetCursorValue();
               crValue.blade_degree = degree;
               //Alert("Left value is: "+crValue.value);
            }
            break;
         }
         case ANGLE_315:{
            //---往上處理X---
            cursor.SetCursorTo(ComparePosition);
            //Alert("set cursor to value: "+DoubleToStr(value, 0)+" ==>");
            //Debug::PrintPosition(cursor,ComparePosition);
            for(int i = 0; i < bladeRange;i++){
               cursor.Up();
               CursorValue* crValue = cursor.GetCursorValue();
               crValue.blade_degree = degree;
               //Alert("Up value is: "+crValue.value);
            }
            //---往右處理Y---
            cursor.SetCursorTo(ComparePosition);
            //Alert("set cursor to value: "+DoubleToStr(value, 0)+" ==>");
            //Debug::PrintPosition(cursor,ComparePosition);
            for(int i = 0; i < bladeRange;i++){
               cursor.Right();
               CursorValue* crValue = cursor.GetCursorValue();
               crValue.blade_degree = degree;
               //Alert("Right value is: "+crValue.value);
            }
            break;
         }
      }
    
    }
 }
//---計算十字線上的葉片範圍---
void Windmill::InsertCrossBlades(){
   double CenterValue = cursor.GetValueByIdx(cursor.GetCenterIdx());
   //Alert("CenterValue: "+CenterValue);
   double CrossNums[];
   GetCrossNums(RUN_BOTH, CenterValue, CrossNums);
   //Debug::PrintArray("center_value "+center_value+"'s crossnums",CrossNums, 0);
   for(int i = 0 ; i <ArraySize(CrossNums);i++){
      double value = CrossNums[i];
      int BasePosition[2];
      cursor.GetPositionByIdx(cursor.GetCenterIdx(), BasePosition);
      //Debug::PrintPosition(cursor,BasePosition);
      int ComparePosition[2];
      cursor.GetPositionByValue(value, ComparePosition);
      //Debug::PrintPosition(cursor,ComparePosition);
      int degree = MyAngle::GetDegree(ComparePosition,BasePosition);
      CursorValue* crValue = cursor.GetCursorValueByValue(value);
      crValue.blade_degree = degree;
      //Alert(value+"'s circle num is: "+circlenum+", BladeRange is: "+bladeRange+", degree is: "+degree);
      switch(degree){
         case ANGLE_0:{
            cursor.SetCursorTo(ComparePosition);
            //---往上處理X---
            while(cursor.Up()){
               CursorValue* crValue = cursor.GetCursorValue();
               if(crValue.blade_degree!=0)break;
               crValue.blade_degree = degree;    
            }
            //---往下處理X---
            cursor.SetCursorTo(ComparePosition);
            while(cursor.Down()){
               CursorValue* crValue = cursor.GetCursorValue();
               if(crValue.blade_degree!=0)break;
               crValue.blade_degree = degree;                  
            }
            break;
         }
         case ANGLE_90:{
            //---往左處理Y---
            cursor.SetCursorTo(ComparePosition);
            while(cursor.Left()){
               CursorValue* crValue = cursor.GetCursorValue();
               if(crValue.blade_degree!=0)break;
               crValue.blade_degree = degree;                  
            }
            //---往右處理Y---
            cursor.SetCursorTo(ComparePosition);
            while(cursor.Right()){
               CursorValue* crValue = cursor.GetCursorValue();
               if(crValue.blade_degree!=0)break;
               crValue.blade_degree = degree;                  
            }
         break;
         }
         case ANGLE_180:{
            //---往上處理X---
            cursor.SetCursorTo(ComparePosition);
            while(cursor.Up()){
               CursorValue* crValue = cursor.GetCursorValue();
               if(crValue.blade_degree!=0)break;
               crValue.blade_degree = degree;                  
            }
            //---往下處理X---
            cursor.SetCursorTo(ComparePosition);
            while(cursor.Down()){
               CursorValue* crValue = cursor.GetCursorValue();
               if(crValue.blade_degree!=0)break;
               crValue.blade_degree = degree;                  
            }
            break;
         }
         case ANGLE_270:{
            //---往右處理Y---
            cursor.SetCursorTo(ComparePosition);
            while(cursor.Right()){
               CursorValue* crValue = cursor.GetCursorValue();
               if(crValue.blade_degree!=0)break;
               crValue.blade_degree = degree;                  
            }
            //---往左處理Y---
            cursor.SetCursorTo(ComparePosition);
            while(cursor.Left()){
               CursorValue* crValue = cursor.GetCursorValue();
               if(crValue.blade_degree!=0)break;
               crValue.blade_degree = degree;                  
            }
            break;
         }
      }
    
    }
}