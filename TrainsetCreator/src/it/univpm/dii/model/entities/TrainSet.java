package it.univpm.dii.model.entities;

import java.util.ArrayList;

/**
 * Created by ilario
 * on 01/05/15.
 */
public class TrainSet {

    protected int id;
    private ArrayList<Element> elements;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public ArrayList<Element> getElements() {
        return elements;
    }

    public TrainSet addElement(Element element) {
        elements.add(element);
        return this;
    }

    public void setElements(ArrayList<Element> elements) {
        this.elements = elements;
    }
}
