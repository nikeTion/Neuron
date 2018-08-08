#property copyright "Niketion"
#property link      "https://www.github.com/Niketion/Neuron"
#property version   "1.0.0-rc.1"

#property indicator_separate_window
#property indicator_buffers 7
#property indicator_color1 SlateGray
#property indicator_color2 LimeGreen
#property indicator_color3 Teal
#property indicator_color4 IndianRed
#property indicator_color5 Red
#property indicator_color6 Magenta
#property indicator_color7 SpringGreen
#property indicator_width1 2
#property indicator_width2 2
#property indicator_width3 2
#property indicator_width4 2
#property indicator_width5 2
#property indicator_width6 0
#property indicator_width7 0
#property indicator_level1  -100
#property indicator_level2   100
#property indicator_level3  -200
#property indicator_level4   200
#property indicator_levelcolor DarkSlateGray

int    CCIPeriod             = 14;
int    CCIPrice              = 0;
int    UpperTriggerLevel     =  100;
int    LowerTriggerLevel     = -100;
int    CriticalLevel         = 200;
int    TimeFrame = 0;
string TimeFrames = "M1;5,15,30,60H1;240H4;1440D1;10080W1;43200MN|0-CurrentTF";

bool   HISTOGRAM             = false;
bool   Alerts                = true;
string CriticalLevelAlert    = "CCI Critical Level";
string ZeroBuyAlert          = "BUY; CCI Zero Cross";
string ZeroSellAlert         = "SELL; CCI Zero Cross";
string UpperTriggerBuyAlert  = "BUY; CCI Upper Trigger Cross";
string UpperTriggerSellAlert = "SELL; CCI Upper Trigger Cross";
string LowerTriggerBuyAlert  = "BUY; CCI Lower Trigger Cross";
string LowerTriggerSellAlert = "SELL; CCI Lower Trigger Cross";
int    MaxBarsToCount           = 1500;
string note_Price = "Price(C0 O1 H2 L3 M4 T5 W6) ModeMa(SMA0,EMA1,SmmMA2,LWMA3)";


double CCI[];
double UpBuffer1[];
double UpBuffer2[];
double DnBuffer1[];
double DnBuffer2[];
double DnArr[];
double UpArr[];

int init() {
   IndicatorBuffers(7);
   
   int DrawType = DRAW_LINE;
   if (HISTOGRAM) DrawType = DRAW_HISTOGRAM;

   SetIndexBuffer(0,CCI);
   SetIndexBuffer(1,UpBuffer1);
   SetIndexBuffer(2,UpBuffer2);
   SetIndexBuffer(3,DnBuffer1);
   SetIndexBuffer(4,DnBuffer2);
   SetIndexBuffer(5,DnArr);
   SetIndexBuffer(6,UpArr);
   


   string short_name;
   short_name="Neuron.CCI";
   IndicatorShortName(short_name);

   return(0);
  }

int start() {
   int shift,trend;
   datetime TimeArray[];
   ArrayCopySeries(TimeArray,MODE_TIME,Symbol(),TimeFrame); 

   
   double CCI0, CCI1;
   double UpDnZero, UpDnBuffer;
   
   if (UpperTriggerLevel<0) UpperTriggerLevel=0;
   if (LowerTriggerLevel>0) UpperTriggerLevel=0;

   int    limit,y=0,counted_bars=IndicatorCounted();
   limit= Bars-counted_bars;
   limit= MathMax(limit,TimeFrame/Period());
   limit= MathMin(limit,MaxBarsToCount);

   for(shift=0,y=0;shift<limit;shift++)
   {
   if (Time[shift]<TimeArray[y]) y++;


     DnArr[shift]=EMPTY_VALUE;
     UpArr[shift]=EMPTY_VALUE;
      CCI[shift]=EMPTY_VALUE;
    CCI0=iCCI(NULL,TimeFrame,CCIPeriod,CCIPrice,y);
    CCI1=iCCI(NULL,TimeFrame,CCIPeriod,CCIPrice,y+1);
      UpDnZero=0; UpDnBuffer=1;
     if (!HISTOGRAM) {UpDnZero=EMPTY_VALUE; UpDnBuffer=CCI0; CCI[shift]=CCI0;}
      UpBuffer1[shift]=UpDnZero;
      UpBuffer2[shift]=UpDnZero;
      DnBuffer1[shift]=UpDnZero;
      DnBuffer2[shift]=UpDnZero;

    if (CCI0>UpperTriggerLevel)  UpBuffer1[shift]=UpDnBuffer;
    if (CCI0>0 && CCI0<=UpperTriggerLevel) UpBuffer2[shift]=UpDnBuffer;
    if (CCI0<0 && CCI0>=LowerTriggerLevel) DnBuffer1[shift]=UpDnBuffer;
    if (CCI0<LowerTriggerLevel)  DnBuffer2[shift]=UpDnBuffer;
    
     if (MathAbs(CCI0)>=200) { Alerts(CriticalLevelAlert);}
     else if (MathAbs(CCI0)<=-200) { Alerts(CriticalLevelAlert);}
     else { 
      ObjectSetText("cci", "n", 15, "Wingdings", clrRed); 
      GlobalVariableSet("neuron.cci." + Symbol(), false); 
     }
  }

  return(0);  
}

void Alerts(string AlertText) {
     GlobalVariableSet("neuron.cci." + Symbol(), true);
     ObjectSetText("cci", "n", 15, "Wingdings", clrGreen);
}