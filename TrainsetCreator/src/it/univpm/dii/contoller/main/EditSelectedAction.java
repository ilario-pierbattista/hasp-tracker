package it.univpm.dii.contoller.main;

import it.univpm.dii.contoller.editframe.EditFrameController;
import it.univpm.dii.view.MainFrame;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

/**
 * Aziona la modifica
 */
class EditSelectedAction implements ActionListener {
    private MainFrame view = MainFrame.getInstance();

    @Override
    public void actionPerformed(ActionEvent e) {
        new EditFrameController(view.getSelectedElement());
    }
}