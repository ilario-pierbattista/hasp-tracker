package it.univpm.dii.contoller.resize;

import it.univpm.dii.view.ResizeDialog;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

/**
 * Created by ilario
 * on 19/08/15.
 */
class CancelAction implements ActionListener {
    private ResizeDialog dialog;

    public CancelAction(ResizeDialog dialog) {
        this.dialog = dialog;
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        ResizeController controller = ResizeController.getInstance();
        if (controller.isResizeRunning()) {
            controller.setStopResizeAction(true);
        } else {
            dialog.dispose();
        }
    }
}
