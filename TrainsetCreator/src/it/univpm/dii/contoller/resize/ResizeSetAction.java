package it.univpm.dii.contoller.resize;

import it.univpm.dii.model.DatasetManager;
import it.univpm.dii.model.entities.Element;
import it.univpm.dii.service.DepthImage;
import it.univpm.dii.view.ResizeDialog;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by ilario
 * on 18/08/15.
 */
class ResizeSetAction implements ActionListener {
    private ResizeDialog dialog;
    private DatasetManager datasetManager;
    private ResizeController controller;
    private File posDstPath, negDstPath;
    /**
     * Chiave: path del file di destinazione.
     * Valore: instanza {@link DepthImage} dell'immagine da ridimensionare.
     */
    private Map<String, DepthImage> images;
    private ArrayList<Element> elements;
    private Dimension resizeDim;

    public ResizeSetAction(ResizeDialog dialog) {
        this.dialog = dialog;
        datasetManager = DatasetManager.getInstance();
        controller = ResizeController.getInstance();
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        if(!controller.isResizeDone()) {
            elements = datasetManager.getTrainingSet().getElements();
            resizeDim = dialog.getResizeSampleDim();
            if (resizeDim != null) {
                try {
                    setupFolders();
                    images = fetchImages();
                    resizeImages();
                } catch (IOException ee) {
                    JOptionPane.showMessageDialog(dialog,
                            ee.getMessage(),
                            "Errore",
                            JOptionPane.ERROR_MESSAGE);
                }
            }
        } else {
            dialog.dispose();
        }
    }

    /**
     * Configura la struttura delle cartelle.
     *
     * @throws IOException Lanciata nel caso in cui non sia possibile creare
     *                     la struttura delle cartelle desiderata.
     */
    private void setupFolders()
            throws IOException {
        boolean directoriesReady;
        File baseDstPath;
        baseDstPath = DatasetManager.getResizeBasePath(
                datasetManager.getTrainingSet().getBasePath(),
                resizeDim
        );
        posDstPath = DatasetManager.getPositivesPath(baseDstPath);
        negDstPath = DatasetManager.getNegativesPath(baseDstPath);

        directoriesReady = posDstPath.exists();
        if (!directoriesReady) {
            directoriesReady = posDstPath.mkdirs();
        }

        directoriesReady = directoriesReady && negDstPath.exists();
        if (!directoriesReady) {
            directoriesReady = negDstPath.mkdirs();
        }

        if (!directoriesReady) {
            throw new IOException("Impossibile creare la struttura delle directory");
        }
    }

    /**
     * Costruisce un array associativo di immagini di profondità a partire dal nome
     *
     * @return Mappa di immagini di profondità
     */
    private Map<String, DepthImage> fetchImages() {
        Map<String, DepthImage> imgs = new HashMap<>(elements.size());

        elements.forEach((e) -> {
            try {
                File imagePath = new File(e.getFileName());
                DepthImage image = new DepthImage(
                        imagePath,
                        e.getWidth(),
                        e.getHeight()
                );
                Element resizedElement = new Element(e);
                resizedElement.setWidth((int) resizeDim.getWidth())
                        .setHeight((int) resizeDim.getHeight());
                datasetManager.generateFilename(resizedElement, posDstPath, negDstPath);

                imgs.put(resizedElement.getFileName(), image);
            } catch (IOException ee) {
                System.out.println("File saltato: " + e.getFileName());
            }
        });

        return imgs;
    }

    /**
     * Procedura per il resize delle immagini.
     */
    private void resizeImages() {
        int type = dialog.getResampleType();
        dialog.setupResizeProcess(images.size());
        controller.setResizeRunning(true);

        this.images.forEach((filename, image) -> {
            try {
                if (!controller.isStopResizeAction()) {
                    image.resize(resizeDim, type);
                    File f = new File(filename);
                    image.save(f);
                }
                dialog.increaseResizeProcess();
            } catch (Exception ee) {
                ee.printStackTrace();
            }
        });

        dialog.endResizeProcess();
        controller.setStopResizeAction(false);
        controller.setResizeDone(true);
        controller.setResizeRunning(false);
    }
}
