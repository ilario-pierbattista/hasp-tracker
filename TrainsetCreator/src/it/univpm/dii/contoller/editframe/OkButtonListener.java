package it.univpm.dii.contoller.editframe;

import it.univpm.dii.model.DatasetManager;
import it.univpm.dii.model.entities.Element;
import it.univpm.dii.view.EditDialog;
import it.univpm.dii.view.MainFrame;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.IOException;
import java.nio.file.NoSuchFileException;

class OkButtonListener implements ActionListener {
    private EditDialog view;
    private Element element;

    public OkButtonListener(EditDialog view, Element element) {
        this.view = view;
        this.element = element;
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        System.out.println(view.getNewPositiveness());
        if (view.getNewPositiveness() != element.isPositive()) {
            // Aggiornare il training set, spostare il file
            try {
                DatasetManager dm = DatasetManager.getInstance();
                dm.changePositive(element, view.getNewPositiveness());
                MainFrame.getInstance().updateElement(element);
            } catch (NoSuchFileException ee) {
                JOptionPane.showMessageDialog(view,
                        "Nessun file trovato: " + ee.getMessage(),
                        ee.getClass().getName(),
                        JOptionPane.ERROR_MESSAGE);
            } catch (IOException ee) {
                JOptionPane.showMessageDialog(view,
                        ee.getMessage(),
                        ee.getClass().getName(),
                        JOptionPane.ERROR_MESSAGE);
            }
        }
        view.dispose();
    }
}