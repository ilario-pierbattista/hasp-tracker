package it.univpm.dii.contoller.addframe;

import it.univpm.dii.view.AddFrameView;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

/**
 * Selezione quadrata
 */
class SquareSelectionCheckedAction implements ActionListener {
    private AddFrameView view;

    public SquareSelectionCheckedAction(AddFrameView view) {
        this.view = view;
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        JCheckBox b = (JCheckBox) e.getSource();
        if (b.isSelected()) {
            String dim = view.getCropHeight().getText();
            if (dim.isEmpty()) {
                dim = view.getCropWidth().getText();
            }
            view.setSquareCropArea(dim);
            view.getCropWidth().setEnabled(false);
        } else {
            view.getCropWidth().setEnabled(true);
        }
        AddFrameController.updateCropDimensions(view);
    }
}