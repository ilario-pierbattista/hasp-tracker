package it.univpm.dii.view;

import javax.swing.*;

/**
 * Created by ilario
 * on 02/05/15.
 */
abstract class View {
    public JFrame frame;

    public void setVisible(boolean visible) {
        frame.setVisible(visible);
    }

    public abstract void refresh();
}
