package it.univpm.dii.contoller.addframe;

import it.univpm.dii.view.AddFrameView;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

/**
 * Chiusura
 */
class FineAction implements ActionListener {
    private AddFrameView view;

    public FineAction(AddFrameView view) {
        this.view = view;
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        view.frame.dispose();
    }
}