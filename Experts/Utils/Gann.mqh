//+------------------------------------------------------------------+
//|                                                         Gann.mqh |
//|                                                            Simon |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Simon"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "Cursor.mqh"
#include "MyMath.mqh"
#include "Debug.mqh"

Cursor cursor;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Gann
  {
private:
                    int NowInsertIdx;
                    double OriValues[];
                    void GenerateValues(double &values[], double begin, double step, int size);
                    void InsertValues(double &values[], int size, bool isCW);
                    void InsertValueLeftToRight(double &values[]);
                    void InsertValueBottomToTop(double &values[]);
                    void InsertValueRightToLeft(double &values[]);
                    void InsertValueTopToBottom(double &values[]);
                    bool IsCursorOnCenter();
                    
public:
                     Gann();
                    ~Gann();
                    void DrawSquare(double begin, double step, int size, bool isCW); //CW 順時針
                    void RunCycle(bool to_end, double begin_value, double &cycles[]);
                    void Run90(double begin_value, double &values[]);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Gann::Gann()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Gann::~Gann()
  {
  }
//+------------------------------------------------------------------+
Gann::DrawSquare(double begin, double step, int size, bool isCW)
{
     
   GenerateValues(OriValues, begin, step, size);
   InsertValues(OriValues, size, isCW); // run clockwise順時針 / counterclockwise逆時針
   
  
}
void Gann::GenerateValues(double &values[], double begin, double step, int size)
{
   int length = MathPow(((1+size)+size),2);// 總數=(size+1)+(size)的平方
   ArrayResize(values, length);
   
   for(int i = 0;i<ArraySize(values);i++){
      if(i==0){
         values[i]=begin;
      }else{
         values[i] = values[i-1]+step;
      }
  
   }
}
void Gann::InsertValues(double &values[], int size, bool isCW)
{
   // 開出一個空白江恩矩形的矩陣
   cursor.InitSquareArray(size);
 
 //=========開始將產生出來的值塞入江恩矩陣================
   int position[2];
   // 先將指標移至最後一筆
   int last = cursor.GetLastIdxOnChart(isCW);
   cursor.SetCursorTo(last);
   NowInsertIdx = ArraySize(values)-1;
   cursor.SetValue(values[NowInsertIdx]);
   
   // 再用迴圈將江恩值由外圍向內圍塞完
   if(isCW){ // 順時針
      
      do{
         InsertValueLeftToRight(values);
         InsertValueBottomToTop(values);
         InsertValueRightToLeft(values);
         InsertValueTopToBottom(values);
      }
      while(IsCursorOnCenter() == FALSE);
   }else{  //逆時針
      do{
         InsertValueRightToLeft(values);
         InsertValueBottomToTop(values);
         InsertValueLeftToRight(values);
         InsertValueTopToBottom(values);
      }
      while(IsCursorOnCenter() == FALSE);
   }
 
   
   cursor.PrintSquare();

}

void Gann::InsertValueLeftToRight(double &values[])
{  

 //Alert("InsertValueLeftToRight, Start From InsertIdx: "+NowInsertIdx);
    while(cursor.GetCursorIdx()!=cursor.GetCenterIdx() && cursor.Right())
    {
         if(cursor.HasValue()==FALSE)
         {
            cursor.SetValue(values[--NowInsertIdx]); 
         
            int positions[2];
            cursor.GetCursorPosition(positions);
            Alert("NowCursorIdx: ["+positions[0]+","+positions[1]+"], value: "+cursor.GetValueByIdx(cursor.GetCursorIdx()));
         }else{
            if(IsCursorOnCenter() == FALSE){
               cursor.Left();//因為已填值，因此將指針移回前一位置
            }
            break;
            
         }
         
    }
}

void Gann::InsertValueBottomToTop(double &values[])
{  
      //Alert("InsertValueBottomToTop, Start From InsertIdx: "+NowInsertIdx);
   
    while(cursor.GetCursorIdx()!=cursor.GetCenterIdx() && cursor.Up())
    {
         if(cursor.HasValue()==FALSE)
         {
             cursor.SetValue(values[--NowInsertIdx]); 
         
             int positions[2];
             cursor.GetCursorPosition(positions);
             Alert("NowCursorIdx: ["+positions[0]+","+positions[1]+"], value: "+cursor.GetValueByIdx(cursor.GetCursorIdx()));
         }else{
               if(IsCursorOnCenter() == FALSE){
                  cursor.Down();//因為已填值，因此將指針移回前一位置
               }
               break;
         }
    }
}

void Gann::InsertValueRightToLeft(double &values[])
{  
      //Alert("InsertValueRightToLeft, Start From InsertIdx: "+NowInsertIdx);
      while(cursor.GetCursorIdx()!=cursor.GetCenterIdx() && cursor.Left())
       {
            if(cursor.HasValue()==FALSE)
            {
               cursor.SetValue(values[--NowInsertIdx]); 
            
               int positions[2];
               cursor.GetCursorPosition(positions);
               Alert("NowCursorIdx: ["+positions[0]+","+positions[1]+"], value: "+cursor.GetValueByIdx(cursor.GetCursorIdx()));     
            }else{
               if(IsCursorOnCenter() == FALSE){
                  cursor.Right();//因為已填值，因此將指針移回前一位置
               }
               break;
            }
            
       }
}

void Gann::InsertValueTopToBottom(double &values[])
{  
    //Alert("InsertValueTopToBottom, Start From InsertIdx: "+NowInsertIdx);
       while(cursor.GetCursorIdx()!=cursor.GetCenterIdx() && cursor.Down())
       {
            if(cursor.HasValue()==FALSE){
               cursor.SetValue(values[--NowInsertIdx]); 
            
               int positions[2];
               cursor.GetCursorPosition(positions);
               Alert("NowCursorIdx: ["+positions[0]+","+positions[1]+"], value: "+cursor.GetValueByIdx(cursor.GetCursorIdx()));  
            }else{
               if(IsCursorOnCenter() == FALSE){
                  cursor.Up();//因為已填值，因此將指針移回前一位置
               }
               break;
            }
         
       }
}

bool Gann::IsCursorOnCenter(void)
{
   return cursor.GetCursorIdx() == cursor.GetCenterIdx();
}

void Gann::RunCycle(bool to_end, double begin_value, double &cycles[])
{
   double found = MyMath::FindClosest(OriValues, begin_value);
   int found_idx = ArrayBsearch(OriValues, found, WHOLE_ARRAY, 0, MODE_ASCEND); 
   Alert("found value: "+found+", found_idx: "+found_idx);
   
   if(to_end){
      ArrayCopy(cycles, OriValues, 0, found_idx, WHOLE_ARRAY);
   }else{
      
      double temp[];
      ArrayCopy(temp, OriValues, 0, 0, found_idx+1);
      MyMath::ReverseArray(temp, cycles);
      Debug::PrintArray(cycles);
   }

}

void Gann::Run90(double begin_value, double &values[])
{
   // 1.在整份圖表上，找出相近值當臨活基數
   double beginValue = MyMath::FindClosest(OriValues, begin_value);
   Alert("beginValue is: "+beginValue);
   
   int position[2];
   cursor.GetPositionByValue(beginValue, position);
   Debug::PrintPosition(cursor, position);
   
   //double array[];
   //cursor.GetSquareArray(array);
   //Debug::.PrintArray(array);
   
   ArrayCopy(values, position, 0, 0, WHOLE_ARRAY);
}