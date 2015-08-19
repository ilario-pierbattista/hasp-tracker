package it.univpm.dii.model.entities;

import it.univpm.dii.utils.ElementEqualityPredicate;

import javax.lang.model.element.ElementKind;
import java.io.File;
import java.util.ArrayList;

/**
 * Created by ilario
 * on 01/05/15.
 */
public class TrainingSet {
    private File basePath;
    private ArrayList<Element> positives;
    private ArrayList<Element> negatives;

    /**
     * Creazione del training set
     *
     * @param basePath Path che contiene i dati di allenamento.
     */
    public TrainingSet(File basePath) {
        this.basePath = basePath;
        positives = new ArrayList<Element>(30);
        negatives = new ArrayList<Element>(30);
    }

    /**
     * Aggiunge un elemento al dataset.
     *
     * @param e Elemento da aggiungere.
     * @return Istanza di {@link TrainingSet}
     */
    public TrainingSet add(Element e) {
        if (e == null) {
            return this;
        } else if (e.isPositive()) {
            positives.add(e);
        } else {
            negatives.add(e);
        }
        return this;
    }

    /**
     * Cambia la classificazione di elemento del dataset.
     *
     * @param element Elemento di cui cambiare la classificazione.
     * @param newVal  Nuova classificazione.
     * @return Istanza di {@link TrainingSet}
     */
    public TrainingSet changePositiveness(Element element, boolean newVal) {
        if (element.isPositive()) {
            positives.removeIf(new ElementEqualityPredicate(element));
        } else {
            negatives.removeIf(new ElementEqualityPredicate(element));
        }
        element.setPositive(newVal);
        add(element);
        return this;
    }

    /**
     * Rimuove un elemento dal dataset.
     *
     * @param e Elemento da rimuovere
     * @return Istanza di {@link TrainingSet}
     */
    public TrainingSet remove(Element e) {
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

    /**
     * Restituisce tutti gli elementi del dataset
     *
     * @return Lista di elementi del dataset
     */
    public ArrayList<Element> getElements() {
        ArrayList<Element> elementList = new ArrayList<>(positives.size() + negatives.size());
        elementList.addAll(positives);
        elementList.addAll(negatives);
        return elementList;
    }

    /**
     * Ritorna tutti gli elementi classificati positivi.
     *
     * @return Lista di tutti gli elementi classificati positivi.
     */
    public ArrayList<Element> getPositives() {
        return positives;
    }

    /**
     * Ritorna tutti gli elementi classificati negativi.
     *
     * @return Lista di tutti gli elementi classificati negativi.
     */
    public ArrayList<Element> getNegatives() {
        return negatives;
    }

    @Override
    public String toString() {
        return "TrainingSet{" +
                "basePath=" + basePath +
                ", positives=" + positives +
                ", negatives=" + negatives +
                '}';
    }
}