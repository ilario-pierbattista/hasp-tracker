function FlagPerson = IsPerson(Mat,rowPixel,columnPixel,minimo,SensorHeight,kinVr)

%FlagPerson: indica se l'oggetto individuato è un persona

%Elementi in ingresso:
%Mat:Frame di profondità no zero
%rowPixel:numero di pixel di riga di Mat
%columnPixel:numero di colonna di riga di Mat
%minimo:informazioni sul punto massimo mediato
%SensorHeight:altezza del sensore da terra
%kinVr: KinectVersion

%close all;
%Flag per attivare/disattivare il plot dei grafici
%plotGraph = 0;

if strcmp(kinVr,'KinectV1_240_320') || strcmp(kinVr,'KinectV1_480_640')
    row_half_FOV = 21.5;
    col_half_FOV = 28.5;
elseif strcmp(kinVr,'KinectV2')
    row_half_FOV = 30;
    col_half_FOV = 35;
else 
    error('select the Kinect version');
end

%Inizializzazione dei parametri di ritorno a dafault:
FlagPerson = -1;
Head_floor_Cont = 0;
Head_shoulder_Cont = 0;
Head_area_FL = -1;
Head_area_FL_1 = -1;
Head_area_FL_2 = -1;
Head_area_FL_3 = -1;

%Costanti
%In HA
%Dimensione [mm] della lunghezza minina e massima in cui le diagonali che
%compongono la testa devono rietrare.
HA_DIAG_MAX = 400; %[mm]
HA_DIAG_MIN = 150; %[mm]
%HSC
%Dimensione [mm] minimo e messimo del salto testa spalla richiesto
HSC_MIN = 150;
HSC_MAX = 300;
%Vettori che contengono l'andamento dell'altezza della persona nelle 
%specifiche direzioni a partire dal punto centrale (cent_C,cent_R) e
%spostandosi di maxStep
if strcmp(kinVr,'KinectV2') || strcmp(kinVr,'KinectV1_240_320')
    maxStep = 50;
else
    maxStep = 100;
end
%Soglia sulle dimensioni della diagonale per il controllo di Head_area_FL_2
%oltre a Head_area_FL_3, la differenza delle diagonali non deve superare
%questa quantità
DiagonalTh = 80;
North = zeros(1,maxStep);
North_Est = zeros(1,maxStep);
Est = zeros(1,maxStep);
Est_South = zeros(1,maxStep);
South = zeros(1,maxStep);
South_West = zeros(1,maxStep);
West = zeros(1,maxStep);
West_North = zeros(1,maxStep);

%Coordinata del punto massimo
cent_R = minimo(1);
cent_C = minimo(2);
%Altezza del punto massimo rispetto al sensore
cent_H = Mat(cent_R,cent_C);
%Altezza della persona(altezza del sensore rispetto al terreno - Mat(cent_R,cent_C))
Height_Obj = SensorHeight - Mat(cent_R,cent_C);
%Vettore che contiene l'indice della posizione del punto di ricerca
North_Index = zeros(2,maxStep);
North_Est_Index = zeros(2,maxStep);
Est_Index = zeros(2,maxStep);
Est_South_Index = zeros(2,maxStep);
South_Index = zeros(2,maxStep);
South_West_Index = zeros(2,maxStep);
West_Index = zeros(2,maxStep);
West_North_Index = zeros(2,maxStep);

%North(0°)
for i = 0 : maxStep - 1
    %if(cent_R + i <  rowPixel && Mat(cent_R + i,cent_C) ~= SensorHeight)
    %<=  e non < e basta perchè altrimenti non arriva mai a rowPixel ma
    %si ferma a rowPixel-1
    if(cent_R + i <=  rowPixel)
    North_Index(1,i + 1) = cent_R + i;
    North_Index(2,i + 1) = cent_C;
    North(i + 1) = Mat(cent_R + i,cent_C);
    else
    %Raggiunti i bordi della matrice    
    North_Index = North_Index(:,1:i);
    North = North(1:i);
    %North_Index = North_Index(1:i - 1);
    %North = North(1:i-1);
    break;
    end
end

%North_Est(45°)
for i = 0 : maxStep - 1
    %if(cent_R + i < rowPixel && cent_C + i < columnPixel && Mat(cent_R + i,cent_C + i) ~= SensorHeight )
    if(cent_R + i <= rowPixel && cent_C + i <= columnPixel)
    North_Est_Index(1,i + 1) = cent_R + i;
    North_Est_Index(2,i + 1) = cent_C + i;
    North_Est(i + 1) = Mat(cent_R + i,cent_C + i);
    else
     %Raggiunti i bordi della matrice   
     North_Est_Index = North_Est_Index(:,1:i);
     North_Est = North_Est(1:i);
     %North_Est_Index = North_Est_Index(:,1:i-1);
     %North_Est = North_Est(1:i-1);
     break;
    end
end

