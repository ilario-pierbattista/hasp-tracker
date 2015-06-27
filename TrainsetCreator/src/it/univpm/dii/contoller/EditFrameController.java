package it.univpm.dii.contoller;

import it.univpm.dii.model.DatasetManager;
import it.univpm.dii.model.entities.Element;
import it.univpm.dii.view.EditDialog;
import it.univpm.dii.view.MainFrame;

import javax.swing.*;
import javax.xml.crypto.Data;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.IOException;
import java.nio.file.NoSuchFileException;

/**
 * Created by ilario
 * on 27/06/15.
 */
public class EditFrameController {
    private EditDialog view;
    private Element element;

    public EditFrameController(Element element) {
        view = new EditDialog(element);
        this.element = element;
        view.getButtonOK().addActionListener(new OkButtonListener());
        view.setVisible(true);
    }

    class OkButtonListener implements ActionListener {
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
}
