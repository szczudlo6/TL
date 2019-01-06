//+------------------------------------------------------------------+
//|                                                       Order head |
//|                                            Make your trade SMART |
//|                                     by forexallday.wordpress.com |
//+------------------------------------------------------------------+
#include <clsStruct.mqh>
#import "clsOrder.ex4"
   void initOrder(double _moneyRisk, int _maxOpenPosition);
   void SetOrderArrayFromFile(strGlobal &arrFile[]);
   void SetArrayOrderList(int _magicnumber);
   void Trailing(int _magicnumber, double _trailingstop);
   bool OpenOrder(int OpenedOrder, int order, double lotsize, double stoploss,double takeprofit, int _magicnumber);
   bool CloseOrderByMagicNumber(int magicnumber);
   bool CheckMagicNumber(int _magicNumber);
#import