%Est(90°)
for i = 0 : maxStep - 1
    %if(cent_C + i <  columnPixel && Mat(cent_R,cent_C + i) ~= SensorHeight )
    if(cent_C + i <=  columnPixel)
    Est_Index(1,i + 1) = cent_R; 
    Est_Index(2,i + 1) = cent_C + i; 
    Est(i + 1) = Mat(cent_R,cent_C + i);    
    else
     %Raggiunti i bordi della matrice   
     Est_Index = Est_Index(:,1:i);
     Est = Est(1:i);
     %Est_Index = Est_Index(1:i - 1);
     %Est = Est(1:i - 1); 
     break;
    end
end

%Est_South(135°)
for i = 0 : maxStep - 1
    %if(cent_R - i >  0 && cent_C + i <  columnPixel && Mat(cent_R - i,cent_C + i) ~= SensorHeight )
    if(cent_R - i >  0 && cent_C + i <=  columnPixel )
    Est_South_Index(1,i + 1) = cent_R - i;
    Est_South_Index(2,i + 1) = cent_C + i;
    Est_South(i + 1) = Mat(cent_R - i,cent_C + i);
    else
     %Raggiunti i bordi della matrice
     Est_South_Index = Est_South_Index(:,1:i);
     Est_South = Est_South(1:i);
     %Est_South_Index = Est_South_Index(:,1:i-1);
     %Est_South = Est_South(1:i1-1);
     break;
    end
end

%South(180°)
for i = 0 : maxStep - 1
    %if(cent_R - i >  0 && Mat(cent_R - i,cent_C) ~= SensorHeight )
     if(cent_R - i >  0)
     South_Index(1,i + 1) = cent_R - i;
     South_Index(2,i + 1) = cent_C;
     South(i + 1) = Mat(cent_R - i,cent_C);
    else
     %Raggiunti i bordi della matrice   
     South_Index = South_Index(:,1:i);
     South = South(1:i);
     %South_Index = South_Index(:,i - 1);
     %South = South(1:i-1);
     break;
    end
end

%South_West(225°)
for i = 0 : maxStep - 1
    %if(cent_R - i > 0 && cent_C - i > 0 && Mat(cent_R - i,cent_C - i) ~= SensorHeight )
    if(cent_R - i > 0 && cent_C - i > 0)
    South_West_Index(1,i + 1) = cent_R - i;
    South_West_Index(2,i + 1) = cent_C - i;
    South_West(i + 1) = Mat(cent_R - i,cent_C - i);
    else
     %Raggiunti i bordi della matrice
     South_West_Index = South_West_Index(:,1:i);
     South_West = South_West(1:i);
%      South_West_Index = South_West_Index(:,1:i-1);
%      South_West = South_West(1:i-1);
     break;
    end
end

%West(270°)
for i = 0 : maxStep - 1
    %if(cent_C - i > 0 && Mat(cent_R,cent_C - i) ~= SensorHeight )
    if(cent_C - i > 0)
    West_Index(1,i + 1) = cent_R;
    West_Index(2,i + 1) = cent_C - i;
    West(i + 1) = Mat(cent_R,cent_C - i);
    else
     %Raggiunti i bordi della matrice
     West_Index = West_Index(:,1:i);
     West = West(1:i);
     %West_Index = West_Index(1:i - 1);
     %West = West(1:i-1);
     break;
    end
end

%West_North(272°)
for i = 0 : maxStep - 1
    %if(cent_R + i <  rowPixel && cent_C - i > 0 && Mat(cent_R + i,cent_C - i) ~= SensorHeight )
    if(cent_R + i <=  rowPixel && cent_C - i > 0  )
    West_North_Index(1,i + 1) = cent_R + i;
    West_North_Index(2,i + 1) = cent_C - i;
    West_North(i + 1) = Mat(cent_R + i,cent_C - i);
    else
     %Raggiunti i bordi della matrice
     West_North_Index = West_North_Index(:,1:i);
     West_North = West_North(1:i);
     %West_North_Index = West_North_Index(:,1:i-1);
     %West_North = West_North(1:i-1);
     break;
    end
end

%Individuazione del salto testa spalla: 
%Da Anthropometric Source Book, faccendo la differenza tra altezza
%totale(805) e altezza spalla(841) si ottiene l'altezza testa spalla,
%questa quantità è di circa 36/38 cm
%È necessario trovare una salto che si attesta all'incirca in questo 
%intervallo: min 30cm / max 40cm.

%La struttura Dir contiene:
%Dir.Punto_cardinale.->Index: Indice di Riga/Colonna del punto di altezza
%                             rilevato lungo la direzione Punto_cardinale
%                     ->Data: Punto di profondità nel punto Index
%                     ->Diff: Differenza tra Data(Index) e l'altezza
%                             massima della persona

