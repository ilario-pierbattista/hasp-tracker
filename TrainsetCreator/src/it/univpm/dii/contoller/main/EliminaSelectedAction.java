package it.univpm.dii.contoller.main;

import it.univpm.dii.model.DatasetManager;
import it.univpm.dii.model.entities.Element;
import it.univpm.dii.view.MainFrame;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.IOException;
import java.nio.file.NoSuchFileException;

/**
 * Aziona l'eliminazione
 */
class EliminaSelectedAction implements ActionListener {
    private MainFrame view = MainFrame.getInstance();

    @Override
    public void actionPerformed(ActionEvent e) {
        try {
            DatasetManager dm = DatasetManager.getInstance();
            Element element = view.getSelectedElement();
            dm.remove(element);
            view.removeElement(element);
        } catch (NoSuchFileException ee) {
            JOptionPane.showMessageDialog(view.frame,
                    "Nessun file trovato: " + ee.getMessage(),
                    ee.getClass().getName(),
                    JOptionPane.ERROR_MESSAGE);
        } catch (IOException ee) {
            JOptionPane.showMessageDialog(view.frame,
                    ee.getMessage(),
                    ee.getClass().getName(),
                    JOptionPane.ERROR_MESSAGE);
        }
    }
}