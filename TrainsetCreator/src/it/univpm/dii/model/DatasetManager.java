package it.univpm.dii.model;

import it.univpm.dii.model.entities.Element;
import it.univpm.dii.model.entities.TrainSet;
import it.univpm.dii.utils.ElementComparator;

import java.io.File;
import java.io.IOException;
import java.nio.file.DirectoryNotEmptyException;
import java.nio.file.Files;
import java.util.ArrayList;

/**
 * Created by ilario
 * on 11/05/15.
 */
public class DatasetManager {
    public static final String POSITIVES_DIR = "positives";
    public static final String NEGATIVES_DIR = "negatives";
    private static DatasetManager instance;
    private TrainSet trainSet;
    private File basepath;
    private File negativesDir;
    private File positivesDir;
    private int nextIdAvailable;

    /**
     * Costruttore
     *
     * @param base
     */
    public DatasetManager(File base) throws Exception {
        instance = this;
        basepath = base;
        // Registrazione ed eventuale creazione delle cartelle
        positivesDir = new File(base, POSITIVES_DIR);
        negativesDir = new File(base, NEGATIVES_DIR);
        if (!positivesDir.exists()) {
            positivesDir.mkdir();
        }
        if (!negativesDir.exists()) {
            negativesDir.mkdir();
        }
        // Fetch delle informazioni del trainset
        fetchTrainset();
    }

    /**
     * Ritorna l'istanza attiva di DatasetManager
     *
     * @return
     */
    public static DatasetManager getInstance() {
        return instance;
    }

    public TrainSet getTrainSet() {
        return trainSet;
    }

    /**
     * Crea una nuova istanza
     *
     * @param basepath
     * @return
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
     *
     * @return
     */
    private void fetchTrainset() {
        ArrayList<Element> elements = new ArrayList<Element>(60);
        File[] positives = positivesDir.listFiles();
        File[] negatives = negativesDir.listFiles();
        Element current = null;
        trainSet = new TrainSet(basepath);
        nextIdAvailable = 1;

        for (File pos : positives) {
            current = createElement(pos);
            if (current != null) {
                elements.add(current);
            }
        }
        for (File neg : negatives) {
            current = createElement(neg);
            if (current != null) {
                elements.add(current);
            }
        }
        elements.sort(new ElementComparator());
        if (elements.isEmpty()) {
            nextIdAvailable = 1;
        } else {
            nextIdAvailable = elements.get(elements.size() - 1).getId() + 1;
        }
        elements.forEach((e) -> {
            trainSet.add(e);
        });
    }

    /**
     * Ritorna un elemento cercandolo tramite id
     *
     * @param id
     * @return
     */
    public Element find(int id) {
        ArrayList<Element> pos = trainSet.getPositives();
        ArrayList<Element> neg = trainSet.getNegatives();
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
     * @param e
     * @return
     */
    public DatasetManager create(Element e) {
        e.setId(nextIdAvailable);
        trainSet.add(e);
        nextIdAvailable++;
        return this;
    }

    public DatasetManager changePositive(Element e, boolean newVal)
            throws IOException
    {
        try {
            File oldFile = new File(e.getFileName()), targetFile;
            trainSet.changePositiveness(e, newVal);
            generateFilename(e);
            targetFile = new File(e.getFileName());
            Files.copy(oldFile.toPath(), targetFile.toPath());
            Files.delete(oldFile.toPath());
        } catch (DirectoryNotEmptyException ee) {
            ee.printStackTrace();
        }
        return this;
    }

    public DatasetManager remove(Element e)
            throws IOException {
        try {
            File elementFile = new File(e.getFileName());
            Files.delete(elementFile.toPath());
        } catch (DirectoryNotEmptyException ee) {
            ee.printStackTrace();
        }
        trainSet.remove(e);
        return this;
    }

    public DatasetManager flush() {
        return this;
    }

    /**
     * Crea un elemento
     *
     * @param file
     * @return
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
        if (parts.length == 5) {
            e = new Element();
            e.setFileName(file.getAbsolutePath())
                    .setId(Integer.parseInt(parts[1]))
                    .setWidth(Integer.parseInt(parts[2]))
                    .setHeight(Integer.parseInt(parts[3]))
                    .setPositive(Boolean.parseBoolean(parts[4]));
        }
        return e;
    }

    /**
     * Genera il nome del file
     *
     * @param e
     * @return
     */
    public DatasetManager generateFilename(Element e) {
        String filename = "sample_" + e.getId() +
                "_" + e.getWidth() +
                "_" + e.getHeight() +
                "_" + Boolean.toString(e.isPositive()) +
                ".bin";
        if (e.isPositive()) {
            e.setFileName(new File(positivesDir, filename).getAbsolutePath());
        } else {
            e.setFileName(new File(negativesDir, filename).getAbsolutePath());
        }
        return this;
    }
}
