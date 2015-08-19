package it.univpm.dii.model;

import it.univpm.dii.model.entities.Element;
import it.univpm.dii.model.entities.TrainingSet;
import it.univpm.dii.utils.ElementComparator;

import java.awt.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.DirectoryNotEmptyException;
import java.nio.file.Files;
import java.util.ArrayList;

/**
 * Si occupa della gestione di un dataset.
 * Classe singleton.
 */
public class DatasetManager {
    public static final String POSITIVES_DIR = "positives";
    public static final String NEGATIVES_DIR = "negatives";
    private static DatasetManager instance;
    private TrainingSet trainingSet;
    private File basepath;
    private File negativesDir;
    private File positivesDir;
    private int nextIdAvailable;

    /**
     * Costruttore
     *
     * @param base Directory contenente il dataset di allenamento.
     */
    public DatasetManager(File base) throws Exception {
        boolean directoriesReady;   // Flag di controllo della creazione delle directory
        instance = this;
        basepath = base;
        // Registrazione ed eventuale creazione delle cartelle
        positivesDir = new File(base, POSITIVES_DIR);
        negativesDir = new File(base, NEGATIVES_DIR);

        directoriesReady = positivesDir.exists();
        if (!directoriesReady) {
            directoriesReady = positivesDir.mkdir();
        } // Se tutto va bene, a questo è true

        directoriesReady = directoriesReady && negativesDir.exists();
        if (!directoriesReady) {
            directoriesReady = negativesDir.mkdir();
        } // Se tutto va bene, è true

        if (directoriesReady) {
            // Fetch delle informazioni del trainset
            fetchTrainset();
        } else {
            throw new IOException("Errore nel setup delle directory");
        }
    }

    /**
     * Ritorna l'istanza attiva di DatasetManager
     *
     * @return Istanza di {@link DatasetManager}.
     */
    public static DatasetManager getInstance() {
        return instance;
    }

    public TrainingSet getTrainingSet() {
        return trainingSet;
    }

    /**
     * Crea una nuova istanza
     *
     * @param basepath Directory che contiene i dati del dataset.
     * @return Istanza di {@link DatasetManager}.
     */
    public static DatasetManager newInstance(File basepath) {
        try {
            new DatasetManager(basepath);
        } catch (Exception ee) {
            ee.printStackTrace();
        }
        return instance;
    }

    /**
     * Fetch del dataset
     */
    private void fetchTrainset() {
        ArrayList<Element> elements = new ArrayList<>(60);
        Element current;
        trainingSet = new TrainingSet(basepath);

        File[] positives = positivesDir.listFiles();
        File[] negatives = negativesDir.listFiles();
        nextIdAvailable = 1;

        if (positives != null) {
            for (File pos : positives) {
                current = createElement(pos);
                if (current != null) {
                    elements.add(current);
                }
            }
        }
        if (negatives != null) {
            for (File neg : negatives) {
                current = createElement(neg);
                if (current != null) {
                    elements.add(current);
                }
            }
        }
        elements.sort(new ElementComparator());
        if (elements.isEmpty()) {
            nextIdAvailable = 1;
        } else {
            nextIdAvailable = elements.get(elements.size() - 1).getId() + 1;
        }
        elements.forEach(trainingSet::add);
    }

    /**
     * Ritorna un elemento cercandolo tramite id
     *
     * @param id Id dell'elemento.
     * @return Elemento trovato oppure null.
     */
    public Element find(int id) {
        ArrayList<Element> pos = trainingSet.getPositives();
        ArrayList<Element> neg = trainingSet.getNegatives();
        for (Element e : pos) {
            if (e.getId() == id) return e;
        }
        for (Element e : neg) {
            if (e.getId() == id) return e;
        }
        return null;
    }

    /**
     * Creazione di un elemento in tabella
     *
     * @param e Elemento da inserire.
     * @return Istanza di {@link DatasetManager}.
     */
    public DatasetManager create(Element e) {
        e.setId(nextIdAvailable);
        trainingSet.add(e);
        nextIdAvailable++;
        return this;
    }

