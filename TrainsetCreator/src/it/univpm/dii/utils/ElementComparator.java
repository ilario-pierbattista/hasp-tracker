package it.univpm.dii.utils;

import it.univpm.dii.model.entities.Element;

import java.util.Comparator;

/**
 * Created by ilario
 * on 11/05/15.
 */
public class ElementComparator implements Comparator<Element> {
    public static final int BY_ID = 0;
    public static final int BY_WIDTH = 1;
    public static final int BY_HEIGHT = 2;
    public static final int BY_POSITIVE = 3;
    public static final int ASC = 0;
    public static final int DESC = 10;

    private int rule;
    private int order;

    /**
     * Costruttore di default (Comparazione per id)
     */
    public ElementComparator() {
        this.rule = BY_ID;
        this.order = ASC;
    }

    public ElementComparator(int rule, int order) {
        this.rule = rule;
        this.order = order;
    }

    @Override
    public int compare(Element o1, Element o2) {
        switch (rule + order) {
            case BY_ID + ASC:
                return o1.getId() - o2.getId();
            case BY_ID + DESC:
                return o2.getId() - o1.getId();
            case BY_WIDTH + ASC:
                return o1.getWidth() - o2.getWidth();
            case BY_WIDTH + DESC:
                return o2.getWidth() - o1.getWidth();
            case BY_HEIGHT + ASC:
                return o1.getHeight() - o2.getHeight();
            case BY_HEIGHT + DESC:
                return o2.getHeight() - o1.getHeight();
            case BY_POSITIVE + ASC:
                if (o1.isPositive() && !o2.isPositive()) {
                    return -1;
                } else if (!o1.isPositive() && o2.isPositive()) {
                    return 1;
                }
                return 0;
            case BY_POSITIVE + DESC:
                if (o1.isPositive() && !o2.isPositive()) {
                    return 1;
                } else if (!o1.isPositive() && o2.isPositive()) {
                    return -1;
                }
                return 0;
            default:
                return o1.getId() - o2.getId();
        }
    }
}
