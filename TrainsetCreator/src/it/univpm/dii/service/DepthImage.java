package it.univpm.dii.service;

import java.awt.*;
import java.awt.image.BufferedImage;
import java.awt.image.WritableRaster;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * Created by ilario
 * on 03/05/15.
 */
public class DepthImage {

    private BufferedImage image;
    private byte[] binaryImage, cropped;

    public DepthImage(File depth, int width, int height)
            throws IOException {
        /* Apertura del file */
        binaryImage = new byte[2 * width * height];
        FileInputStream fis = new FileInputStream(depth.getAbsolutePath());
        // Lettura del file
        fis.read(binaryImage, 0, 2 * width * height);

        /* creazione dell'immagine */
        image = new BufferedImage(width, height, BufferedImage.TYPE_USHORT_GRAY);
        WritableRaster raster = image.getRaster();

        /* Lettura dell'immagine dall'array di byte per la creazione dell'immagine
         * raster
         */
        int pixelValue;
        byte b1, b2;
        for (int i = 0; i < height; i++) {
            for (int j = 0; j < 2 * width; j += 2) {
                b1 = binaryImage[i * 2 * width + j];
                b2 = binaryImage[i * 2 * width + j + 1];
                pixelValue = (int) (b1 << 8) | b2;
                raster.setSample(j / 2, i, 0, pixelValue);
            }
        }

    }

    public DepthImage crop(Point p, int width, int height) {
        return crop(p.x, p.y, width, height);
    }

    /**
     * Ritaglia un pezzo d'immagine
     * @param x
     * @param y
     * @param width
     * @param height
     * @return
     */
    public DepthImage crop(int x, int y, int width, int height) {
        /* L'immagine è a 16 bit. Per la porzione di frame estratta sono necessari
         * 2 byte per ogni pixel, ed è composta da width * height pixel in totale
         */
        cropped = new byte[2 * width * height];
        System.out.println(width + " " + height);
        int k = 0, imageWidth = image.getWidth();
        for (int i = y; i < y + height; i++) {
            for (int j = x*2; j < (x + width) * 2; j++) {
                cropped[k++] = binaryImage[i * 2 * imageWidth + j];
            }
        }
        return this;
    }

    /**
     * Salva l'immagine croppata
     * @param filename
     * @return
     * @throws Exception
     */
    public DepthImage save(File filename) throws Exception {
        try {
            FileOutputStream fos = new FileOutputStream(filename.getAbsolutePath());
            fos.write(cropped, 0, cropped.length);
            fos.close();
        } catch (IOException ee) {
            ee.printStackTrace();
        }
        return this;
    }

    public BufferedImage getImage() {
        return image;
    }
}
