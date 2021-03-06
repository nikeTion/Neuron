#property copyright "Niketion"
#property link      "https://www.github.com/Niketion/Neuron"
#property version   "1.0.0-beta"
#property strict
#property indicator_chart_window

static datetime TimeStamp;

int OnInit() {
   createRet("backgroundPanel", 300, -30, -85, clrBlueViolet, true);
   createRet("removeBackgroundPanel", 300, 120, -85, ChartBackColorGet(ChartID()), true);
   createRet("noTrasp", 185, -14, 10, clrWhite, false);
   
   insertText("versions", 8, "v0.2.0-rc.1", 10, 18, clrWhite);
   insertText("license", 7, "GNU(TM)", 115, 55, clrWhite);
   
   createRet("rsi",            15, 10, 85, clrRed, false);
   insertText("rsiText",   8, "RSI",             30, 90, clrBlack);
   
   createRet("stoch",          15, 10, 70, clrRed, false);
   insertText("stochText", 8, "Stoch",           30, 75, clrBlack);
      
   for (int i=0;i<ChartIndicatorsTotal(ChartID(), 0);i++) {
      for (int x=0;x<ChartIndicatorsTotal(ChartID(), 0);x++) {
         if (ChartIndicatorName(ChartID(), x, i) == "Neuron.BB") {
            createRet("bolliger_bands", 15, 10, 100, clrRed, false);
            insertText("bbText",    8, "Bollinger Bands", 30, 105, clrBlack);
         }
         
         if (ChartIndicatorName(ChartID(), x, i) == "Neuron.CCI") {
            createRet("cci",            15, 10, 115, clrRed, false);
            insertText("cciText",   8, "CCI",             30, 120, clrBlack);
         }

      }  
   }
   
   insertText("separator1", 10, "_______________________", 10, 18, clrWhite);
   insertText("panelName", 15, "Neuron", 50, 30, clrWhite);
   insertText("separator2", 10, "_______________________", 10, 40, clrWhite);
   
   insertText("credits", 7, "developed by Niketion", 65, 220, clrWhite);
   insertText("separator3", 10, "_______________________", 10, 221, clrWhite);
   return(INIT_SUCCEEDED);
}

int OnCalculate(const int rates_total, const int prev_calculated, const datetime &time[], const double &open[], const double &high[],const double &low[],
                const double &close[], const long &tick_volume[], const long &volume[], const int &spread[]) {
   int x=0;
   if (GlobalVariableGet("neuron.rsi." + Symbol())) {
     x++;
   }
   if (GlobalVariableGet("neuron.cci."  + Symbol())) {
     x++;
   }
   if (GlobalVariableGet("neuron.stoch."  + Symbol())) {
     x++;
   }
   if (GlobalVariableGet("neuron.bb." + Symbol())) {
     x++;
   }
   
   if (x>=3 && TimeStamp != Time[0]) {
      TimeStamp = Time[0];

      ObjectCreate("Upper", OBJ_ARROW_STOP, 0, Time[0], High[0]+20*Point); //draw an up arrow
      ObjectSet("Upper", OBJPROP_STYLE, STYLE_SOLID);
      ObjectSet("Upper", OBJPROP_COLOR,Blue); 
      Alert("+- SITUAZIONE LIMITE [" + Symbol()+ "] -+");
   }
 
   return(rates_total);
}

void OnTick() {
   
   Comment(GlobalVariableGet("neuron.cci." + Symbol()));
   if (ChartIndicatorName(ChartID(), 1, 0) == "Neuron.CCI") {
      if (!ObjectFind("cci")) {
         if (GlobalVariableGet("neuron.cci." + Symbol())) {
            createRet("cci",            15, 10, 115, clrGreen, false);
         } else {
            createRet("cci",            15, 10, 115, clrRed, false);
         }
         insertText("cciText",   8, "CCI",             30, 120, clrBlack);
      } else {
         if (GlobalVariableGet("neuron.cci." + Symbol())) {
            ObjectSetText("cci", "n", 15, "Wingdings", clrGreen);
            return;
         }
         ObjectSetText("cci", "n", 15, "Wingdings", clrRed);
      }
   }
}

color ChartBackColorGet(const long chart_ID=0) {
   long result=clrNONE;
   ResetLastError();
   if(!ChartGetInteger(chart_ID,CHART_COLOR_BACKGROUND,0,result))
     {
      Print(__FUNCTION__+", Error Code = ",GetLastError());
     }
   return((color)result);
}

void createRet(string name, int size, int x, int y, color clr, bool transp) {
   objectCreate(name, size, "n", x, y, clr, "Wingdings", transp);
}

void insertText(string name, int fontsize, string text, int x, int y, color clr) {
   objectCreate(name, fontsize, text, x, y, clr, "Corbel", false);
}

void objectCreate(string name, int fontsize, string text, int x, int y, color clr, string font, bool transp) {
   ObjectCreate(name, OBJ_LABEL, 0, 0, 0);
   ObjectSetText(name, text, fontsize, font, clr);
   ObjectSet(name, OBJPROP_XDISTANCE, x);
   ObjectSet(name, OBJPROP_YDISTANCE, y);
   ObjectSet(name, OBJPROP_BACK, transp);
   ObjectSet(name, OBJPROP_SELECTABLE, false);
}
