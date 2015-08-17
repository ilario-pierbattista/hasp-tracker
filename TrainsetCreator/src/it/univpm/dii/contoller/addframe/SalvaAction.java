package it.univpm.dii.contoller.addframe;

import it.univpm.dii.model.DatasetManager;
import it.univpm.dii.model.entities.Element;
import it.univpm.dii.view.AddFrameView;
import it.univpm.dii.view.MainFrame;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;

/**
 * Salvataggio della porzione di frame
 */
class SalvaAction implements ActionListener {
    private AddFrameView view;

    public SalvaAction(AddFrameView view) {
        this.view = view;
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        DatasetManager dm = DatasetManager.getInstance();
        Element element = view.getData();
        dm.create(element);
        // La generazione del nome deve essere lanciata dopo il create
        // altrimenti l'id non viene assegnato
        DatasetManager.getInstance().generateFilename(element);
        view.getImagePanel().cropAndSave(new File(element.getFileName()));
        MainFrame.getInstance().addElement(element);
    }
}