%HxC_x [r c flag]:->r: riga in cui si verifica il HxC
%                 ->c: colonna in cui si verifica il HxC
%                 ->flag: flag per indicare se si è verificato un HxC
HFC = struct('HFC_N',[0 0 0],'HFC_NE',[0 0 0],'HFC_E',[0 0 0],'HFC_ES',[0 0 0],'HFC_S',[0 0 0],'HFC_SW',[0 0 0],'HFC_W',[0 0 0],'HFC_WN',[0 0 0]);
HSC = struct('HSC_N',[0 0 0],'HSC_NE',[0 0 0],'HSC_E',[0 0 0],'HSC_ES',[0 0 0],'HSC_S',[0 0 0],'HSC_SW',[0 0 0],'HSC_W',[0 0 0],'HSC_WN',[0 0 0]);
N = struct('Index',North_Index,'Data',North,'Diff',0,'DiffCons',0,'TotPun',0,'HFC',HFC,'HSC',HSC);
N_E = struct('Index',North_Est_Index,'Data',North_Est,'Diff',0,'DiffCons',0,'TotPun',0,'HFC',HFC,'HSC',HSC);
E = struct('Index',Est_Index,'Data',Est,'Diff',0,'DiffCons',0,'TotPun',0,'HFC',HFC,'HSC',HSC);
E_S = struct('Index',Est_South_Index,'Data',Est_South,'Diff',0,'DiffCons',0,'TotPun',0,'HFC',HFC,'HSC',HSC);
S = struct('Index',South_Index,'Data',South,'Diff',0,'DiffCons',0,'TotPun',0,'HFC',HFC,'HSC',HSC);
S_W = struct('Index',South_West_Index,'Data',South_West,'Diff',0,'DiffCons',0,'TotPun',0,'HFC',HFC,'HSC',HSC);
W = struct('Index',West_Index,'Data',West,'Diff',0,'DiffCons',0,'TotPun',0,'HFC',HFC,'HSC',HSC);
W_N = struct('Index',West_North_Index,'Data',West_North,'Diff',0,'DiffCons',0,'TotPun',0,'HFC',HFC,'HSC',HSC);
Dir = struct('N',N,'NE',N_E,'E',E,'ES',E_S,'S',S,'SW',S_W,'W',W,'WN',W_N);
SNames = fieldnames(Dir);
HFC_Names = fieldnames(HFC);
HSC_Names = fieldnames(HSC);

%Viene letto tutta la struttura Dir, loopIndex indica il numero di elementi
%all'interno di Dir
for loopIndex = 1:numel(SNames)
%stuff contiene il campo Data dello specifico elemento di Dir
stuff = Dir.(SNames{loopIndex}).Data;
    for i = 1:size(Dir.(SNames{loopIndex}).Index,2)
        %Differenza tra l'altezza massima della sagoma (cent_H) e
        %l'altezza di ogni punto nelle specifiche direzioni memorizzato in
        %stuff
        diff = stuff(i) - cent_H;
%         if(loopIndex == 2 && Dir.(SNames{loopIndex}).Index(1,i)==126 && Dir.(SNames{loopIndex}).Index(2,i)==274 )
%             true;
%         end
        if(i > 1)
            diffCons = stuff(i) - stuff(i - 1);
            %Memorizzazione di diffCons all'interno della struttura diffCons
             %if(stuff(i) ~= SensorHeight)
              if(diff > - 100)
                %Memorizzazione di diff all'interno della struttura Diff
                if(i == 2)
                    Dir.(SNames{loopIndex}).DiffCons = diffCons;
                else
                    Dir.(SNames{loopIndex}).DiffCons = [Dir.(SNames{loopIndex}).DiffCons diffCons];
                end
                Dir.(SNames{loopIndex}).Diff = [Dir.(SNames{loopIndex}).Diff diff];
              else
% %                 %Altrimenti viene salvato il valore -1 al posto
% %                 %delle diffenze(Diff e DiffCons)
                 %Dir.(SNames{loopIndex}).DiffCons = [Dir.(SNames{loopIndex}).DiffCons -1];
                 Dir.(SNames{loopIndex}).DiffCons = [Dir.(SNames{loopIndex}).DiffCons...
                        -1*ones(1,size(Dir.(SNames{loopIndex}).Index,2)+1 - i)];
                 Dir.(SNames{loopIndex}).Diff = [Dir.(SNames{loopIndex}).Diff...
                        -1*ones(1,size(Dir.(SNames{loopIndex}).Index,2)+1 - i)];
                 break;
              end
        else
            %Memorizzazione di diff all'interno della struttura Diff, nel
            %caso del primo elemento
            Dir.(SNames{loopIndex}).Diff = diff;
        end
    end
end

