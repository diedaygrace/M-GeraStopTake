#property version   "1.2"
#property copyright "Enjoy"
#property description "O robo StopTake define a perda maxima e o lucro maximo (escolhido pelo usuario, nesse caso: Dino) da operação, no momento em que a posição é aberta. Automaticamente."
#include<Trade\Trade.mqh>
CTrade trade;
input double Pontos_Stop = 3.00;
input double Pontos_Take = 1.50;

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

void OnTick()
   {
      Fun_GeraSlTpDolar(Pontos_Stop*1000, Pontos_Take*1000);
   }