package it.univpm.dii.contoller.framerender;

import it.univpm.dii.view.FrameRenderView;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

/**
 * Chiusura della dialog per le dimensioni
 */
class IndietroRenderInfoAction implements ActionListener {
    private FrameRenderView view;

    public IndietroRenderInfoAction(FrameRenderView view) {
        this.view = view;
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        view.frame.dispose();
    }
}
