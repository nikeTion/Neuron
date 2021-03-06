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

int STOKPeriod=5;
int STODPeriod=3;
int STOSlowing=3;
int STOMethod=0;
int STOMode=0;
int ApplyTo=0;

bool AlertMode=true;
extern int OverBought=90;
extern int OverSold=10;

string ahi="******* ALERT SETTINGS:";
int    AlertCandle            = 0;
bool   PopupAlerts            = true;
bool   EmailAlerts            = false;
bool   PushNotificationAlerts = false;
bool   SoundAlerts            = false;
string SoundFileLong          = "alert.wav";
string SoundFileShort         = "alert2.wav";
int lastAlert=3;

double STOBuffer[];
double STOOBBuffer[];
double STOOSBuffer[];

int TimeFrame;
string TF;

int init()
  {
   string short_name;

   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,STOBuffer);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,STOOBBuffer);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,STOOSBuffer);

   short_name="Neuron.STOCH";
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);
   SetIndexLabel(1,"OverBought");
   SetIndexLabel(2,"OverSold");

   SetIndexDrawBegin(0,STOKPeriod);
   
    
   	   	switch(TimeFrame)
	{
		case 1:		TF="M1";  break;
		case 5:		TF="M5";  break;
		case 15:		TF="M15"; break;
		case 30:		TF="M30"; break;
		case 60:		TF="H1";  break;
		case 240:	TF="H4";  break;
		case 1440:	TF="D1";  break;
		case 10080:	TF="W1";  break;
		case 43200:	TF="MN1"; break;
		default:	  {TimeFrame = Period(); init(); return(0);}
	}

   return(0);
  }

int start()
  {
   int    i,counted_bars=IndicatorCounted();

   if(Bars<=STOKPeriod) return(0);

   i=Bars-STOKPeriod-1;

 
   if(counted_bars>=STOKPeriod) i=Bars-counted_bars-1;
   while(i>=0)
   {
      STOBuffer[i]=iStochastic(NULL,0,STOKPeriod,STODPeriod,STOSlowing,STOMethod,STOMode,ApplyTo,i);
      STOOBBuffer[i]=OverBought;
      STOOSBuffer[i]=OverSold;
      i--;
   }
   
   if(AlertMode)
   {
     if(STOBuffer[AlertCandle]>OverBought)
  {
    ObjectSetText("stoch", "n", 15, "Wingdings", clrGreen); 
    GlobalVariableSet("neuron.stoch."+ Symbol(), true);
  }
  else if(STOBuffer[AlertCandle]<OverSold )
  {
    ObjectSetText("stoch", "n", 15, "Wingdings", clrGreen); 
    GlobalVariableSet("neuron.stoch."+ Symbol(), true);
  } else {
    ObjectSetText("stoch", "n", 15, "Wingdings", clrRed); 
    GlobalVariableSet("neuron.stoch."+ Symbol(), false);
  }
  }

   return(0);
  }


void doAlerts(string msg,string SoundFile) {
        msg="Stochastic Alert on "+Symbol()+", period "+TFtoStr(Period())+": "+msg;
 string emailsubject="MT4 alert on acc. "+AccountNumber()+", "+WindowExpertName()+" - Alert on "+Symbol()+", period "+TFtoStr(Period());
  if (PopupAlerts) Alert(msg);
  if (EmailAlerts) SendMail(emailsubject,msg);
  if (PushNotificationAlerts) SendNotification(msg);
  if (SoundAlerts) PlaySound(SoundFile);

}

string TFtoStr(int period) {
 switch(period) {
  case 1     : return("M1");  break;
  case 5     : return("M5");  break;
  case 15    : return("M15"); break;
  case 30    : return("M30"); break;
  case 60    : return("H1");  break;
  case 240   : return("H4");  break;
  case 1440  : return("D1");  break;
  case 10080 : return("W1");  break;
  case 43200 : return("MN1"); break;
  default    : return(DoubleToStr(period,0));
 }
 return("UNKNOWN");
}