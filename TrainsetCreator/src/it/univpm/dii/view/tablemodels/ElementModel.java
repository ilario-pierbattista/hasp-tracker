package it.univpm.dii.view.tablemodels;

import it.univpm.dii.model.entities.Element;
import it.univpm.dii.model.entities.TrainSet;
import it.univpm.dii.utils.ElementComparator;

import javax.swing.table.AbstractTableModel;
import java.util.ArrayList;

/**
 * Created by ilario
 * on 11/05/15.
 */
public class ElementModel extends AbstractTableModel {

    private ArrayList<Element> elements;
    String[] header = {"Id", "Width", "Height", "Positive"};
    int[] sorterMapper = {
            ElementComparator.BY_ID,
            ElementComparator.BY_WIDTH,
            ElementComparator.BY_HEIGHT,
            ElementComparator.BY_POSITIVE
    };

    /**
     * Imposta i dati nel model della tabella
     *
     * @param set Oggetto che modella il training set
     * @return L'istanza di ElementModel
     */
    public ElementModel setData(TrainSet set) {
        elements = new ArrayList<>(60);
        elements.addAll(set.getPositives());
        elements.addAll(set.getNegatives());
        elements.sort(new ElementComparator());
        fireTableDataChanged();
        return this;
    }

    /**
     * Permette di sapere se il model della tabella è stato popolato
     * @return True se il model è stato popolato, false altrimenti
     */
    public boolean isDataSetted() {
        return elements != null;
    }

    /**
     * Effettua l'ordinamento dei dati
     *
     * @param col   Colonna in base al quale effettuare l'ordinamento
     * @param isAsc Ordinamento crescente o descrescente
     */
    public void sortByColumn(int col, boolean isAsc) {
        elements.sort(new ElementComparator(
                sorterMapper[col],
                isAsc ? ElementComparator.ASC : ElementComparator.DESC
        ));
        fireTableDataChanged();
    }

    @Override
    public int getRowCount() {
        if(elements == null) {
            return 0;
        }
        return elements.size();
    }

    @Override
    public int getColumnCount() {
        return header.length;
    }

    @Override
    public String getColumnName(int column) {
        return header[column];
    }

    @Override
    public Object getValueAt(int rowIndex, int columnIndex) {
        Element e = elements.get(rowIndex);
        switch (columnIndex) {
            case 0:
                return e.getId();
            case 1:
                return e.getWidth();
            case 2:
                return e.getHeight();
            case 3:
                return e.isPositive();
            case 4:
                return e.getFileName();
            default:
                return null;
        }
    }

    public Element getRow(int i) {
        return elements.get(i);
    }
}
