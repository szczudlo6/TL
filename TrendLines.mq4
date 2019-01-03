//+------------------------------------------------------------------+
//|                                       Ind-WSO+WRO+Trend Line.mq4 |
//|                                      http://www.expert-mt4.nm.ru |
//|                                                                  |
//|                                                    TrendLine.mq4 |
//|                                                   raff1410@o2.pl |
//+------------------------------------------------------------------+
#property indicator_chart_window

//---- input parameters
extern int    TPeriod       = 18;
extern int    TLimit        = 350;

extern bool   AutoAdjust    = true;
extern int    AutoTimeframe = 60;

extern bool   HorizontalLines = false;

extern color  Support       = DeepSkyBlue;
extern color  Resistance    = Red;

extern bool   SoundAlert    = false;
extern int    AlertPipRange = 10;
extern string AlertWav      = "alert.wav";
//---- 
int nPeriod, Limit, cnt, i, NumOfObj, nCurBar = 0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//----
   nPeriod=TPeriod;
   Limit=TLimit;
   if (Period()<AutoTimeframe)
   {
      int AutoFactor = AutoTimeframe/Period();
      nPeriod=TPeriod*AutoFactor;
      Limit=TLimit*AutoFactor;
   }
   NumOfObj=10;
   if (HorizontalLines) NumOfObj=24;
   color SetColor=Support;
   int   SetObject = OBJ_TREND;
   for(cnt=1; cnt<=NumOfObj; cnt++)
   {
      if (cnt>5) SetColor=Resistance;
      if (cnt>10) {SetColor=Support; SetObject=OBJ_HLINE;}
      if (cnt>16) SetColor=Resistance;
      ObjectCreate("TrendLine_"+cnt,SetObject,0,0,0,0,0);
      ObjectSet("TrendLine_"+cnt,OBJPROP_COLOR,SetColor);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- TODO: add your code here
   for(cnt=1; cnt<=24; cnt++)
      {
      ObjectDelete("TrendLine_"+cnt);
      }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
//---- TODO: add your code here
   double r1,r2,r3,r4,r5,r6;
   int rt1,rt2,rt3,rt4,rt5,rt6;
   double s1,s2,s3,s4,s5,s6;
   int st1,st2,st3,st4,st5,st6;

   if(Bars<Limit) Limit=Bars-nPeriod;
   for(nCurBar=Limit; nCurBar>0; nCurBar--)
   {
     if(Low[nCurBar+(nPeriod-1)/2] == Low[Lowest(NULL,0,MODE_LOW,nPeriod,nCurBar)])
     {
       s6=s5; s5=s4; s4=s3; s3=s2; s2=s1; s1=Low[nCurBar+(nPeriod-1)/2];
       st6=st5; st5=st4; st4=st3; st3=st2; st2=st1; st1=nCurBar+(nPeriod-1)/2;
     }
     if(High[nCurBar+(nPeriod-1)/2] == High[Highest(NULL,0,MODE_HIGH,nPeriod,nCurBar)])
     {
       r6=r5; r5=r4; r4=r3; r3=r2; r2=r1; r1=High[nCurBar+(nPeriod-1)/2];
       rt6=rt5; rt5=rt4; rt4=rt3; rt3=rt2; rt2=rt1; rt1=nCurBar+(nPeriod-1)/2;
     }
   }
//---- Move Object
   ObjectMove("TrendLine_1",1,Time[st1],s1);
   ObjectMove("TrendLine_1",0,Time[st2],s2);
   ObjectMove("TrendLine_2",1,Time[st2],s2);
   ObjectMove("TrendLine_2",0,Time[st3],s3);
   ObjectMove("TrendLine_3",1,Time[st3],s3);
   ObjectMove("TrendLine_3",0,Time[st4],s4);
   ObjectMove("TrendLine_4",1,Time[st4],s4);
   ObjectMove("TrendLine_4",0,Time[st5],s5);
   ObjectMove("TrendLine_5",1,Time[st5],s5);    
   ObjectMove("TrendLine_5",0,Time[st6],s6);
   ObjectMove("TrendLine_6",1,Time[rt1],r1);
   ObjectMove("TrendLine_6",0,Time[rt2],r2);
   ObjectMove("TrendLine_7",1,Time[rt2],r2);
   ObjectMove("TrendLine_7",0,Time[rt3],r3);
   ObjectMove("TrendLine_8",1,Time[rt3],r3);
   ObjectMove("TrendLine_8",0,Time[rt4],r4);
   ObjectMove("TrendLine_9",1,Time[rt4],r4);
   ObjectMove("TrendLine_9",0,Time[rt5],r5);
   ObjectMove("TrendLine_10",1,Time[rt5],r5);
   ObjectMove("TrendLine_10",0,Time[rt6],r6);
   if (HorizontalLines)
   {
      ObjectMove("TrendLine_11",0,Time[st1],s1);
      ObjectMove("TrendLine_12",0,Time[st2],s2);
      ObjectMove("TrendLine_13",0,Time[st3],s3);
      ObjectMove("TrendLine_14",0,Time[st4],s4);
      ObjectMove("TrendLine_15",0,Time[st5],s5);
      ObjectMove("TrendLine_16",0,Time[st6],s6);
      ObjectMove("TrendLine_17",0,Time[rt1],r1);
      ObjectMove("TrendLine_18",0,Time[rt2],r2);
      ObjectMove("TrendLine_19",0,Time[rt3],r3);
      ObjectMove("TrendLine_20",0,Time[rt4],r4);
      ObjectMove("TrendLine_21",0,Time[rt5],r5);
      ObjectMove("TrendLine_22",0,Time[rt6],r6);
   }
//----
   double val;
   bool soundOn=true;
   for(cnt=1; cnt<=NumOfObj; cnt++)
    {
      ObjectSet("TrendLine_"+cnt,OBJPROP_WIDTH,1);
      val=ObjectGetValueByShift("TrendLine_"+cnt, 0);
      if (cnt>10) val=ObjectGet("TrendLine_"+cnt, OBJPROP_PRICE1);
      if(Bid-AlertPipRange*Point <= val && Bid+AlertPipRange*Point >= val)
      {
         ObjectSet("TrendLine_"+cnt,OBJPROP_WIDTH,2);
         if (SoundAlert && soundOn) {PlaySound(AlertWav); soundOn=false;}
      }
    }
//----
   return(0);
  }
//--------------------------------------------------+  