package it.univpm.dii.contoller.main;

import it.univpm.dii.model.DatasetManager;
import it.univpm.dii.view.MainFrame;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;

/**
 * Creazione di un nuovo trainset
 */
class NewTrainingSetAction implements ActionListener {

    @Override
    public void actionPerformed(ActionEvent e) {
        File selected = MainController.openDirectoryChooser("Scegliere la directory di destinazione", MainController.DIRECTORY_EMPTY);
        MainController.setDatasetPath(selected);
        DatasetManager.newInstance(MainController.datasetPath);
        MainFrame.getInstance().refresh();
    }
}
