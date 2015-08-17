package it.univpm.dii.contoller.addframe;

import it.univpm.dii.view.AddFrameView;

import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;

/**
 * Cambiamento delle dimensioni dell'area da tagliare
 */
class DimCropChangeAction implements PropertyChangeListener {
    private AddFrameView view;

    public DimCropChangeAction(AddFrameView view) {
        this.view = view;
    }

    @Override
    public void propertyChange(PropertyChangeEvent evt) {
        AddFrameController.updateCropDimensions(view);
    }
}

