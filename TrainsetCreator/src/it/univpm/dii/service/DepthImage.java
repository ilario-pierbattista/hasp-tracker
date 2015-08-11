package it.univpm.dii.service;

import java.awt.*;
import java.awt.geom.AffineTransform;
import java.awt.image.AffineTransformOp;
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
    protected static final int COLOR_DEPTH = 2;

    public DepthImage(File depth, int width, int height)
            throws IOException {
        /* Apertura del file */
        binaryImage = new byte[COLOR_DEPTH * width * height];
        FileInputStream fis = new FileInputStream(depth.getAbsolutePath());
        // Lettura del file
        fis.read(binaryImage, 0, COLOR_DEPTH * width * height);

        /* creazione dell'immagine */
        image = new BufferedImage(width, height, BufferedImage.TYPE_USHORT_GRAY);
        WritableRaster raster = image.getRaster();

        /* Lettura dell'immagine dall'array di byte per la creazione dell'immagine
         * raster
         */
        int pixelValue;
        byte b1, b2;
        for (int i = 0; i < height; i++) {
            for (int j = 0; j < COLOR_DEPTH * width; j += COLOR_DEPTH) {
                b1 = binaryImage[i * COLOR_DEPTH * width + j];
                b2 = binaryImage[i * COLOR_DEPTH * width + j + 1];
                pixelValue = (int) (b1 << 8) | b2;
                raster.setSample(j / COLOR_DEPTH, i, 0, pixelValue);
            }
        }

    }

    public DepthImage crop(Point p, int width, int height) {
        return crop(p.x, p.y, width, height);
    }

    /**
     * Ritaglia un pezzo d'immagine
     *
     * @param x      Ascissa del punto in alto a sinistra.
     * @param y      Ordinata del punto in alto a sinistra.
     * @param width  Larghezza dell'area.
     * @param height Altezza dell'area.
     * @return Istanza di {@link DepthImage}.
     */
    public DepthImage crop(int x, int y, int width, int height) {
        /* L'immagine è a 16 bit. Per la porzione di frame estratta sono necessari
         * 2 byte per ogni pixel, ed è composta da width * height pixel in totale
         */
        cropped = new byte[COLOR_DEPTH * width * height];
        System.out.println(width + " " + height);
        int k = 0, imageWidth = image.getWidth();
        for (int i = y; i < y + height; i++) {
            for (int j = x * COLOR_DEPTH; j < (x + width) * COLOR_DEPTH; j++) {
                cropped[k++] = binaryImage[i * COLOR_DEPTH * imageWidth + j];
            }
        }
        return this;
    }

    /**
     * Salva l'immagine croppata
     *
     * @param filename File di destinazione
     * @return Istanza di {@link DepthImage} per il method chaining
     * @throws Exception
     */
    public DepthImage saveCrop(File filename) throws Exception {
        try {
            FileOutputStream fos = new FileOutputStream(filename.getAbsolutePath());
            fos.write(cropped, 0, cropped.length);
            fos.close();
        } catch (IOException ee) {
            ee.printStackTrace();
        }
        return this;
    }

    /**
     * Esegue un flip dell'immagine rispetto l'asse x
     *
     * @return Oggetto DepthImage
     */
    public DepthImage flipVertical() {
        AffineTransform af = new AffineTransform();
        af.concatenate(AffineTransform.getScaleInstance(1, -1));
        af.concatenate(AffineTransform.getTranslateInstance(0, -image.getHeight()));
        performTransformation(af);
        return this;
    }

    /**
     * Esegue un flip rispetto l'asse y
     *
     * @return Oggetto DepthImage
     */
    public DepthImage flipHorizontal() {
        AffineTransform af = new AffineTransform();
        af.concatenate(AffineTransform.getScaleInstance(-1, 1));
        af.concatenate(AffineTransform.getTranslateInstance(-image.getWidth(), 0));
        performTransformation(af);
        return this;
    }

    public BufferedImage getImage() {
        return image;
    }

    /**
     * Esegue le operazioni descritte in una trasformazione affine
     *
     * @param af Oggetto della trasformazione affine
     * @return Oggetto DepthImage
     */
    private DepthImage performTransformation(AffineTransform af) {
        AffineTransformOp op = new AffineTransformOp(af, AffineTransformOp.TYPE_BILINEAR);
        this.image = op.filter(this.image, null);
        return this;
    }
}
