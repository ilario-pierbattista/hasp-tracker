package it.univpm.dii.contoller.addframe;

import it.univpm.dii.view.AddFrameView;

import javax.swing.*;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;

/**
 * Cambiamento dello slider
 */
class SliderChangedAction implements ChangeListener {
    private AddFrameView view;

    public SliderChangedAction(AddFrameView view) {
        this.view = view;
    }

    @Override
    public void stateChanged(ChangeEvent e) {
        JSlider slider = (JSlider) e.getSource();
        int newCursor = slider.getValue();
        view.setCurrent(newCursor);
        view.refresh();
    }
}