%1%  HFC
%Ricerca del salto testa-terreno: A causa della prospettiva a soffitto si
%verifica un salto tra testa e terreno è sempre presente nell'intorno della
%sagoma della testa
%Almeno un salto pari alla metà della massimo dell'altezza dell'oggetto
%(Height_Obj/2), valutato tra punti successivi:
%Head_floor_Cont = 0; %HFC
for loopIndex = 1 : numel(SNames)
    for temp = 1 : length( Dir.(SNames{loopIndex}).DiffCons )
        %if(Dir.(SNames{loopIndex}).DiffCons(temp) > cent_H/2)
        %Calcolo della lunghezza reale del vettore dei pixel che dal centro
        %si sposta verso la periferia
        if( strcmp(SNames{loopIndex},'N') || strcmp(SNames{loopIndex},'S') )
            Real_Length = cent_H*2*tand(row_half_FOV)/rowPixel*(temp); 
            elseif( strcmp(SNames{loopIndex},'E') || strcmp(SNames{loopIndex},'W') )
                Real_Length = cent_H*2*tand(col_half_FOV)/columnPixel*(temp);
            else
                Real_Length = sqrt( ( cent_H*2*tand(row_half_FOV)/rowPixel*(temp) )^2 + ( cent_H*2*tand(col_half_FOV)/columnPixel*(temp) )^2 );                        
        end
        
        %Salto testa-terreno in prossimità della testa (non prima e nemmeno
        %dopo)
        if(...
                Dir.(SNames{loopIndex}).DiffCons(temp) > Height_Obj/2 ...
                && ...
                Real_Length > HA_DIAG_MIN/2 && Real_Length < HA_DIAG_MAX/2 ...
            )
            Head_floor_Cont = Head_floor_Cont + 1;
            Dir.(SNames{loopIndex}).HFC.(HFC_Names{loopIndex})(3) = 1;
            %Salvataggio del punto per mostrarlo nel plot
            Dir.(SNames{loopIndex}).HFC.(HFC_Names{loopIndex})(1) = Dir.(SNames{loopIndex}).Index(1,temp);
            Dir.(SNames{loopIndex}).HFC.(HFC_Names{loopIndex})(2) = Dir.(SNames{loopIndex}).Index(2,temp);
            break;
        end
    end
