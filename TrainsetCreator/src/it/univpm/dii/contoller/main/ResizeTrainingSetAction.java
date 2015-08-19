package it.univpm.dii.contoller.main;

import it.univpm.dii.contoller.resize.ResizeController;
import it.univpm.dii.view.MainFrame;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

/**
 * Created by ilario
 * on 17/08/15.
 */
public class ResizeTrainingSetAction implements ActionListener {
    @Override
    public void actionPerformed(ActionEvent e) {
        new ResizeController();
    }
}
