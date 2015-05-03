package it.univpm.dii.service;

import java.awt.image.BufferedImage;
import java.awt.image.WritableRaster;
import java.io.*;
import java.util.ArrayList;

/**
 * Created by ilario
 * on 03/05/15.
 */
public class DepthImage {

    private BufferedImage image;

    public DepthImage(File depth, int width, int height)
            throws IOException {
        /* Apertura del file */
        FileInputStream fis = new FileInputStream(depth.getAbsolutePath());
        DataInputStream is = new DataInputStream(fis);

        /* creazione dell'immagine */
        image = new BufferedImage(width, height, BufferedImage.TYPE_USHORT_GRAY);
        WritableRaster raster = image.getRaster();

        for (int i = 0; i < height && is.available() > 0; i++) {
            for (int j = 0; j < width && is.available() > 0; j++) {
                raster.setSample(j, i, 0, (int) is.readUnsignedShort());
            }
        }
    }

    public BufferedImage getImage() {
        return image;
    }
}
