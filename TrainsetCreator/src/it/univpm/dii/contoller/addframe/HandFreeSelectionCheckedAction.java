package it.univpm.dii.contoller.addframe;

import it.univpm.dii.view.AddFrameView;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

/**
 * Selezione a mano libera
 */
class HandFreeSelectionCheckedAction implements ActionListener {
    private AddFrameView view;

    public HandFreeSelectionCheckedAction(AddFrameView view) {
        this.view = view;
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        JCheckBox b = (JCheckBox) e.getSource();
        if (b.isSelected()) {
            view.setCropWidthValue("0");
            view.setCropHeightValue("0");
            view.getCropWidth().setEnabled(false);
            view.getCropHeight().setEnabled(false);
        } else {
            AddFrameController.setCropPreference(view);
            view.getCropHeight().setEnabled(true);
            view.getCropWidth().setEnabled(true);
            view.setCropHeightValue(Integer.toString(view.getImagePanel().getRectangle().height));
            view.setCropWidthValue(Integer.toString(view.getImagePanel().getRectangle().width));
        }
        AddFrameController.updateCropDimensions(view);
    }
}