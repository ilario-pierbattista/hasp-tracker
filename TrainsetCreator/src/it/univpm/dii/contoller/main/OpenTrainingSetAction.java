package it.univpm.dii.contoller.main;

import it.univpm.dii.model.DatasetManager;
import it.univpm.dii.view.MainFrame;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;

/**
 * Apertura di un trainset
 */
class OpenTrainingSetAction implements ActionListener {

    @Override
    public void actionPerformed(ActionEvent e) {
        File selected = MainController.openDirectoryChooser("Apri la cartella contenente il training set", MainController.DIRECTORY_NOT_EMPTY);
        MainController.setDatasetPath(selected);
        DatasetManager.newInstance(MainController.datasetPath);
        MainFrame.getInstance().refresh();
    }
}