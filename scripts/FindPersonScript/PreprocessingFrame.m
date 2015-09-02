function M_corrNoZ = PreprocessingFrame(M,rowPixel,columnPixel,SensorHeight)
%La funzione a partire dalla matrice "raw" permette di:
%1)Eliminata la riga verticale a sinistra
    %2)Unifirmizzato il livello del pavimento a SensorHeight [mm]
        %3)Tolti gli zeri dovuti a punti non indivisuati dal sensore

        
%OUTPUT
%M_corrNoZ
%Matrice elaborata dopo l'implementazione dei punti 1-2-3

%INPUT
%M
%Matrice in arrivo dal Kinect
%rowPixel
%Numero di righe
%columnPixel
%Numero di colonne
%SensorHeight
%Altezza del sensore da terra

%1-2
%Togliere riga verticale a sinistra da ogni frame:
M_corr = M;

for r = 1 : rowPixel
    for c = 1: columnPixel
        if(c < 9)
            M_corr(:,c) = SensorHeight;
            continue;
        end
        %if(M_corr(r,c) > 2800 )
        if(M_corr(r,c) > SensorHeight - 200 )
            M_corr(r,c) = SensorHeight;
        end
    end
end

% %2)
% %Uniformizzare il livello del pavimento ad un valore fisso 
% for r = 1 : rowPixel
%     for c = 1: columnPixel
%         if(M_corr(r,c) > 2800 )
%             M_corr(r,c) = SensorHeight;
%         end
%     end
% end

%3)
%Si eliminano i punti di 0 sostituendoli con il
%primo valore diverso da 0 precedente o successivo (cioè spostandosi 
%rispettivamente verso sinistra o destra) sulla STESSA riga
M_corrNoZ = M_corr;
% M_corrNoZ_indexRigth = 1;
% M_corrNoZ_indexLeft = 1;
for r= 1 : rowPixel
    for c= 1: columnPixel
%         if(r ==97 && c==313)
%             true;
%         end
        if(M_corr(r,c) == 0)
            M_corrNoZ_indexRigth = c;
            M_corrNoZ_indexLeft = c;
            %Si guardano i pixel successivi sulla stessa riga per
            %cercare il primo valore diverso da 0                
                if(M_corrNoZ_indexRigth + 1 < columnPixel)
                    M_corrNoZ_indexRigth = c + 1;
                end
                if(M_corrNoZ_indexLeft - 1 > 1 )
                    M_corrNoZ_indexLeft = c - 1;
                end
            while(M_corr(r,M_corrNoZ_indexRigth) == 0 && M_corr(r,M_corrNoZ_indexLeft) == 0)
                if(M_corrNoZ_indexRigth + 1 < columnPixel)
                    M_corrNoZ_indexRigth = M_corrNoZ_indexRigth + 1;
                end
                if(M_corrNoZ_indexLeft - 1 > 1 )
                    M_corrNoZ_indexLeft = M_corrNoZ_indexLeft - 1;
                end
            end
                if(M_corr(r,M_corrNoZ_indexRigth) ~= 0)
                    M_corrNoZ(r,c) = M_corr(r,M_corrNoZ_indexRigth);
                else
                    M_corrNoZ(r,c) = M_corr(r,M_corrNoZ_indexLeft);
                end
        end
    end
end