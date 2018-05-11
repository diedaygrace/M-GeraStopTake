#property version   "1.00"
#include<Trade\Trade.mqh>
CTrade trade;
input double Pontos_Stop = 3.00;
input double Pontos_Take = 1.50;
int Fun_Total_Posicoes()
   {
      int PosSymTotal = 0;
      for(int i=0; i<PositionsTotal(); i++)
         {
            if(PositionGetSymbol(i)==Symbol())
               {
                  PosSymTotal = PosSymTotal + 1;
               }
         }
      return(PosSymTotal);
   }
bool Fun_GeraSlTpDolar(double pontosStop, double pontosTake)
   { 
      bool oQueVirou = false;
      PositionSelect(_Symbol);
      if(PositionGetDouble(POSITION_SL) == 0 && PositionGetDouble(POSITION_TP) == 0)
         {
            double abertura;
            abertura = PositionGetDouble(POSITION_PRICE_OPEN);
            if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
               {
                  oQueVirou = trade.PositionModify(PositionGetTicket(0), abertura+(pontosStop*_Point), abertura-(pontosTake*_Point));
               }
            else
               {
                  oQueVirou = trade.PositionModify(PositionGetTicket(0), abertura-(pontosStop*_Point), abertura+(pontosTake*_Point));
               }
         }
      return oQueVirou;
   }
bool alterna = false;
void OnTick()
   {
      double Ask;
      double Bid;
      Ask = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
      Bid = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
      if(Fun_Total_Posicoes() == 0){
         if(alterna == false){
            trade.Buy(1,NULL,Ask,0,0,NULL);
            alterna = true;
         }
         else{
            trade.Sell(1,NULL,Bid,0,0,NULL);
            alterna = false;
         }
      }
      Fun_GeraSlTpDolar(Pontos_Stop*1000, Pontos_Take*1000);
   }