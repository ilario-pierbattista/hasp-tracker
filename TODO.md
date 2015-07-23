### TODO List
* Completare i dataset di allenamento per i 4 classificatori forti
* Scegliere l'algoritmo di ridimensionamento delle immagini
* Preparare un dataset di testing (Raggiungere le dimensioni di un dataset di allenamento)
* Cambiare le modalità di valutazione delle prestazioni dell'algoritmo in termini di sensitivity, specificity, accurancy
* Consultare *An Analysis of the Viola-Jones face detection algorithm* per affrontare il problema dell'overlapping in fase di riconoscimento
* Consultare *Robust real time face detection 2004* per costruire i classificatori a cascata.
* Filtro di Kalman?

### Tuning dell'algoritmo

#### Scelta di theta
Sul dataset di **testing**, scegliere la soglia che meglio classifica le immagini.

#### Scelta di T
Costruire un classificatore forte molto grande. Successivamente valutare le prestazioni di ogni sottoclassificatore da esso estraibile su un dataset di **testing**.

#### Approccio sperimentale
Costruire una griglia di coppie (T, theta) contenente gli indici di prestazione dell'algoritmo. Scegliere la coppia migliore.
