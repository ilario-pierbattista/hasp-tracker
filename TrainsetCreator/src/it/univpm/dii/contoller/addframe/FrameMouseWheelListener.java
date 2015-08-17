package it.univpm.dii.contoller.addframe;

import it.univpm.dii.view.AddFrameView;

import javax.swing.*;
import java.awt.event.MouseWheelEvent;
import java.awt.event.MouseWheelListener;

/**
 * Permette di scorrere i frame utilizzando la rotella del mouse
 */
class FrameMouseWheelListener implements MouseWheelListener {
    private JSlider slider;

    FrameMouseWheelListener(AddFrameView view) {
        this.slider = view.getSlider();
    }

    @Override
    public void mouseWheelMoved(MouseWheelEvent e) {
        int notches = e.getWheelRotation();
        slider.setValue(slider.getValue() + notches);
    }
}
