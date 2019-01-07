//+------------------------------------------------------------------+
//|                                                    Order library |
//|                                            Make your trade SMART |
//|                                     by forexallday.wordpress.com |
//+------------------------------------------------------------------+
#property library
#property copyright "Order library"
#property link      "https://forexallday.wordpress.com"
#property version   "1.00"
#property strict

#include <clsStruct.mqh>
                 
strGlobal arrMagicNumberList[];
int maxOpenPosition;
double moneyRisk;

void initOrder(double _moneyRisk, int _maxOpenPosition) export
{
   moneyRisk=_moneyRisk;
   maxOpenPosition=_maxOpenPosition;
}

void SetOrderArrayFromFile(strGlobal &arrFile[]) export 
{
   ArrayCopy(arrMagicNumberList,arrFile);
}

double GetLotFromMoneyRisk(double _MoneyRiskPrct, double StopLoss) export
{
   double MoneyRiskValue = AccountBalance() * (_MoneyRiskPrct/100);
   double nTickValue=MarketInfo(Symbol(),MODE_TICKVALUE);
   double LotSize =NormalizeDouble(MoneyRiskValue/ (StopLoss * nTickValue),2);
   
   double maxlot=AccountFreeMargin()/MarketInfo(Symbol(),MODE_MARGINREQUIRED);
   
   if (LotSize == 0.0) 
      LotSize = 0.01;
   else if (LotSize > maxlot)
      LotSize = maxlot;
      
   return (LotSize);
}

void SetArrayOrderList(int _magicnumber) export
{
   int arrsize = ArraySize(arrMagicNumberList);
   ArrayResize(arrMagicNumberList,arrsize+1);   
   arrMagicNumberList[arrsize].magicnumber= _magicnumber;
}

bool OpenOrder(int OpenedOrder, int order, double lotsize, double stoploss,double takeprofit, int _magicnumber) export
{   
   switch((int)lotsize)
   {
      case 0: lotsize = GetLotFromMoneyRisk(moneyRisk,stoploss);
   }
     
  if (OpenedOrder < maxOpenPosition)
   {  
      if (order == 1)
      {  
         if (takeprofit!=0) takeprofit = Bid - (takeprofit* Point);
            if(OrderSend(Symbol(),order,lotsize,Bid,3,NormalizeDouble(Bid+(stoploss*Point),Digits),takeprofit,NULL,_magicnumber,0,clrGreen))         
               {
                  SetArrayOrderList(_magicnumber);
                  Print("Short transaction opened");
                  return (true);  
               }     
            else
               Print("Cannot open short transaction.");
      }
      else if (order == 0)
      {  
         if (takeprofit!=0) takeprofit = Ask + (takeprofit * Point);
            if(OrderSend(Symbol(),order,lotsize,Ask,3,NormalizeDouble(Ask - (stoploss * Point),Digits) ,takeprofit,NULL,_magicnumber,0,clrGreen))
               {
                  SetArrayOrderList(_magicnumber);
                  Print("Long transaction opened");  
                  return (true);                  
               }
            else
               Print("Cannot open long transaction.");      
      }
   }
   return (false);
}
bool CloseOrderByMagicNumber(int magicnumber) export
{
   for (int i=OrdersTotal()-1; i >= 0 ;i--)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         if(OrderMagicNumber() == magicnumber)
            {
               if(OrderType()==OP_BUY)
                  if(!OrderClose(OrderTicket(),OrderLots(),Bid,3))
                     return(false);
               else if(OrderType()==OP_SELL)   
                  if(!OrderClose(OrderTicket(),OrderLots(),Ask,3))
                     return(false);
                  
               return(true);
            }       
   }   
   return(false);
}
bool CheckMagicNumber(int _magicNumber) export
{
   int arrsize = ArraySize(arrMagicNumberList);
   
   for (int i=0; i<=arrsize-1; i++)
   {
      if (arrMagicNumberList[i].magicnumber==_magicNumber)
         return(true);
   }   
   return(false);
}

void Trailing(int _magicnumber, double _trailingstop) export
{
   if(_trailingstop>0)
      for(int i=OrdersTotal()-1; i >= 0 ;i--)
      {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
            if(OrderMagicNumber() == _magicnumber) 
               if(OrderType()==OP_BUY) 
                  if(Bid-OrderOpenPrice()>Point*_trailingstop)
                     if(OrderStopLoss()<Bid-(Point*_trailingstop)) 
                        if(!OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Bid-(Point * _trailingstop),Digits),OrderTakeProfit(),0))
                           Print("Error in OrderModify. Error code=",GetLastError()); 
               else if(OrderType()==OP_SELL) 
                  if(Ask-OrderOpenPrice()<Point*_trailingstop)
                     if(OrderStopLoss()>Ask+(Point*_trailingstop))
                        if(!OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Ask+(Point * _trailingstop),Digits),OrderTakeProfit(),0))
                           Print("Error in OrderModify. Error code=",GetLastError()); 
       }
}
  
