package it.univpm.dii.model.entities;

import it.univpm.dii.utils.ElementEqualityPredicate;

import java.io.File;
import java.util.ArrayList;

/**
 * Created by ilario
 * on 01/05/15.
 */
public class TrainSet {
    private File basePath;
    private ArrayList<Element> positives;
    private ArrayList<Element> negatives;

    /**
     * @param basePath
     */
    public TrainSet(File basePath) {
        this.basePath = basePath;
        positives = new ArrayList<Element>(30);
        negatives = new ArrayList<Element>(30);
    }

    /**
     * Aggiunge un elemento
     *
     * @param e
     * @return
     */
    public TrainSet add(Element e) {
        if (e == null) {
            return this;
        } else if (e.isPositive()) {
            positives.add(e);
        } else {
            negatives.add(e);
        }
        return this;
    }

    public TrainSet changePositiveness(Element element, boolean newVal) {
        if (element.isPositive()) {
            positives.removeIf(new ElementEqualityPredicate(element));
        } else {
            negatives.removeIf(new ElementEqualityPredicate(element));
        }
        element.setPositive(newVal);
        add(element);
        return this;
    }

    public TrainSet remove(Element e) {
        if (e.isPositive()) {
            positives.removeIf(new ElementEqualityPredicate(e));
        } else {
            negatives.removeIf(new ElementEqualityPredicate(e));
        }
        return this;
    }

    public File getBasePath() {
        return basePath;
    }

    public ArrayList<Element> getPositives() {
        return positives;
    }

    public ArrayList<Element> getNegatives() {
        return negatives;
    }

    @Override
    public String toString() {
        return "TrainSet{" +
                "basePath=" + basePath +
                ", positives=" + positives +
                ", negatives=" + negatives +
                '}';
    }
}