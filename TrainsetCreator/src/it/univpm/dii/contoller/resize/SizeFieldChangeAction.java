package it.univpm.dii.contoller.resize;

import it.univpm.dii.view.ResizeDialog;

import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;

/**
 * Created by ilario
 * on 17/08/15.
 *
 * @TODO Le transizioni non funzionano benissimo, controllare
 */
class SizeFieldChangeAction implements PropertyChangeListener {
    private ResizeDialog dialog;

    public SizeFieldChangeAction(ResizeDialog dialog) {
        this.dialog = dialog;
    }

    @Override
    public void propertyChange(PropertyChangeEvent evt) {
        int width, height;
        width = dialog.getWidthScaleField().getValue() == null ?
                0 : Integer.parseInt(dialog.getWidthScaleField().getText());
        height = dialog.getHeightScaleField().getValue() == null ?
                0 : Integer.parseInt(dialog.getHeightScaleField().getText());
        if (width > 0 && height > 0) {
            dialog.getButtonOK().setEnabled(true);
            dialog.getStatusLabel().setText("Selezionare l'algoritmo di resampling");
        } else {
            dialog.getButtonOK().setEnabled(false);
            dialog.getStatusLabel().setText("Selezionare una dimensione valida");
        }
    }
}
