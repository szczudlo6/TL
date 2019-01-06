//+------------------------------------------------------------------+
//|                                                     File library |
//|                                            Make your trade SMART |
//|                                     by forexallday.wordpress.com |
//+------------------------------------------------------------------+
#property library
#property copyright "File library"
#property link      "https://forexallday.wordpress.com"
#property version   "1.00"
#property strict

#include <clsStruct.mqh>
      
int fileOpenStatus;
int OpenOrder;   
string FileName;
strGlobal arrFromFile[];                  

void initFile(string _filename) export
{
   FileName =_filename;
}

void ReinitFile(string OrderFileName) export
{ 
   initFile(OrderFileName);
   if(Read1DimensionArrayFromFile(arrFromFile))
      if(!CompareCurrentOrderToFile())
         FileDelete(FileName);         
}
 
void GetOrderArrayFromFile(strGlobal &arrFile[]) export
{
   Copy1DimensionArrayToArray(arrFromFile,arrFile);
}                     
int GetOpenOrder() export
{
   return (OpenOrder);
}
                  
bool AddMagicNumber(int _magicnumber) export
{
   if(Read1DimensionArrayFromFile(arrFromFile))
      if(AddMagicNumberToArray(_magicnumber))   
         if(AddMagicNumberToFile(_magicnumber))
            return(true);
   
   return(false);
}
bool AddMagicNumberToFile(int _magicnumber)
{
   bool b= false;
   if(Write1DimensionArrayToFile(arrFromFile))
      b=true;
   
   return (b);
}

bool AddMagicNumberToArray(int _magicnumber)
{
   int arrsize = ArraySize(arrFromFile);
   
   for (int i=0; i<=arrsize-1;i++)
   {
      if(arrFromFile[i].magicnumber==_magicnumber)
         return(false);
   }
   
   ArrayResize(arrFromFile,arrsize+1);
   arrFromFile[arrsize].magicnumber=_magicnumber;
   
   return(true);
}

bool CompareCurrentOrderToFile()
{
   strGlobal arr[];
   int j=0;
   int arrsize;
   int arrsizeMN = ArraySize(arrFromFile);
   bool b = false;
   
   for (int h=0; h<=arrsizeMN-1; h++)
   {
      for (int i=OrdersTotal()-1; i>=0; i--)
      {
         if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
            if(arrFromFile[h].magicnumber == OrderMagicNumber())
            {
               arrsize = ArraySize(arr);
               ArrayResize(arr,arrsize+1);
               arr[j].magicnumber=arrFromFile[h].magicnumber;
               j++;
               break;
            }
      }
   }
   
   //check if is empty
   if (ArraySize(arr)<=0)      
      return(b);
   else
   {  
      if(Write1DimensionArrayToFile(arr))
      {
         Copy1DimensionArrayToArray(arr,arrFromFile);
         OpenOrder=ArraySize(arrFromFile);
         b=true;
      }         
      return(b);
   }

}
void CloseFileArray()
{
   FileClose(fileOpenStatus);
}
bool OpenFileArray()
{ 
   fileOpenStatus = FileOpen(FileName,FILE_BIN|FILE_READ|FILE_WRITE);

   if (fileOpenStatus < 0)
     return(false);
      
   return (true);
}

void Copy1DimensionArrayToArray(strGlobal &arrSource[],strGlobal &arrDestine[]) export
{
   ArrayFree(arrDestine);
   ArrayCopy(arrDestine,arrSource);
} 

bool Read1DimensionArrayFromFile(strGlobal &arr[]) export
{
   bool b=false;
   if(OpenFileArray())
   {
      FileReadArray(fileOpenStatus,arr);  
      b=true;
   }      
   CloseFileArray();  

return (b);
}

bool Write1DimensionArrayToFile(strGlobal &arr[]) export
{
   bool b=false;
   FileDelete(FileName);
   if(OpenFileArray())
   {      
      FileWriteArray(fileOpenStatus,arr);   
      b=true;
   }
   
   CloseFileArray(); 
   
   return (b);
}       

