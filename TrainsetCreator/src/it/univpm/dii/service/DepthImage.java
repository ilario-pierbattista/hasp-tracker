package it.univpm.dii.service;

import java.awt.image.BufferedImage;
import java.awt.image.Raster;
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
        int min, max, pixelValue;
        double scaleFactor;
        /** Inizializzazione di min a max a metà del campo di escursione
         * degli short
         */
        min = (int) Math.pow(2, 16) / 2;
        max = min + 1;

        /* creazione dell'immagine */
        image = new BufferedImage(width, height, BufferedImage.TYPE_USHORT_GRAY);
        WritableRaster raster = image.getRaster();

        for (int i = 0; i < height && is.available() > 0; i++) {
            for (int j = 0; j < width && is.available() > 0; j++) {
                //raster.setSample(j, i, 0, (int) is.readUnsignedShort());
                pixelValue = readShort(is);
                if (pixelValue > max) {
                    max = pixelValue;
                } else if (pixelValue < min) {
                    min = pixelValue;
                }
                raster.setSample(j, i, 0, pixelValue);
            }
        }
        /**
         * x : min-max = y : 65536
         * y = x * (65536 / (min - max))
         *
         scaleFactor = Math.pow(2, 16) * (max - min);

         for (int i = 0; i < raster.getHeight(); i++) {
         for (int j = 0; j < raster.getHeight(); j++) {
         raster.setSample(j, i, 0, (int) raster.getSample(j, i, 0) * scaleFactor);
         }
         } */
    }

    public BufferedImage getImage() {
        return image;
    }

    private int readShort(DataInputStream is) {
        try {
            int ch1 = is.read();
            int ch2 = is.read();
            if ((ch1 | ch2) < 0)
                throw new EOFException();
            return (ch2 << 8) + (ch1 << 0);
        } catch (IOException ee) {
            ee.printStackTrace();
        }
        return 0;
    }
}
