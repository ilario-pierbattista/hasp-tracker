# Utilizzo
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
