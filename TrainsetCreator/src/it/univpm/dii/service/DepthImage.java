package it.univpm.dii.service;

import java.awt.*;
import java.awt.geom.AffineTransform;
import java.awt.image.AffineTransformOp;
import java.awt.image.BufferedImage;
import java.awt.image.DataBufferUShort;
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
    private byte[] cropped;
    protected static final int COLOR_DEPTH = 2;

    public DepthImage(File depth, int width, int height)
            throws IOException {
        byte[] binaryImage;
        int length;

        /* Apertura del file */
        binaryImage = new byte[COLOR_DEPTH * width * height];
        FileInputStream fis = new FileInputStream(depth.getAbsolutePath());

        // Lettura del file
        length = fis.read(binaryImage, 0, COLOR_DEPTH * width * height);
        if(length != COLOR_DEPTH * width * height) {
            throw new IOException("Immagine corrotta. Sono previsti " +
                    Integer.toString(COLOR_DEPTH * height * width) +
                    " byte, sono stati trovati " + Integer.toString(length) + " byte");
        }

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
                pixelValue = (b1 << 8) | b2;
                raster.setSample(j / COLOR_DEPTH, i, 0, pixelValue);
            }
        }

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
        Rectangle region = new Rectangle(x, y, width, height);
        short[] subImageData = ((DataBufferUShort) image.getData(region).getDataBuffer())
                .getData();
        cropped = convertShort2Byte(subImageData);
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
     * Salvataggio dell'immagine.
     *
     * @param filename File dell'immagine.
     * @return Istanza di {@link DepthImage}.
     * @throws Exception
     */
    public DepthImage save(File filename) throws Exception {
        try {
            FileOutputStream fos = new FileOutputStream(filename.getAbsolutePath());
            short[] imageData = ((DataBufferUShort) image.getRaster().getDataBuffer())
                    .getData();
            byte[] byteImageData = convertShort2Byte(imageData);
            fos.write(byteImageData, 0, byteImageData.length);
            fos.close();
        } catch (IOException ee) {
            ee.printStackTrace();
        }
        return this;
    }

    /**
     * Esegue un flip dell'immagine rispetto l'asse  = c;
     *
     * @return Oggetto DepthImage
     */
    public DepthImage flipVertical() {
        AffineTransform af = new AffineTransform();
        af.concatenate(AffineTransform.getScaleInstance(1, -1));
        af.concatenate(AffineTransform.getTranslateInstance(0, -image.getHeight()));
        AffineTransformOp op = new AffineTransformOp(af, AffineTransformOp.TYPE_NEAREST_NEIGHBOR);
        this.image = op.filter(this.image, null);
        return this;
    }

    /**
     * Esegue un flip rispetto l'asse y = c;
     *
     * @return Oggetto DepthImage
     */
    public DepthImage flipHorizontal() {
        AffineTransform af = new AffineTransform();
        af.concatenate(AffineTransform.getScaleInstance(-1, 1));
        af.concatenate(AffineTransform.getTranslateInstance(-image.getWidth(), 0));
        AffineTransformOp op = new AffineTransformOp(af, AffineTransformOp.TYPE_NEAREST_NEIGHBOR);
        this.image = op.filter(this.image, null);
        return this;
    }

    /**
     * Ridimensiona l'immagine alle dimensioni specificate.
     *
     * @param dim  Dimensioni.
     * @param type Algoritmo di resampling da utilizzare.
     * @return Istanza di {@link DepthImage}.
     */
    public DepthImage resize(Dimension dim, int type) {
        double sx, sy;
        sx = dim.getWidth() / image.getWidth();
        sy = dim.getHeight() / image.getHeight();
        AffineTransform transform = new AffineTransform();
        transform.setToScale(sx, sy);
        AffineTransformOp op = new AffineTransformOp(transform, type);
        this.image = op.filter(this.image, null);
        return this;
    }

    public BufferedImage getImage() {
        return image;
    }

    /**
     * Converte un array di short in un array di byte per il salvataggio su file
     *
     * @param imageData Array di short.
     * @return Array di byte.
     */
    private byte[] convertShort2Byte(short[] imageData) {
        byte[] byteImageData = new byte[imageData.length * COLOR_DEPTH];
        byte b1, b2;
        for (int i = 0; i < imageData.length; i++) {
            b1 = (byte) ((imageData[i] & 0xFF00) >> 8);
            b2 = (byte) (imageData[i] & 0x00FF);
            byteImageData[i * COLOR_DEPTH] = b1;
            byteImageData[i * COLOR_DEPTH + 1] = b2;
        }
        return byteImageData;
    }
}
