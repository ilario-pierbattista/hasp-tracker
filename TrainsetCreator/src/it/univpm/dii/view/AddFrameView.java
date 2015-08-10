package it.univpm.dii.view;

import it.univpm.dii.model.entities.Element;
import it.univpm.dii.service.DepthImage;
import it.univpm.dii.view.component.DepthImagePanel;

import javax.swing.*;
import java.io.File;
import java.io.IOException;
import java.text.NumberFormat;

/**
 * Created by ilario
 * on 03/05/15.
 */
public class AddFrameView extends View {
    private JSlider slider;
    private JCheckBox humanCheckbox;
    private JButton aggiungiButton;
    private JButton fineButton;
    private DepthImagePanel imagePanel;
    private JPanel panel;
    private JLabel frameLabel;
    private JFormattedTextField cropHeight;
    private JFormattedTextField cropWidth;
    private JCheckBox handfreeCheckbox;
    private JCheckBox squareCheckbox;
    private JCheckBox fastNegsCheck;
    private JSlider xoffset;
    private JSlider yoffset;
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
        frame.setLocationRelativeTo(null);
        slider.setMaximum(frames.length);
        printLabelForCurrentFrame();
        xoffset.setEnabled(false);
        yoffset.setEnabled(false);
    }

    /**
     * Ritorna i dati immessi
     * @return
     */
    public Element getData() {
        Element e = new Element();
        e.setPositive(this.humanCheckbox.isSelected())
                .setWidth(imagePanel.getRectangle().width)
                .setHeight(imagePanel.getRectangle().height)
                .setX(imagePanel.getRectangle().x)
                .setY(imagePanel.getRectangle().y);
        return e;
    }

    public DepthImage getDepthImage() {
        return depthImage;
    }

    public JSlider getSlider() {
        return slider;
    }

    public JCheckBox getHandfreeCheckbox() {
        return handfreeCheckbox;
    }

    public JCheckBox getSquareCheckbox() {
        return squareCheckbox;
    }

    public JFormattedTextField getCropHeight() {
        return cropHeight;
    }

    public JFormattedTextField getCropWidth() {
        return cropWidth;
    }

    public JButton getFineButton() {
        return fineButton;
    }

    public JButton getAggiungiButton() {
        return aggiungiButton;
    }

    public JCheckBox getHumanCheckbox() {
        return humanCheckbox;
    }

    public JCheckBox getFastNegsCheck() {
        return fastNegsCheck;
    }

    public JSlider getXoffset() {
        return xoffset;
    }

    public JSlider getYoffset() {
        return yoffset;
    }

    public DepthImagePanel getImagePanel() {
        return imagePanel;
    }

    public void setCurrent(int current) {
        this.current = current;
    }

    public void setDepthImage(DepthImage depthImage) {
        this.depthImage = depthImage;
    }

    public AddFrameView setCropWidthValue(String width) {
        cropWidth.setText(width);
        return this;
    }

    public AddFrameView setCropHeightValue(String height) {
        cropHeight.setText(height);
        return this;
    }

    public AddFrameView setSquareCropArea(String dim) {
        cropHeight.setText(dim);
        cropWidth.setText(dim);
        return this;
    }

    public void refresh() {
        try {
            printLabelForCurrentFrame();
            depthImage = new DepthImage(frames[current], width, height);
            imagePanel.setDepthImage(depthImage);
            imagePanel.repaint();
        } catch (IOException ee) {
            ee.printStackTrace();
        }
    }

    private void createUIComponents() {
        NumberFormat pixelFormat = NumberFormat.getNumberInstance();
        pixelFormat.setMaximumFractionDigits(0);
        cropWidth = new JFormattedTextField(pixelFormat);
        cropHeight = new JFormattedTextField(pixelFormat);
        imagePanel = new DepthImagePanel(depthImage);
    }

    private void printLabelForCurrentFrame() {
        frameLabel.setText("Frame: " + current + "/" + frames.length);
        slider.setValue(current);
    }
}
