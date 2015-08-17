package it.univpm.dii.contoller.addframe;

import it.univpm.dii.view.AddFrameView;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

/**
 * Gestore del checkbox per la generazione veloce di negativi
 */
class FastNegativesCheckedAction implements ActionListener {
    private AddFrameView view;

    public FastNegativesCheckedAction(AddFrameView view) {
        this.view = view;
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        JCheckBox b = (JCheckBox) e.getSource();
        if (b.isSelected()) {
            // Attivato
            view.getHumanCheckbox().setSelected(false);
            view.getHumanCheckbox().setEnabled(false);
            view.getXoffset().setEnabled(true);
            view.getYoffset().setEnabled(true);
        } else {
            // Disattivato
            view.getHumanCheckbox().setEnabled(true);
            view.getXoffset().setEnabled(false);
            view.getYoffset().setEnabled(false);
        }
    }
}
