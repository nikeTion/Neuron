#property copyright "Niketion"
#property link      "https://www.github.com/Niketion/Neuron"
#property version   "1.0.0-beta"

#property indicator_separate_window
#property indicator_minimum 0
#property indicator_maximum 100
#property indicator_buffers 3
#property indicator_color1 DodgerBlue
#property indicator_color2 LightGray
#property indicator_color3 LightGray
#property indicator_width1 1
#property indicator_width2 1
#property indicator_width3 1
#property indicator_style1 STYLE_SOLID
#property indicator_style2 STYLE_DOT
#property indicator_style3 STYLE_DOT

int RSIPeriod=14;
int ApplyTo=0;
bool AlertMode=true;
int OverBought=70;
int OverSold=30;

double RSIBuffer[];
double RSIOBBuffer[];
double RSIOSBuffer[];

int init()
  {
   string short_name;

   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,RSIBuffer);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,RSIOBBuffer);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,RSIOSBuffer);

   short_name="Neuron.RSI";
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);
   SetIndexLabel(1,"OverBought");
   SetIndexLabel(2,"OverSold");

   SetIndexDrawBegin(0,RSIPeriod);

   return(0);
  }

int start()
  {
   int    i,counted_bars=IndicatorCounted();

   if(Bars<=RSIPeriod) return(0);

   i=Bars-RSIPeriod-1;
   if(counted_bars>=RSIPeriod) i=Bars-counted_bars-1;
   while(i>=0)
   {
      RSIBuffer[i]=iRSI(NULL,0,RSIPeriod,ApplyTo,i);
      RSIOBBuffer[i]=OverBought;
      RSIOSBuffer[i]=OverSold;
      i--;
   }
   
   if(AlertMode)
   {
      if(RSIBuffer[1]>=OverBought || RSIBuffer[0]>=OverBought) {
         ObjectSetText("rsi", "n", 15, "Wingdings", clrGreen); 
         GlobalVariableSet("neuron.rsi." + Symbol() , true);
      }
      else if(RSIBuffer[1]<=OverSold || RSIBuffer[0]<=OverSold) {
         ObjectSetText("rsi", "n", 15, "Wingdings", clrGreen); 
         GlobalVariableSet("neuron.rsi." + Symbol(), true);
      } else {
         ObjectSetText("rsi", "n", 15, "Wingdings", clrRed); 
         GlobalVariableSet("neuron.rsi." + Symbol(), false);
      }
   }

   return(0);
  }