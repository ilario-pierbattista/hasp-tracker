# Suite principale
Clonare il repository in locale:

    $ git https://github.com/ilario-pierbattista/hasp-tracker
    $ cd hasp-tracker

## Configurazione di base

È necessario aggiungere alla path di matlab, il percoso alla cartella [matlab](https://github.com/ilario-pierbattista/hasp-tracker/blob/master/matlab), includendo tutte le sottocartelle.

Modificare opportunamente il file [matlab/initEnvironment.m](https://github.com/ilario-pierbattista/hasp-tracker/blob/master/matlab/initEnvironment.m) configurando le path (fare riferimento ai commenti contenuti nel file).

## Compilazione della libreria di supporto
È presente una piccola libreria in C++ che implementa le funzionalità più critiche per quanto riguarda il consumo delle risorse (algoritmo di allenamento, calcolo delle features di haar, ecc...).

Tale libreria viene utilizzata nei file mex.
Ogni file mex implementa una funzione fruibile in Matlab, implementata in un linguaggio compilato (C/C++) o parzialmente compilato (Java).

### Requisiti
Sono necessari per la compilazione:

* [CMake](https://cmake.org/) (>= 3.2.0)
* Matlab (>= r2014)
* Gcc (o un equivalente compilatore supportato)

### Compilazione
La compilazione è testata solamente con GNU/Linux.

    $ cd hasp-tracker
    $ cmake .
    $ make

## Utilizzo
Nella cartella [matlab/procedures](https://github.com/ilario-pierbattista/hasp-tracker/tree/master/matlab/procedures) sono presenti tutti gli script eseguibili dall'utente finale.

Una breve descrizione del workflow standard è fornita nel file [matlab/procedures/workflow.txt](https://github.com/ilario-pierbattista/hasp-tracker/blob/master/matlab/procedures/workflow.txt).
Per ulteriori chiarimenti sui singoli passaggi, fare riferimento alla tesi.

In dettaglio:

* [__trainWithAdaboost.m__](https://github.com/ilario-pierbattista/hasp-tracker/blob/master/matlab/procedures/trainWithAdaboost.m): procedura di allenamento per l'estrazione dei classificatori forti
* [__evaluateClassifierThresholds.m__](https://github.com/ilario-pierbattista/hasp-tracker/blob/master/matlab/procedures/evaluateClassifierThresholds.m): procedura per la valutazione delle possibili soglie dei classificatori forti e regolazione di classificatori
* [__strongClassifierTuning.m__](https://github.com/ilario-pierbattista/hasp-tracker/blob/master/matlab/procedures/strongClassifierTuning.m): regolazione dei classificatori
* [__testAdaboost.m__](https://github.com/ilario-pierbattista/hasp-tracker/blob/master/matlab/procedures/testAdaboost.m): test delle prestazioni dei classificatori su dataset di testing
* [__detectHumanInFrames.m__](https://github.com/ilario-pierbattista/hasp-tracker/blob/master/matlab/procedures/detectHumanInFrames.m): rilevazione su registrazioni reali della presenza di persone
* [__showVideoFromFrames.m__](https://github.com/ilario-pierbattista/hasp-tracker/blob/master/matlab/procedures/showVideoFromFrames.m): costruzione di un _video di profondità_ a partire dai frames catturati con il Kinect