    /**
     * Cambia la classificazione di un elemento
     *
     * @param e      Elemento
     * @param newVal Nuova classificazione
     * @return Istanza di {@link DatasetManager} per il method chaining
     * @throws IOException Lanciata nel caso in cui l'elemento non venga trovato
     *                     nella directory
     */
    public DatasetManager changePositive(Element e, boolean newVal)
            throws IOException {
        try {
            File oldFile = new File(e.getFileName()), targetFile;
            trainingSet.changePositiveness(e, newVal);
            generateFilename(e);
            targetFile = new File(e.getFileName());
            Files.copy(oldFile.toPath(), targetFile.toPath());
            Files.delete(oldFile.toPath());
        } catch (DirectoryNotEmptyException ee) {
            ee.printStackTrace();
        }
        return this;
    }

    /**
     * Rimuove un elemento dal dataset di allenamento.
     *
     * @param e Elemento da rimuovere.
     * @return Istanza di {@link DatasetManager}.
     * @throws IOException Lanciata nel caso in cui l'elemento non venga trovato
     *                     nella rispettiva directory.
     */
    public DatasetManager remove(Element e)
            throws IOException {
        try {
            File elementFile = new File(e.getFileName());
            Files.delete(elementFile.toPath());
        } catch (DirectoryNotEmptyException ee) {
            ee.printStackTrace();
        }
        trainingSet.remove(e);
        return this;
    }

    /**
     * Crea un elemento del dataset di allenamento a partire dal
     * file che lo rappresenta nella struttura delle directory.
     *
     * @param file File dell'elemento.
     * @return Elemento creato.
     */
    private Element createElement(File file) {
        Element e = null;
        // Separazione del nome del file dalla sua estensione
        String[] fileNameParts = file.getName().split("\\.");   // <- split prende come argomento un'espressione regolare
        if (fileNameParts.length < 2) {
            return null;
        }
        // Analisi del nome del file (senza l'estensione)
        String[] parts = fileNameParts[0].split("_");
        if (parts.length == 7) {
            e = new Element();
            e.setFileName(file.getAbsolutePath())
                    .setId(Integer.parseInt(parts[1]))
                    .setWidth(Integer.parseInt(parts[2]))
                    .setHeight(Integer.parseInt(parts[3]))
                    .setPositive(Boolean.parseBoolean(parts[4]))
                    .setX(Integer.parseInt(parts[5]))
                    .setY(Integer.parseInt(parts[6]));
        } else if(parts.length == 5) {
            e = new Element();
            e.setFileName(file.getAbsolutePath())
                    .setId(Integer.parseInt(parts[1]))
                    .setWidth(Integer.parseInt(parts[2]))
                    .setHeight(Integer.parseInt(parts[3]))
                    .setPositive(Boolean.parseBoolean(parts[4]))
                    .setX(0)
                    .setY(0);
        }
        return e;
    }

    /**
     * Genera il nome del file
     *
     * @param e Elemento di cui generare il nome del file.
     * @return Istanza di {@link DatasetManager}.
     */
    public DatasetManager generateFilename(Element e) {
        return this.generateFilename(e, this.positivesDir, this.negativesDir);
    }

    /**
     * Genera ed assegna il nome del file
     *
     * @param e            Elemento per cui generare il nome del file.
     * @param positivesDir Cartella degli esempi positivi.
     * @param negativesDir Cartella degli esempi negativi.
     * @return Istanza di {@link DatasetManager}.
     */
    public DatasetManager generateFilename(Element e, File positivesDir, File negativesDir) {
        String filename = "sample_" + e.getId() +
                "_" + e.getWidth() +
                "_" + e.getHeight() +
                "_" + Boolean.toString(e.isPositive()) +
                "_" + e.getX() +
                "_" + e.getY() +
                ".bin";
        if (e.isPositive()) {
            e.setFileName(new File(positivesDir, filename).getAbsolutePath());
        } else {
            e.setFileName(new File(negativesDir, filename).getAbsolutePath());
        }
        return this;
    }

    /**
     * Restituisce la path di un resize del dataset.
     *
     * @param basepath Path di base.
     * @param dims     Dimensioni del resize.
     * @return Path del resize (non necessariamente esistente).
     */
    static public File getResizeBasePath(File basepath, Dimension dims) {
        String folderName = Integer.toString(dims.width)
                .concat("_")
                .concat(Integer.toString(dims.height));
        return new File(basepath, folderName);
    }

    static public File getPositivesPath(File basepath) {
        return new File(basepath, POSITIVES_DIR);
    }

    static public File getNegativesPath(File basepath) {
        return new File(basepath, NEGATIVES_DIR);
    }
}
