package it.univpm.dii.contoller.main;

import it.univpm.dii.model.DatasetManager;
import it.univpm.dii.view.MainFrame;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;

/**
 * Apertura di un trainset recente
 */
class OpenRecentAction implements ActionListener {
    @Override
    public void actionPerformed(ActionEvent e) {
        File path = new File(e.getActionCommand());
        MainController.setDatasetPath(path);
        DatasetManager.newInstance(MainController.datasetPath);
        MainFrame.getInstance().refresh();
    }
}