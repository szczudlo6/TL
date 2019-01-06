//+------------------------------------------------------------------+
//|                                          Helper Function library |
//|                                            Make your trade SMART |
//|                                     by forexallday.wordpress.com |
//+------------------------------------------------------------------+
#property library
#property copyright "Helper Function"
#property link      "forexallday.wordpress.com"
#property version   "1.00"
#property strict

#include <clsStruct.mqh>
string CreateMagicNumber() export
{
   datetime ct = TimeCurrent();
   string magicnumber = StringConcatenate(AddZero(TimeMonth(ct)),AddZero(TimeDay(ct)),
                                          AddZero(TimeHour(ct)),AddZero(TimeMinute(ct)),AddZero(TimeSeconds(ct)));   
   return(magicnumber);
}

string AddZero(int time)
{
   string advisetime=IntegerToString(time);
   
   if(StringLen(advisetime)==1)
   {
      advisetime= "0"+advisetime;
   }
   
   return (advisetime);
}

void QuickSortArray1Dimension5Struct(strGlobal &arr[], int StartPos, int EndPos, bool SmallestToLarges) export
{
   double  v=arr[(StartPos+EndPos)/2].price;
   int i,j;
   double x0,x1,x3;
   datetime x2;
   int x4;
   
   i=StartPos;
   j=EndPos;
   do{
      if (SmallestToLarges)
      {
         while (arr[i].price<v) i++;
         while (arr[j].price>v) j--;
      }
      else
      {
         while (arr[i].price>v) i++;
         while (arr[j].price<v) j--;
      }
      if (i<=j)
      {
         x0=arr[i].price;
         x1=arr[i].a;
         x2=arr[i].xTimeDef;
         x3=arr[i].b;
         x4=arr[i].magicnumber;
         
         arr[i].price=arr[j].price;
         arr[i].a=arr[j].a;
         arr[i].xTimeDef=arr[j].xTimeDef;
         arr[i].b=arr[j].b;
         arr[i].magicnumber=arr[j].magicnumber;
         
         arr[j].price=x0;
         arr[j].a=x1;
         arr[j].xTimeDef=x2;
         arr[j].b=x3;
         arr[j].magicnumber=x4;
         
         i++; j--;
      }      
      }while (i<=j);
   
   if (j>StartPos) QuickSortArray1Dimension5Struct(arr,StartPos,j,SmallestToLarges);
   if (i<EndPos) QuickSortArray1Dimension5Struct(arr,i,EndPos,SmallestToLarges);
   
}

void QuickSortArray1Dimension(double &arr[], int StartPos, int EndPos, bool SmallestToLarges) export
{   
   double  v = arr[(StartPos+EndPos)/2];
   int i,j;
   double x;
   i=StartPos;
   j=EndPos;
   do{
      if (SmallestToLarges)
      {
         while (arr[i]<v) i++;
         while (arr[j]>v) j--;
      }
      else
      {
         while (arr[i]>v) i++;
         while (arr[j]<v) j--;
      }
      if (i<=j)
      {
         x=arr[i];
         arr[i]=arr[j];
         arr[j]=x;
         i++; j--;
      }      
      }while (i<=j);
   
   if (j>StartPos) QuickSortArray1Dimension(arr,StartPos,j,SmallestToLarges);
   if (i<EndPos) QuickSortArray1Dimension(arr,i,EndPos,SmallestToLarges);
}

void QuickSortArray2Dimension(double &arr[][], int StartPos, int EndPos, bool SmallestToLarges) export
{    
   double v = arr[(StartPos+EndPos)/2][0];
   int i,j;
   double x;
   i=StartPos;
   j=EndPos;
   
   do{
      if (SmallestToLarges)
      {
         while (arr[i][0]<v) i++;
         while (arr[j][0]>v) j--;
      }
      else
      {
         while (arr[i][0]>v) i++;
         while (arr[j][0]<v) j--;
      }
      if (i<=j)
      {
         x=arr[i][0];
         arr[i][0]=arr[j][0];
         arr[j][0]=x;
         i++; j--;
      }      
      }while (i<=j);
   
   
      if (j>StartPos) QuickSortArray2Dimension(arr,StartPos,j,SmallestToLarges);
      if (i<EndPos)  QuickSortArray2Dimension(arr,i,EndPos,SmallestToLarges);
  
}