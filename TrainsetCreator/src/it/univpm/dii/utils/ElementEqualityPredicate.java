package it.univpm.dii.utils;

import it.univpm.dii.model.entities.Element;

import java.util.function.Predicate;

/**
 * Created by ilario
 * on 27/06/15.
 */
public class ElementEqualityPredicate implements Predicate<Element> {
    private Element leftOperand;

    public ElementEqualityPredicate(Element element) {
        leftOperand = element;
    }

    @Override
    public boolean test(Element rightOperand) {
        return leftOperand.equals(rightOperand);
    }
}
