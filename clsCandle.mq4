//+------------------------------------------------------------------+
//|                                                   Candle library |
//|                                            Make your trade SMART |
//|                                     by forexallday.wordpress.com |
//+------------------------------------------------------------------+
#property library
#property copyright "Candle library"
#property link      "https://forexallday.wordpress.com"
#property version   "1.00"
#property strict

datetime arrTimeCandle[1];  

void initTimeCandle(int _CandleNumber) export {arrTimeCandle[0] = _CandleNumber;}
bool CheckCurrentCandle(int Candle) export
{       
   if (Time[Candle] != arrTimeCandle[0])
   {    
      Print("New Candle");
      arrTimeCandle[0] = Time[Candle];
      return(true);
   }   
   return(false);      
}
