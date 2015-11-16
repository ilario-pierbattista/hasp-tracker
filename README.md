# Hasp Tracker
Sistema allenabile di rilevamento dell'immagine della figura HASP (Head And Shoulders Profile) in frame di profondità catturati dall'alto di una stanza con il dispositivo Kinect, basato su Adaboost e sul frame di riconoscimento dei volti di Viola-Jones.

Questo progetto costituisce il lavoro di tirocinio svolto presso il Dipartimento di Ingegneria dell'Informazione dell'Università Politecnica delle Marche.

Per contattarmi è possibile scrivere una mail all'indirizzo <pierbattista.ilario@gmail.com>: sono sempre disponibile per **chiarimenti**.

Per segnalare eventuali **bug**, invece, è necessario utilizzare il bug tracker interno di github.
Se volete inviare una **patch**, create un vostro fork personale, modificate il codice e mandatemi una pull request, sarò felice di valutarla.
Eventuali email volte alla segnalazione di bug o all'invio di patch saranno inesorabilmente cestinate.

## Presentazione
Sono individuabili due componenti fondamentali del sistema software: il __modulo di allenamento__ e il __modulo di rilevamento__.

Il __modulo di allenamento__ implementa l'algoritmo __Adaboost__, facente parte della famiglia degli algoritmi di _allenamento supervisionato_ e degli _ensamble learner_.
Utilizza degli insiemi di allenamento, costituiti da ritagli di immagini di profondità registrate con il Kinect, che ritraggono sia immagini di persone che non.

Il __modulo di rilevamento__ sfrutta il classificatore prodotto dal modulo di allenamento per effettuare il rilevamento su registrazioni reali, classificando sequenzialmente porzioni di esso al fine di determinare la zona occupata dalla persona.

Questo repository contiene:

1. il tool per la creazione degli insiemi di allenamento ([TrainsetCreator](https://github.com/ilario-pierbattista/hasp-tracker/tree/master/TrainsetCreator))
2. gli script per le procedure di allenamento e rilevamento ([matlab/procedures](https://github.com/ilario-pierbattista/hasp-tracker/tree/master/matlab/procedures))
3. una piccola libreria, scritta in C++, per fattorizzare ed ottimizzare alcune funzioni dei due moduli software ([matlab/lib](https://github.com/ilario-pierbattista/hasp-tracker/tree/master/matlab/lib))
4. una collezione di funzioni, scritte in Matlab, utilizzate per fattorizzare il codice dei due moduli ([matlab](https://github.com/ilario-pierbattista/hasp-tracker/tree/master/matlab))
5. la mia tesi di laurea ([doc/tesi/index.pdf](https://github.com/ilario-pierbattista/hasp-tracker/tree/master/doc/tesi/index.pdf))


## Compatibilità
Il sistema è completamente compatibile con qualsiasi distribuzione GNU/Linux.

Sebbene non siano stati utilizzati componenti specifici per la piattaforma, la compatibilità con Windows o Mac OS non è stata testata.

Particolarmente critica è la compilazione della libreria scritta in C++ e la compilazione degli eseguibili [mex](http://it.mathworks.com/help/matlab/matlab_external/introducing-mex-files.html).
Per ulteriori informazioni consultare la relativa sezione.


## TrainsetCreator
È un'applicazione desktop scritta in Java che consente di gestire gli insiemi (_dataset_) di allenamento.
È uno strumento efficace per ritagliare, dai frame di profondità, delle porzioni di immagine che andranno a costituire i dataset di allenamento.
Inoltre permette di effettuare anche il resize di tali immagini.

### Compilazione
L'applicazione è stata sviluppata utilizzando l'IDE [Intellij IDEA](https://www.jetbrains.com/idea/) (sono disponibili license per studenti fornendo l'indirizzo email istituzionale oppure è possibile scaricare la _community edition_).
È __necessario__ utilizzare tale IDE per compilare il progetto, residente nella relativa cartella, e generare il file jar (che è eseguibile su qualsiasi piattaforma).
