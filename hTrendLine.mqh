//+------------------------------------------------------------------+
//|                                                   TrendLine head |
//|                                            Make your trade SMART |
//|                                     by forexallday.wordpress.com |
//+------------------------------------------------------------------+
#include <clsStruct.mqh>
#import "clsTrendLine.ex4"
   void initTrendLine(int _nPeriod, int _Limit, int _NumOfTrendLine, double _PriceDeviation, 
                     int _CandleNumber, double _StopLossLine, double _minTakeProfit);   
   void SetNearestTrendLineArray();
   void ReinitTrendLine(int _OpenedOrders);
   void LoopArrayToMagicNumber(strGlobal &arr[], int &arrB[]);
   bool LoopTrendLine(strGlobal &arr[],double price, int arrsize, int magicnumber,int ordertype, double OpenOrderPrice);
   bool CheckPriceIsInTrendLine(int magicnumber, int ordertype, double OpenOrderPrice);   
   bool GetValueByShiftInFuncLine();
   int GetOrder();
   int GetMagicNumber();
   double GetStopLoss();
#import