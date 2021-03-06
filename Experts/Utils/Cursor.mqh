//+------------------------------------------------------------------+
//|                                                       Cursor.mqh |
//|                                                            Simon |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Simon"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "MyMath.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Cursor
  {
private:
                    int GetCenter();
                    double SquareArray[];
                    int NowIdx;
                    bool IsOutOfEdge(int x, int y);
                    bool MoveX(int diff);
                    bool MoveY(int diff);
                    int GetEdgeWidth();
public:
                     Cursor();
                    ~Cursor();
                    void InitSquareArray(int chartSize);
                    bool Up();
                    bool Down();
                    bool Left();
                    bool Right();
                    void SetValueByPosition(int x, int y, double value);
                    void SetValueByIdx(int idx, double value);
                    void SetValue(double value);
                    void SetCenterValue(double value);
                    int GetCenterIdx();
                    void GetCenterPosition(int &position[]);
                    int GetLastIdxOnChart(bool isCW);
                    int GetIdxByPosition(int x, int y);
                    int GetIdxByValue(double value);
                    void GetPositionByIdx(int idx,int &position[]);
                    void GetPositionByValue(double value,int &position[]);
                    double GetValueByPosition(int x, int y);
                    double GetValueByIdx(int idx);
                    void SetCursorTo(int x, int y);
                    void SetCursorTo(int idx);
                    void SetCursorByValue(double value);

                    int GetCursorIdx();
                    void GetCursorPosition(int &position[]);
                    bool HasValue(int idx);
                    bool HasValue();
                    void GetSquareArray(double &array[]);
                  
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Cursor::Cursor()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Cursor::~Cursor()
  {
  }
//+------------------------------------------------------------------+
void Cursor::InitSquareArray(int chartSize)
{
      int SquareWidth = chartSize*2 +1; // 單邊長 = size*2 + 1
      double EmptySquares[];
      ArrayResize(EmptySquares, MathPow(SquareWidth, 2)); //開出一個等邊正方形
      ArrayInitialize(EmptySquares, EMPTY_VALUE);
      ArrayCopy(SquareArray, EmptySquares, 0, 0, WHOLE_ARRAY);
}
int Cursor::GetEdgeWidth(void)
{
   int size = ArraySize(SquareArray);
   double width = MathSqrt(size);
   return NormalizeDouble(width, 0);
}
bool Cursor::IsOutOfEdge(int x, int y)
{
   bool isOutOfEdge = false;
   
   double width = GetEdgeWidth();
   
   if(x<0 | x>=width | y<0 | y>=width)
   {
      isOutOfEdge = true;
   }
   //Alert("IsOutOfEge: "+isOutOfEdge);
   
   return isOutOfEdge;
}

bool Cursor::MoveX(int diff)
{
     bool state = false;
     
     int oldposition[2];
     GetCursorPosition(oldposition);
     int oldX = oldposition[0];
     int oldY = oldposition[1];
  
     int newposition[2];
     newposition[0]=oldX+diff;
     newposition[1]=oldY;
     int newX = newposition[0];
     int newY = newposition[1];
     
     //Alert("newX: "+newX+", newY: "+newY);
     
     if(IsOutOfEdge(newX, newY)){
         //Alert("IsOutOfEdge");
         return state;
     }else{
         SetCursorTo(newX, newY);
         //Alert("SerCursor to ["+newX+","+newY+"] success");
         state = true;
     }
     return state;
        
}
bool Cursor::MoveY(int diff)
{
     bool state = false;
     
     int oldposition[2];
     GetCursorPosition(oldposition);
     int oldX = oldposition[0];
     int oldY = oldposition[1];
  
     int newposition[2];
     newposition[0]=oldX;
     newposition[1]=oldY+diff;
     int newX = newposition[0];
     int newY = newposition[1];
     
     //Alert("newX: "+newX+", newY: "+newY);
     
     if(IsOutOfEdge(newX, newY)){
         return state;
     }else{
         SetCursorTo(newX, newY);
         state = true;
     }
     return state;
        
}
bool Cursor::Up()
  {
     return MoveX(-1);
  }
  
bool Cursor::Down()
  {
     return MoveX(1);
  }  
  
  bool Cursor::Left()
  {
      
     return MoveY(-1);
  }
  
bool Cursor::Right()
  {
      bool canMove = MoveY(1);
     //Alert("CursorIdx: "+GetCursorIdx()+" Can Move: "+canMove);
     
     return canMove;
  }  
  
void Cursor::SetValueByPosition(int x, int y, double value)
  {
      int idx = GetIdxByPosition(x, y);
      SquareArray[idx] = value;
  }

void Cursor::SetValueByIdx(int idx, double value){
   SquareArray[idx] = value;
}
void Cursor::SetValue(double value)
{
   SetValueByIdx(GetCursorIdx(), value);
}
void SetCenterValue(double value)
{
}

int Cursor::GetCenter()
{
    double width = GetEdgeWidth();
    double center = width/2;
    return center;
}

int Cursor::GetCenterIdx()
  {
   int center = GetCenter();
   return GetIdxByPosition(center, center);
  
  }
  
void Cursor::GetCenterPosition(int &position[])
{
   position[0]=GetCenter();
   position[1]=GetCenter();
}
int Cursor::GetLastIdxOnChart(bool isCW)
{
   int idx = -1;
   double width = GetEdgeWidth();
   if(isCW){
       idx = GetIdxByPosition(width-1, 0);
   }else{
       idx = GetIdxByPosition(width-1, width-1);
   }
   return idx;
}

int Cursor::GetIdxByPosition(int x, int y)
{
    int idx = -1;

    double width = GetEdgeWidth();
    //Alert("GetIdx::Width: "+width);
    if(x>=width | y >=width)
    return idx;
    
    idx = x*width + y;
    return idx;
}

int Cursor::GetIdxByValue(double value)
{
   //value = 21;
   //Alert("want to find value: "+value);
   
   // 找出所在位置
   int found_idx = MyMath::FindIdxByValue(SquareArray, value);
   //int found_idx = ArrayBsearch(SquareArray, value, WHOLE_ARRAY, 0, MODE_ASCEND); // 要經過排序才能使用
   //Alert("found idx is: "+found_idx);
   return found_idx;
}

void Cursor::GetPositionByIdx(int idx, int& position[])
{
   int x = -1;
   int y = -1;

   int size = ArraySize(SquareArray);
   double width = MathSqrt(size);
   
   if(idx>=size)
   {
      position[0]=x;
      position[1]=y;
      return;
   }
   
   x = idx/width; // ex: (6/7)=0;   (12/7)=1
   y = NormalizeDouble(MathMod(idx,width), 0); // ex: (6%7)=6;   (12%7)=5
   
   position[0]=x;
   position[1]=y;   
}

void Cursor::GetPositionByValue(double value,int &position[])
{
   int idx = GetIdxByValue(value);
   GetPositionByIdx(idx, position);
}

double Cursor::GetValueByPosition(int x, int y)
{
    int idx = -1;
   
    double width = GetEdgeWidth();
    //Alert("GetIdx::Width: "+width);
    if(x >= width | y >= width)
    return idx;
    
    idx = x*width + y;
    
    return GetValueByIdx(GetIdxByPosition(x, y));
}

double Cursor::GetValueByIdx(int idx)
{
   return SquareArray[idx];
}
void Cursor::SetCursorTo(int x,int y)
{
   NowIdx = GetIdxByPosition(x, y);
}

void Cursor::SetCursorTo(int idx)
{
   NowIdx = idx;

}

void Cursor::SetCursorByValue(double value)
{
   double beginValue = MyMath::FindClosest(SquareArray, value);
   //Alert("beginValue is: "+beginValue);
   int found_idx = GetIdxByValue(beginValue);
   //Alert("found_idx is: "+found_idx);
   SetCursorTo(found_idx);

   
}

int Cursor::GetCursorIdx(void)
{
   return NowIdx;
}

void Cursor::GetCursorPosition(int &position[])
{
   GetPositionByIdx(GetCursorIdx(), position);
}

bool Cursor::HasValue(int idx)
{
   double value = GetValueByIdx(idx);
   //Alert("value: "+value);
   return value != EMPTY_VALUE;
}

bool Cursor::HasValue()
{
   double value = GetValueByIdx(GetCursorIdx());
   //Alert("value: "+value);
   return value != EMPTY_VALUE;
}

void Cursor::GetSquareArray(double &array[])
{
   ArrayCopy(array, SquareArray, 0, 0, WHOLE_ARRAY);
}