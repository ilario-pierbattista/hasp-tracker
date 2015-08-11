package it.univpm.dii.view.component;

import it.univpm.dii.view.tablemodels.ElementModel;

import javax.swing.*;
import javax.swing.table.JTableHeader;
import javax.swing.table.TableColumnModel;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

/**
 * Created by ilario
 * on 12/05/15.
 */
public class SampleTable extends JTable {

    public SampleTable() {
        super(new ElementModel());
        ElementModel model = (ElementModel) this.getModel();
        SortButtonRenderer renderer = new SortButtonRenderer();
        TableColumnModel columnModel = this.getColumnModel();
        // Impostazione della selezione della singola riga
        getSelectionModel().setSelectionMode(ListSelectionModel.SINGLE_SELECTION);

        for (int i = 0; i < model.getColumnCount(); i++) {
            columnModel.getColumn(i).setHeaderRenderer(renderer);
        }

        JTableHeader header = this.getTableHeader();
        header.addMouseListener(new HeaderListener(header, renderer));
    }

    class HeaderListener extends MouseAdapter {
        private JTableHeader header;
        private SortButtonRenderer renderer;
        private ElementModel model;

        public HeaderListener(JTableHeader header, SortButtonRenderer renderer) {
            super();
            this.header = header;
            this.renderer = renderer;
            this.model = ((ElementModel) header.getTable().getModel());
        }

        public void mousePressed(MouseEvent e) {
            int col = header.columnAtPoint(e.getPoint());
            int sortCol = header.getTable().convertColumnIndexToModel(col);
            renderer.setPressedColumn(col);
            renderer.setSelectedColumn(col);
            header.repaint();

            if (header.getTable().isEditing()) {
                header.getTable().getCellEditor().stopCellEditing();
            }

            boolean isAscent = SortButtonRenderer.DOWN == renderer.getState(col);
            if (model.isDataSetted()) {
                model.sortByColumn(sortCol, isAscent);
            }
        }

        public void mouseReleased(MouseEvent e) {
            //int col = header.columnAtPoint(e.getPoint());
            renderer.setPressedColumn(-1);                // clear
            header.repaint();
        }
    }
}