package it.univpm.dii.view.component;

import it.univpm.dii.service.DepthImage;

import javax.swing.*;
import java.awt.*;
import java.awt.image.BufferedImage;

/**
 * Created by ilario
 * on 03/05/15.
 */
public class DepthImagePanel extends JPanel {
    private BufferedImage image;

    public DepthImagePanel(DepthImage depthImage) {
        image = depthImage.getImage();
        this.setPreferredSize(new Dimension(
                image.getWidth(),
                image.getHeight()
        ));
    }

    public BufferedImage getImage() {
        return image;
    }

    public void setImage(BufferedImage image) {
        this.image = image;
    }

    @Override
    protected void paintComponent(Graphics g) {
        g.drawImage(image, 0, 0, this);
    }
}
