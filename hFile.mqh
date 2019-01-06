//+------------------------------------------------------------------+
//|                                                        File head |
//|                                            Make your trade SMART |
//|                                     by forexallday.wordpress.com |
//+------------------------------------------------------------------+
#include <clsStruct.mqh>
#import "clsFile.ex4"
   bool Read1DimensionArrayFromFile(strGlobal &arr[]);
   bool Write1DimensionArrayToFile(strGlobal &arr[]);                        
   bool AddMagicNumber(int _magicnumber);
   void initFile(string _filename);
   void ReinitFile(string OrderFileName);
   void Copy1DimensionArrayToArray(strGlobal &arrSource[], strGlobal &arrDestine[]);
   void GetOrderArrayFromFile(strGlobal &arrFile[]);   
   int GetOpenOrder();
#import