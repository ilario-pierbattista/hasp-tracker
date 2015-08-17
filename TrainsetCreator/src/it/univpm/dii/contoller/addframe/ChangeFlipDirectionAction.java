package it.univpm.dii.contoller.addframe;

import it.univpm.dii.view.AddFrameView;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

/**
 * Imposta la direzione del flipping dell'immagine
 */
class ChangeFlipDirectionAction implements ActionListener {
    private AddFrameView view;

    public ChangeFlipDirectionAction(AddFrameView view) {
        this.view = view;
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        view.getImagePanel().setFlipDirection(
                Integer.parseInt(e.getActionCommand())
        );
    }
}