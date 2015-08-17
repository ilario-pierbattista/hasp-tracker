package it.univpm.dii.contoller.main;

import it.univpm.dii.contoller.addframe.AddFrameController;
import it.univpm.dii.contoller.framerender.FrameRenderController;
import it.univpm.dii.exception.EmptyFrameDirException;
import it.univpm.dii.view.MainFrame;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;

/**
 * Aggiunta di un frame al trainset
 */
class AddFrameAction implements ActionListener {
    private MainFrame view = MainFrame.getInstance();

    @Override
    public void actionPerformed(ActionEvent e) {
        File selected;
        boolean flag = true;
        do {
            selected = MainController.openDirectoryChooser("Apri la cartella con i frame", MainController.DIRECTORY_NOT_EMPTY);
            try {
                new FrameRenderController(selected);
                flag = false;
            } catch (EmptyFrameDirException ee) {
                JOptionPane.showMessageDialog(view.frame,
                        ee.getMessage(),
                        "Errore di IO",
                        JOptionPane.ERROR_MESSAGE);
            }
        } while (flag);
    }
}