//+------------------------------------------------------------------+
//|                                             TrendLineTrade ROBOT |
//|                                            Make your trade SMART |
//|                                     by forexallday.wordpress.com |
//+------------------------------------------------------------------+
#property copyright "TrendLineTrade ROBOT"
#property link      "https://forexallday.wordpress.com"
#property version   "1.00"
#property strict                   

#include <clsStruct.mqh>
#include <hTrendLine.mqh>
#include <hCandle.mqh>
#include <hOrder.mqh>
#include <hFile.mqh>

extern double MoneyRisk = 2.0;
extern double StopLossLine = 100;
extern double MinTakeProfit = 100;

extern int CandleNumber = 1;

extern int TrendLinePeriod = 35;
extern int BarsLimit = 200;
extern int TrendLinesNum = 5;
   
extern double PriceDeviation = 50;

int OpenedOrders=0;
int MaxOpenPosition = 1;
string OrderFileName;

int OnInit()
  { 
   strGlobal arr[];
   OrderFileName = "TL_ROBOT_"+(string)AccountNumber() + "_"+Symbol()+"_"+(string)Period()+"_Orders.txt";
   
   int CheckOpenPosition=0;
   Comment("Account Balance: " + (string)NormalizeDouble(AccountBalance(),2));
   
   //init
   initTrendLine(TrendLinePeriod,BarsLimit,TrendLinesNum,PriceDeviation,CandleNumber,StopLossLine,MinTakeProfit);
   initTimeCandle(CandleNumber);
   initOrder (MoneyRisk,MaxOpenPosition);   
   
   ReinitFile();
   //get open position
   CheckOpenPosition=GetOpenOrder();
   
   if(CheckOpenPosition > OpenedOrders)
      OpenedOrders=CheckOpenPosition;
   
   //set trendline
   ReinitTrendLine(OpenedOrders);
   
   //copy magic number array
   GetOrderArrayFromFile(arr);
   SetOrderArrayFromFile(arr);
                              
   return(INIT_SUCCEEDED);
   }
 
void OnTick()
{    
   if(OpenedOrders==0 && CheckCurrentCandle(CandleNumber))
   {     
      ReinitTrendLine(OpenedOrders);
      if(GetValueByShiftInFuncLine())       
         if(OpenOrder(OpenedOrders,GetOrder(),0,GetStopLoss(),0,GetMagicNumber()))
         {
            //add magicnumber to file
            initFile(OrderFileName);   
            if (!AddMagicNumber(GetMagicNumber()))
               Print("Cannot add order to file");
               
            OpenedOrders++;            
         }     
  }   
   else if (OpenedOrders>0)
      CheckCurrentOrders();
}
  
void CheckCurrentOrders()
{  
   int magicnumber=0;
   int b=false;
   
   for (int i=OrdersTotal()-1; i >= 0 ;i--)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
         magicnumber = OrderMagicNumber();
         if(CheckMagicNumber(magicnumber))
         {
            b=true;
            if(CheckPriceIsInTrendLine(magicnumber,OrderType(),OrderOpenPrice()))
               if(CloseOrderByMagicNumber(magicnumber))
               {
                  OpenedOrders--;
                  ReinitFile();
               }
         } 
      }
   }
   
   //if order was opened but not exist in server
   if (!b)
      OpenedOrders=0;
}