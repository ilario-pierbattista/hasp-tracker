package it.univpm.dii.contoller.main;

import it.univpm.dii.model.entities.Element;
import it.univpm.dii.view.MainFrame;

import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;
import java.io.IOException;

/**
 * Created by ilario
 * on 12/08/15.
 */
class SampleSelectedAction implements ListSelectionListener {
    private MainFrame view = MainFrame.getInstance();

    @Override
    public void valueChanged(ListSelectionEvent e) {
        if (!e.getValueIsAdjusting()) {
            Element element = view.getSelectedElement();
            if (element != null) {
                view.enableEdit(true);
                try {
                    view.updatePreviewPanel(element);
                } catch (IOException ee) {
                    ee.printStackTrace();
                }
            } else {
                view.enableEdit(false);
            }
        }
    }
}