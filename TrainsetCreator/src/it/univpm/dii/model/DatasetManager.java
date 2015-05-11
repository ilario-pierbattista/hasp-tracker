package it.univpm.dii.model;

import it.univpm.dii.model.entities.Element;
import it.univpm.dii.model.entities.TrainSet;

import javax.xml.crypto.Data;
import java.io.File;
import java.io.IOException;

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

    /**
     * Costruttore
     *
     * @param base
     */
    public DatasetManager(File base) throws Exception {
        instance = this;
        basepath = base;
        positivesDir = new File(base, POSITIVES_DIR);
        negativesDir = new File(base, NEGATIVES_DIR);

        if (!positivesDir.exists()) {
            positivesDir.mkdir();
        }
        if (!negativesDir.exists()) {
            negativesDir.mkdir();
        }

        trainSet = fetchTrainset();
    }

    /**
     * Ritorna l'istanza attiva di DatasetManager
     *
     * @return
     */
    public static DatasetManager getInstance() {
        return instance;
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
    public TrainSet fetchTrainset() {
        TrainSet ts = new TrainSet(basepath);
        File[] positives = positivesDir.listFiles();
        File[] negatives = negativesDir.listFiles();
        for (File pos : positives) {
            ts.add(createElement(pos));
        }
        for (File neg : negatives) {
            ts.add(createElement(neg));
        }
        return ts;
    }

    public Element find(int id) {
        return null;
    }

    public DatasetManager create(Element e) {
        return null;
    }

    public DatasetManager update(Element e) {
        return null;
    }

    public DatasetManager remove(Element e) {
        return null;
    }

    /**
     * Crea un elemento
     *
     * @param file
     * @return
     */
    private Element createElement(File file) {
        Element e = null;
        String[] parts = file.getName().split("_");
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
}
