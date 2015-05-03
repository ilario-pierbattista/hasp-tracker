package it.univpm.dii.view;

import it.univpm.dii.service.DepthImage;
import it.univpm.dii.view.component.DepthImagePanel;

import javax.swing.*;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

/**
 * Created by ilario
 * on 03/05/15.
 */
public class AddFrameView extends View {
    private JSlider slider;
    private JCheckBox checkBox1;
    private JButton button1;
    private JButton button2;
    private DepthImagePanel imagePanel;
    private JPanel panel;
    private JLabel frameLabel;
    private DepthImage depthImage;
    private File[] frames;
    private int current, width, height;

    public AddFrameView(DepthImage init, File[] frames, int width, int height) {
        /* Inizializzazione con il primo frame */
        depthImage = init;
        this.frames = frames;
        this.width = width;
        this.height = height;
        current = 0;
        frame = new JFrame("AddFrameView");
        frame.setContentPane(panel);
        frame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        frame.pack();
        slider.setMaximum(frames.length);
        printLabelForCurrentFrame();
    }

    public DepthImage getDepthImage() {
        return depthImage;
    }

    public JSlider getSlider() {
        return slider;
    }

    public void setCurrent(int current) {
        this.current = current;
    }

    public void setDepthImage(DepthImage depthImage) {
        this.depthImage = depthImage;
    }

    public void refresh() {
        try {
            depthImage = new DepthImage(frames[current], width, height);
            imagePanel.setImage(depthImage.getImage());
            imagePanel.repaint();
        } catch (IOException ee) {
            ee.printStackTrace();
        }
    }

    private void createUIComponents() {
        imagePanel = new DepthImagePanel(depthImage);
    }

    private void printLabelForCurrentFrame() {
        frameLabel.setText("Frame: "+current+"/"+frames.length);
        slider.setValue(current);
    }
}