end

            %2%  HSC
            %Ricerca del salto testa spalla: si sfruttano le relazioni antropomentriche
            %della persona (150mm <= altezza testa-spalla <= 400mm ) valutando il salto
            %tra punti consecutivi e la stessa cosa non si deve verificare con uno 
            %degli estremi che è pavimento:
            %Head_shoulder_Cont = 0; %HSC
            for loopIndex = 1 : numel(SNames)
                for temp = 1 : length( Dir.(SNames{loopIndex}).DiffCons )
                    if( Dir.(SNames{loopIndex}).DiffCons(temp) > HSC_MIN && Dir.(SNames{loopIndex}).DiffCons(temp) < HSC_MAX && ...
                        Dir.(SNames{loopIndex}).Data(temp) ~= SensorHeight  )
   
                        %Una volta verificata il salto HSC è anche
                        %necessario che questi si verifichi a una certa
                        %distanza dal punto centrale cent_H. Almeno metà
                        %della diagonale tipica che caratterizza la testa
                        %Real_Length = sqrt( ( cent_H*2*tand(row_half_FOV)/rowPixel*(temp) )^2 + ( cent_H*2*tand(col_half_FOV)/columnPixel*(temp) )^2 );                        
                         
                        if( strcmp(SNames{loopIndex},'N') || strcmp(SNames{loopIndex},'S') )
                           Real_Length = cent_H*2*tand(row_half_FOV)/rowPixel*(temp); 
                        elseif( strcmp(SNames{loopIndex},'E') || strcmp(SNames{loopIndex},'W') )
                           Real_Length = cent_H*2*tand(col_half_FOV)/columnPixel*(temp);
                        else
                           Real_Length = sqrt( ( cent_H*2*tand(row_half_FOV)/rowPixel*(temp) )^2 + ( cent_H*2*tand(col_half_FOV)/columnPixel*(temp) )^2 );                        
                        end
                       
                        if (Real_Length > HA_DIAG_MIN/2 && Real_Length < HA_DIAG_MAX/2)
                           %Tutto ok!
                        else
                           break; 
                        end
                        Head_shoulder_Cont = Head_shoulder_Cont + 1;
                        Dir.(SNames{loopIndex}).HSC.(HSC_Names{loopIndex})(3) = 1;
                        %Salvataggio del punto per mostrarlo nel plot
                        Dir.(SNames{loopIndex}).HSC.(HSC_Names{loopIndex})(1) = Dir.(SNames{loopIndex}).Index(1,temp);
                        Dir.(SNames{loopIndex}).HSC.(HSC_Names{loopIndex})(2) = Dir.(SNames{loopIndex}).Index(2,temp);
                        break;
                    end
                end
            end

                        %3%  HA
                        %Controllo dell'area occupata dalla testa: si valuta l'area all'interno di
                        % 200 mm in altezza dal punto di MASSIMO per capire se la stessa rappresenta una
                        %testa:
                        %Head_area_FL = 0; %HA
                        for loopIndex = 1 : numel(SNames)
                            counter_diff = 0;
                            jump = false;
                            for temp = 1 : length( Dir.(SNames{loopIndex}).Diff )
                                
                                if( Dir.(SNames{loopIndex}).Diff(temp) > 200 )
                                    %Calcolo del numero di punti nella specifica direzione dal
                                    %punto centrale fino a quello corrente in cui avviene una
                                    %differenza tale da verificare la condizione sopra.
                                    jump = true;
                                    break;
                                end
                                counter_diff = counter_diff + 1;
                            end
                            %-1 perchè così non viene conteggiato il pixel che causa il
                            %salto. Questa condizione viene raggiunta anche
                            %se il salto di 200 non si verifica, ciò capita
                            %ad essempio quando si verifica prima il salto
                            %del pavimento che quello > 200
                            if(jump)
                                Dir.(SNames{loopIndex}).TotPun = counter_diff - 1;
                            else
                                Dir.(SNames{loopIndex}).TotPun = counter_diff;
                            end
                        end
                        %Colcolo dell'area della testa:
                        %Formule ricavate da:
                        %(Expert's voice in Microsoft) Jarrett Webb_ James Ashley,
                        %"software developer-Beginning kinect programming with the microsoft kinect
                        %SDK" Apress  (2012) pag.69-70:
                        %Wr [mm]:distanza reale
                        %d [mm]:profondità misurata dal sensore
                        %Wp [pixel]:distanza in pixel
                        %TetaHor(57°) [grad]:angolo di apertura del sensore in orizzontale
                        %TetaVer(43°) [grad]:angolo di apertura del sensore in verticale
                        %Wr_Horizontal = [2*d*tand(TetaHor/2)*Wp]/columnPixel
                        %Wr_Vertical = [2*d*tand(TetaVer/2)*Wp]/rowPixel
                        %Viene tolto -1 perchè il pixel centrale viene conteggiato due volte (stessa
                        %cosa per tutte e tre le altre direzioni)
                        NS_NumPixel = Dir.N.TotPun + Dir.S.TotPun - 1;%Wp[pixel]
                        if(NS_NumPixel > 0)
                            DiagMag = cent_H*2*tand(row_half_FOV)/rowPixel*NS_NumPixel;%Wr[mm]
                        else
                            DiagMag = 0;
                        end

                        
                        EW_NumPixel = Dir.E.TotPun + Dir.W.TotPun - 1;%Wp[pixel]
                        if(EW_NumPixel > 0)
                        DiagMin = cent_H*2*tand(col_half_FOV)/columnPixel*EW_NumPixel;%Wr[mm]
                        else
                            DiagMin = 0;
                        end

                        %Per calcolare la lunghezza reale nella direzione diagonale, vedo questa
                        %quantità come l'ipotenusa di un triangolo rettangolo i cui lati minori
                        %sono UGUALI, in pratica si verifica che i lati moniri nel dominio dei
                        %PIXEL sono lunghi come l'ipotenusa
                        %               ____
                        %               \   |
                        %                \  |
                        %NE_SW_NumPixel1  \ |
                        %                  \|____
                        %                   \    |
                        %                    \   |
                        %     NE_SW_NumPixel2 \  |
                        %                      \ |
                        %                       \|
                        NE_SW_Diag1 = sqrt( ( cent_H*2*tand(row_half_FOV)/rowPixel*(Dir.NE.TotPun - 1) )^2 + ( cent_H*2*tand(col_half_FOV)/columnPixel*(Dir.NE.TotPun - 1) )^2 );%Wr parziale[mm]  
                        NE_SW_Diag2 = sqrt( ( cent_H*2*tand(row_half_FOV)/rowPixel*(Dir.SW.TotPun) )^2 + ( cent_H*2*tand(col_half_FOV)/columnPixel*(Dir.SW.TotPun) )^2 );%Wr parziale[mm]
                        %NE_SW_NumPixel = Dir.NE.TotPun + Dir.SW.TotPun; 
                        %Sembrano non  veritieri...
                        NE_SW_Diag = NE_SW_Diag1 + NE_SW_Diag2;%Wr[mm] 

                        WN_ES_Diag1 = sqrt( ( cent_H*2*tand(row_half_FOV)/rowPixel*(Dir.WN.TotPun - 1) )^2 + ( cent_H*2*tand(col_half_FOV)/columnPixel*(Dir.WN.TotPun - 1) )^2 );%Wr parziale[mm]
                        WN_ES_Diag2 = sqrt( ( cent_H*2*tand(row_half_FOV)/rowPixel*(Dir.ES.TotPun) )^2 + ( cent_H*2*tand(col_half_FOV)/columnPixel*(Dir.ES.TotPun) )^2 );%Wr parziale[mm]
                        %WN_ES_NumPixel = Dir.WN.TotPun + Dir.ES.TotPun;
                        %Sembrano non  veritieri...
                        WN_ES_Diag = WN_ES_Diag1 + WN_ES_Diag2;%Wr[mm]

                        % %Metodo alternativo per calcolare la dimensione reale nella direzione
                        % %diagonale WN_ES e NE_SW:
                        %WN
                        r = cent_R;
                        c = cent_C;
                        MaxPixelWN_ES = 0;
                        while( r <= rowPixel && c > 0 )
                            MaxPixelWN_ES = MaxPixelWN_ES + 1;
                            r = r + 1;
                            c = c - 1;
                        end
                        %ES
                        r = cent_R;
                        c = cent_C;
                        while(r > 0 && c <= columnPixel)
                            MaxPixelWN_ES = MaxPixelWN_ES + 1;
                            r = r - 1;
                            c = c + 1;
                        end

                        %NE
                        r = cent_R;
                        c = cent_C;
                        MaxPixelNE_SW = 0;
                        while(r <= rowPixel && c <= columnPixel)
                            MaxPixelNE_SW = MaxPixelNE_SW + 1;
                            r = r + 1;
                            c = c + 1;
                        end

                        %SW
                        r = cent_R;
                        c = cent_C;
                        while(r > 0 && c > 0)
                            MaxPixelNE_SW = MaxPixelNE_SW + 1;
                            r = r - 1;
                            c = c - 1;
                        end
                        % WN_ES_Diag_SecMet = cent_H*2*tand(35.7*MaxPixelWN_ES/columnPixel)/MaxPixelWN_ES*(((Dir.WN.TotPun + Dir.ES.TotPun - 1 )));
                        % NE_SW_Diag_SecMet = cent_H*2*tand(35.7*MaxPixelNE_SW/columnPixel)/MaxPixelNE_SW*(((Dir.NE.TotPun + Dir.SW.TotPun - 1 )));

                        %Salvataggio di queste informazioni:
                        %diagLength = struct('DiagN',DiagMag,'DiagE',DiagMin);
                        diagLength = struct('DiagN',DiagMag,'DiagE',DiagMin,'DiagNE',NE_SW_Diag,'DiagnNW',WN_ES_Diag);


                        %1°controllo: le diangonali devono avere dimensioni adeguate
                        if( (DiagMag > HA_DIAG_MIN && DiagMag < HA_DIAG_MAX ) && (DiagMin > HA_DIAG_MIN && DiagMin < HA_DIAG_MAX ))
                            Head_area_FL_1 = 1;
                        end
                        % if( (DiagMag > 100 && DiagMag < 300 ) && (DiagMin > 100 && DiagMin < 300 ) && abs(DiagMin - DiagMag) < 100 ...
                        %      && (NE_SW_Diag > 100 && NE_SW_Diag < 300 ) && (WN_ES_Diag > 100 && WN_ES_Diag < 300 ))
                        %     Head_area_FL = 1;
                        % end

                        %2°controllo: le SEMI-diagonali devono avere dimensioni confrontabili tra loro
                        %if(Head_area_FL == 1) si calcola la differenza tra
                        %le semidiagonali e la loro differenza no deve
                        %superare iagonalTh/2
                            if(...
                                    abs( cent_H*2*tand(row_half_FOV)/rowPixel*Dir.N.TotPun - cent_H*2*tand(row_half_FOV)/rowPixel*Dir.S.TotPun ) < DiagonalTh/2 ...
                                    ...%abs(Dir.N.TotPun - Dir.S.TotPun) > 20 
                                    || ...
                                    abs(cent_H*2*tand(col_half_FOV)/columnPixel*Dir.E.TotPun -cent_H*2*tand(col_half_FOV)/columnPixel*Dir.W.TotPun ) < DiagonalTh/2 ...
                                    ...%abs(Dir.E.TotPun - Dir.W.TotPun) > 20
                                )                              
                                Head_area_FL_2 = 1;
                            end
                        %end
                        %3°controllo: le diagonali devono avere dimensioni confrontabili tra loro:
                        %if(Head_area_FL == 1)
                                if( abs(DiagMag - DiagMin) < DiagonalTh ) 
                                    Head_area_FL_3 = 1;
                                end

                        %Controllo parziale sulla terza condizione
                        if( Head_area_FL_1 == 1 && Head_area_FL_2  == 1 && Head_area_FL_3  == 1 )
                            Head_area_FL = 1;
                        end


%CONTROLLO FINALE PER VERIFICARE SE L'OGGETTO RAPPRESENTA UNA PERSONA%%%%%%
if(Head_floor_Cont >= 3 && Head_shoulder_Cont >= 2 && Head_area_FL == 1)
    FlagPerson = 1;
end

% if(plotGraph)
% %Plot dei risultati********************************************************
% 
% %PRIMA FIGURA
% %Plot del frame
% figure;
% contourf(Mat);
% hold on;
% plot(minimo(2),minimo(1),'.r','MarkerSize',30);
% %Vengono plottati i punti per il calcolo delle diagonali nelle diverse
% %direzioni:
% for loopIndex = 1:numel(SNames)
%     for i = 1:Dir.(SNames{loopIndex}).TotPun
%         plot(Dir.(SNames{loopIndex}).Index(2,i),Dir.(SNames{loopIndex}).Index(1,i),'.k','MarkerSize',10)
%     end
% end
% title('Plot del frame standard');
% %Head_floor_Cont >= 2 &&  Head_shoulder_Cont >= 2 && Head_area_FL == 1
% labelToPlot = strcat('HFC: ',num2str(Head_floor_Cont),' HSC: ',num2str(Head_shoulder_Cont),' HA: ',num2str(Head_area_FL));
% text(cent_C,cent_R,labelToPlot,'FontWeight','bold','Color',[1 1 0],'FontSize',10)
% 
% if(FlagPerson == 1)
%     text(cent_C,cent_R + 10,'Person','FontWeight','bold','Color',[1 0 0],'FontSize',20);
% else
%     text(cent_C,cent_R - 10,'Object','FontWeight','bold','Color',[1 1 0],'FontSize',20);
% end
% 
% 
% %Plot 3D
% %SECONDA FIGURA
% %Plot degli andamenti dell'altezza della persona nelle diverse direzioni
% fullscreen = get(0,'ScreenSize');
% figure('Position',[0 -50 fullscreen(3) fullscreen(4)]);
%     
% for loopIndex = 1:numel(SNames)
%     subplot(2,4,loopIndex)
%     plot3(Dir.(SNames{loopIndex}).Index(2,:),Dir.(SNames{loopIndex}).Index(1,:),Dir.(SNames{loopIndex}).Data,'.b');
%         if(strcmp(SNames{loopIndex},'N') || strcmp(SNames{loopIndex},'S'))
%             az = 90;
%             el = 0; 
%         else
%             az = 0;
%             el = 0;
%         end
%     view(az, el);
%     grid on
%     xlabel('Column pixel');
%     ylabel('Row pixel');
%     zlabel('Height [mm]');
%     axis([-2 + min(Dir.(SNames{loopIndex}).Index(2,:))...
%           +2 + max(Dir.(SNames{loopIndex}).Index(2,:))...
%           -2 + min(Dir.(SNames{loopIndex}).Index(1,:))...
%           +2 + max(Dir.(SNames{loopIndex}).Index(1,:))...
%           0 SensorHeight])
%     %flag = Dir.(SNames{loopIndex}).FlagPerson;
%     %tit = strcat(SNames{loopIndex},'   IsPerson:',num2str(flag));    
%     tit = strcat(SNames{loopIndex},', ',' \color[rgb]{0 0.64 0.31}HFC:',...
%         num2str(Dir.(SNames{loopIndex}).HFC.(HFC_Names{loopIndex})(3)),...
%         ' \color{yellow}HSC:',num2str(Dir.(SNames{loopIndex}).HSC.(HSC_Names{loopIndex})(3)),...
%         ', \color{blue}N.Pixel: ',num2str(Dir.(SNames{loopIndex}).TotPun));
%     title(tit,'Color','b','FontWeight','bold');
%     hold on;
%     plot3(Dir.(SNames{loopIndex}).Index(2,1),...
%         Dir.(SNames{loopIndex}).Index(1,1),...
%         Dir.(SNames{loopIndex}).Data(1),...
%         '.r','MarkerSize',20);
%     %Plot del punto(se presente) in cui viene verificato HFC 
%     if(Dir.(SNames{loopIndex}).HFC.(HFC_Names{loopIndex})(3))
%         plot3(Dir.(SNames{loopIndex}).HFC.(HFC_Names{loopIndex})(2),...
%         Dir.(SNames{loopIndex}).HFC.(HFC_Names{loopIndex})(1),...
%          Mat(...
%                     Dir.(SNames{loopIndex}).HFC.(HFC_Names{loopIndex})(1),...
%                     Dir.(SNames{loopIndex}).HFC.(HFC_Names{loopIndex})(2)...
%                         ),...
%         '.g','MarkerSize',30);
%     end %e HSC
%     if(Dir.(SNames{loopIndex}).HSC.(HSC_Names{loopIndex})(3))
%         plot3(Dir.(SNames{loopIndex}).HSC.(HSC_Names{loopIndex})(2),...
%         Dir.(SNames{loopIndex}).HSC.(HSC_Names{loopIndex})(1),...
%                     Mat(...
%                     Dir.(SNames{loopIndex}).HSC.(HSC_Names{loopIndex})(1),...
%                     Dir.(SNames{loopIndex}).HSC.(HSC_Names{loopIndex})(2)...
%                         ),...
%         '.y','MarkerSize',30);
%     end
% end
% %titolo della figure, altezza massima della persona e lunghezza diagonale
% %maggiore e minore:
% axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],...
%     'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
%     tit = strcat('Height of points, starting from central to periphery',...
%         '   Distance from sensor: ',num2str(cent_H),'[mm]',...
%         ' Real height: ',num2str(Height_Obj),'[mm]',...
%         ' diagonal length:',...
%         ' DiagN:',num2str(round(diagLength.DiagN)),...
%         ' DiagE:',num2str(round(diagLength.DiagE)),...
%         ' diag: ',num2str(Head_area_FL_1),' SEMI-diag: ',num2str(Head_area_FL_2),' DiagCompare: ',num2str(Head_area_FL_3));
%     text(0.5, 1,tit,'HorizontalAlignment','center','VerticalAlignment', 'top')
% 
% 
% 
% %TERZA FIGURA    
% %Plot delle differenze tra punto centrale e altezza alle diverse posizioni
% figure('Position',[0 -50 fullscreen(3) fullscreen(4)]);
% 
% for loopIndex = 1:numel(SNames)
%     subplot(2,4,loopIndex)
%     plot3(Dir.(SNames{loopIndex}).Index(2,:),Dir.(SNames{loopIndex}).Index(1,:),Dir.(SNames{loopIndex}).Diff,'.b');
%     %plot(Dir.(SNames{loopIndex}).Index(1,:),Dir.(SNames{loopIndex}).Diff,'.b');
%         if(strcmp(SNames{loopIndex},'N') || strcmp(SNames{loopIndex},'S'))
%             az = 90;
%             el = 0; 
%         else
%             az = 0;
%             el = 0;
%         end
%     view(az, el);
%     grid on
%     xlabel('Column pixel');
%     ylabel('Row pixel');
%     zlabel('Difference');
%     axis([-2 + min(Dir.(SNames{loopIndex}).Index(2,:))...
%           +2 + max(Dir.(SNames{loopIndex}).Index(2,:))...
%           -2 + min(Dir.(SNames{loopIndex}).Index(1,:))...
%           +2 + max(Dir.(SNames{loopIndex}).Index(1,:))...
%           -1000 SensorHeight])
%     %flag = Dir.(SNames{loopIndex}).FlagPerson;
%     %tit = strcat(SNames{loopIndex},'   IsPerson:',num2str(flag));
%     tit = strcat(SNames{loopIndex},', N.Pixel: ',num2str(Dir.(SNames{loopIndex}).TotPun));
%     title(tit,'Color','b','FontWeight','bold','FontWeight','bold');
%     hold on
%     
%     %Plot del punto(se presente) in cui viene verificato HFC 
%     if(Dir.(SNames{loopIndex}).HFC.(HFC_Names{loopIndex})(3))
%         plot3(Dir.(SNames{loopIndex}).HFC.(HFC_Names{loopIndex})(2),...
%         Dir.(SNames{loopIndex}).HFC.(HFC_Names{loopIndex})(1),...
%          Mat(...
%                     Dir.(SNames{loopIndex}).HFC.(HFC_Names{loopIndex})(1),...
%                     Dir.(SNames{loopIndex}).HFC.(HFC_Names{loopIndex})(2)...
%                         )-minimo(3),...
%         '.g','MarkerSize',30);
%     end %e HSC
%     if(Dir.(SNames{loopIndex}).HSC.(HSC_Names{loopIndex})(3))
%         plot3(Dir.(SNames{loopIndex}).HSC.(HSC_Names{loopIndex})(2),...
%         Dir.(SNames{loopIndex}).HSC.(HSC_Names{loopIndex})(1),...
%                     Mat(...
%                     Dir.(SNames{loopIndex}).HSC.(HSC_Names{loopIndex})(1),...
%                     Dir.(SNames{loopIndex}).HSC.(HSC_Names{loopIndex})(2)...
%                         )-minimo(3),...
%         '.y','MarkerSize',30);
%     end
% end
% %Titolo del subplot
% axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],...
%     'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
%     tit = strcat('Difference between current point and central point (Diff)');
%     text(0.5, 1,tit,'HorizontalAlignment','center','VerticalAlignment', 'top')
% 
%     
%     
% %QUARTA FIGURA    
% %Plot delle differenze tra punti consecutivi
% figure('Position',[0 -50 fullscreen(3) fullscreen(4)]);
% 
% for loopIndex = 1:numel(SNames)
%     subplot(2,4,loopIndex)
%     plot3(Dir.(SNames{loopIndex}).Index(2,:),Dir.(SNames{loopIndex}).Index(1,:),Dir.(SNames{loopIndex}).DiffCons,'.b');
%     %plot(Dir.(SNames{loopIndex}).Index(1,:),Dir.(SNames{loopIndex}).Diff,'.b');
%         if(strcmp(SNames{loopIndex},'N') || strcmp(SNames{loopIndex},'S'))
%             az = 90;
%             el = 0; 
%         else
%             az = 0;
%             el = 0;
%         end
%     view(az, el);
%     grid on
%     xlabel('Column pixel');
%     ylabel('Row pixel');
%     zlabel('Difference between consecutive points');
%     %flag = Dir.(SNames{loopIndex}).FlagPerson;
%     %tit = strcat(SNames{loopIndex},'   IsPerson:',num2str(flag));
%     tit = strcat(SNames{loopIndex},', ',' \color[rgb]{0 0.64 0.31}HFC:',num2str(Dir.(SNames{loopIndex}).HFC.(HFC_Names{loopIndex})(3)),...
%         ' \color{yellow}HSC:',num2str(Dir.(SNames{loopIndex}).HSC.(HSC_Names{loopIndex})(3)));
%     title(tit,'Color','b','FontWeight','bold');
%     hold on
%     %Plot dei livelli di soglia HSC_MAX eHSC_MIN
%     plot3(Dir.(SNames{loopIndex}).Index(2,:),...
%         Dir.(SNames{loopIndex}).Index(1,:),...
%         HSC_MAX*ones(1,size(Dir.(SNames{loopIndex}).Index(2,:),2)),...
%         '.y','MarkerSize',6);
%     plot3(Dir.(SNames{loopIndex}).Index(2,:),...
%         Dir.(SNames{loopIndex}).Index(1,:),...
%         HSC_MIN*ones(1,size(Dir.(SNames{loopIndex}).Index(2,:),2)),...
%         '.y','MarkerSize',6);
% end
% %Titolo del subplot
% axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],...
%     'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
%     tit = strcat('Difference between consecutive points (DiffCons)',...
%         ' \color[rgb]{0 0.64 0.31}HFC threshold: \color[rgb]{0 0.64 0.31}',num2str(Height_Obj/2),'[mm]',...
%         '      \color{yellow}HSC\_MIN threshold: \color{yellow}',num2str(HSC_MIN),'[mm]',...
%         ' \color{yellow}HSC\_MAX threshold: \color{yellow}',num2str(HSC_MAX),'[mm]');
%     text(0.5, 1,tit,'HorizontalAlignment','center','VerticalAlignment', 'top')
% %Plot dei risultati********************************************************
% end