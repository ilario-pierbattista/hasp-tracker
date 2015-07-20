package it.univpm.dii.contoller;

import com.sun.org.apache.xml.internal.security.algorithms.JCEMapper;
import it.univpm.dii.TrainsetCreator;
import it.univpm.dii.exception.EmptyFrameDirException;
import it.univpm.dii.model.DatasetManager;
import it.univpm.dii.model.entities.Element;
import it.univpm.dii.model.entities.TrainSet;
import it.univpm.dii.service.DepthImage;
import it.univpm.dii.utils.BinFileFilter;
import it.univpm.dii.view.AddFrameView;
import it.univpm.dii.view.FrameRenderView;
import it.univpm.dii.view.MainFrame;
import it.univpm.dii.view.tablemodels.ElementModel;

import javax.swing.*;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.util.Arrays;
import java.util.Comparator;

/**
 * Created by ilario
 * on 03/05/15.
 */
public class AddFrameController {
    private AddFrameView view;
    private FrameRenderView renderInfoView;
    private File frameDir;
    private FilenameFilter filter;
    private File[] frames;
    private int width;
    private int height;
    private static AddFrameController instance;

    public static final String PREF_IMAGE_WIDTH = "TSC_Image_Width";
    public static final String PREF_IMAGE_HEIGHT = "TSC_Image_Height";
    public static final String PREF_CROP_WIDTH = "TSC_Crop_Width";
    public static final String PREF_CROP_HEIGTH = "TSC_Crop_Height";
    public static final String PREF_CROP_HANDFREE = "TSC_Crop_Handfree";
    public static final String PREF_CROP_SQUARE = "TSC_Crop_Square";

    public AddFrameController(File frameDir)
            throws EmptyFrameDirException {
        instance = this;
        this.frameDir = frameDir;
        filter = new BinFileFilter();
        frames = frameDir.listFiles(filter);
        if (frames.length == 0) {
            throw new EmptyFrameDirException(frameDir.getPath());
        }
        Arrays.sort(frames, new BinFileComparator());

        renderInfoView = new FrameRenderView();
        renderInfoView.setWidth(TrainsetCreator.pref.get(PREF_IMAGE_WIDTH, "0"))
                .setHeight(TrainsetCreator.pref.get(PREF_IMAGE_HEIGHT, "0"));
        renderInfoView.getAvantiButton()
                .addActionListener(new AvantiRenderInfoAction());
        renderInfoView.getIndietroButton()
                .addActionListener(new IndietroRenderInfoAction());
        renderInfoView.setVisible(true);
    }

    /**
     * Imposta le ultime dimensioni usate per il crop
     */
    private void setCropPreference() {
        view.setCropWidthValue(TrainsetCreator.pref.get(PREF_CROP_WIDTH, ""));
        view.setCropHeightValue(TrainsetCreator.pref.get(PREF_CROP_HEIGTH, ""));
    }

    /**
     * Salva le ultime dimensioni usate per il crop
     * @param w Larghezza
     * @param h Altezza
     */
    private void saveCropPreference(int w, int h) {
        TrainsetCreator.pref.put(PREF_CROP_WIDTH, Integer.toString(w));
        TrainsetCreator.pref.put(PREF_CROP_HEIGTH, Integer.toString(h));
    }

    /**
     * Aggiorna le dimensioni della finestra di crop
     */
    private void updateCropDimensions() {
        int cropH = 0, cropW = 0;
        try {
            cropH = Integer.parseInt(view.getCropHeight().getText());
            cropW = cropH;
            if (!view.getSquareCheckbox().isSelected()) {
                cropW = Integer.parseInt(view.getCropWidth().getText());
            }
            saveCropPreference(cropW, cropH);
        } catch (NumberFormatException ee) {
            cropH = 0;  // Giusto per essere più certi della morte
            cropW = 0;
        } finally {
            view.getImagePanel().setRectangleDimensions(cropW, cropH)
                    .forceResize();
        }
    }

    /**
     * Aggiorna la vista del mainframe
     */
    private void addlElementToMF(Element element) {
        MainFrame mainFrame = MainFrame.getInstance();
        ElementModel model = (ElementModel) mainFrame.getSampleTable().getModel();
        model.addElement(element);
    }

    public static AddFrameController getInstance() {
        return instance;
    }

    /**
     * Salvataggio delle dimensioni e apertura dei frame
     */
    class AvantiRenderInfoAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            width = renderInfoView.getWidth();
            height = renderInfoView.getHeight();

            /* Salvataggio delle preferenze */
            TrainsetCreator.pref.put(PREF_IMAGE_WIDTH, Integer.toString(width));
            TrainsetCreator.pref.put(PREF_IMAGE_HEIGHT, Integer.toString(height));

            renderInfoView.frame.dispose();

            try {
                DepthImage initDeptImage = new DepthImage(frames[0], width, height);
                view = new AddFrameView(initDeptImage, frames, width, height);
                setCropPreference();
                // Action listeners
                view.getHandfreeCheckbox().addActionListener(new HandFreeSelectionCheckedAction());
                view.getSquareCheckbox().addActionListener(new SquareSelectionCheckedAction());
                DimCropChangeAction action = new DimCropChangeAction();
                view.getCropHeight().addPropertyChangeListener("value", action);
                view.getCropWidth().addPropertyChangeListener("value", action);
                view.getFineButton().addActionListener(new FineAction());
                view.getAggiungiButton().addActionListener(new SalvaAction());
                view.getFastNegsCheck().addActionListener(new FastNegativesCheckedAction());
                // Visualizzazione
                view.setVisible(true);
                addListernes();
            } catch (IOException ee) {
                ee.printStackTrace();
            }
        }

        private void addListernes() {
            view.getSlider().addChangeListener(new SliderChangedAction());
        }
    }

    /**
     * Cambiamento dello slider
     */
    class SliderChangedAction implements ChangeListener {
        @Override
        public void stateChanged(ChangeEvent e) {
            JSlider slider = (JSlider) e.getSource();
            int newCursor = slider.getValue();
            view.setCurrent(newCursor);
            view.refresh();
        }
    }

    /**
     * Cambiamento delle dimensioni dell'area da tagliare
     */
    class DimCropChangeAction implements PropertyChangeListener {
        @Override
        public void propertyChange(PropertyChangeEvent evt) {
            updateCropDimensions();
        }
    }

    /**
     * Selezione quadrata
     */
    class SquareSelectionCheckedAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            JCheckBox b = (JCheckBox) e.getSource();
            if (b.isSelected()) {
                String dim = view.getCropHeight().getText();
                if(dim.isEmpty()) {
                    dim = view.getCropWidth().getText();
                }
                view.setSquareCropArea(dim);
                view.getCropWidth().setEnabled(false);
            } else {
                view.getCropWidth().setEnabled(true);
            }
            updateCropDimensions();
        }
    }

    /**
     * Selezione a mano libera
     */
    class HandFreeSelectionCheckedAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            JCheckBox b = (JCheckBox) e.getSource();
            if (b.isSelected()) {
                view.setCropWidthValue("0");
                view.setCropHeightValue("0");
                view.getCropWidth().setEnabled(false);
                view.getCropHeight().setEnabled(false);
            } else {
                setCropPreference();
                view.getCropHeight().setEnabled(true);
                view.getCropWidth().setEnabled(true);
                view.setCropHeightValue(Integer.toString(view.getImagePanel().getRectangle().height));
                view.setCropWidthValue(Integer.toString(view.getImagePanel().getRectangle().width));
            }
            updateCropDimensions();
        }
    }

    /**
     * Gestore del checkbox per la generazione veloce di negativi
     */
    class FastNegativesCheckedAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            JCheckBox b = (JCheckBox) e.getSource();
            if(b.isSelected()) {
                // Attivato
                view.getHumanCheckbox().setSelected(false);
                view.getHumanCheckbox().setEnabled(false);
                view.getXoffset().setEnabled(true);
                view.getYoffset().setEnabled(true);
            } else {
                // Disattivato
                view.getHumanCheckbox().setEnabled(true);
                view.getXoffset().setEnabled(false);
                view.getYoffset().setEnabled(false);
            }
        }
    }

    /**
     * Salvataggio della porzione di frame
     */
    class SalvaAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            DatasetManager dm = DatasetManager.getInstance();
            Element element = view.getData();
            dm.create(element);
            // La generazione del nome deve essere lanciata dopo il create
            // altrimenti l'id non viene assegnato
            DatasetManager.getInstance().generateFilename(element);
            view.getImagePanel().cropAndSave(new File(element.getFileName()));
            MainFrame.getInstance().addElement(element);
        }
    }

    /**
     * Chiusura
     */
    class FineAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            view.frame.dispose();
        }
    }

    /**
     * Chiusura della dialog per le dimensioni
     */
    class IndietroRenderInfoAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            renderInfoView.frame.dispose();
        }
    }

    /**
     * Comparatore per i nomi dei file .bin
     */
    class BinFileComparator implements Comparator<File> {
        @Override
        public int compare(File o1, File o2) {
            String f1, f2;
            f1 = o1.getName().replaceAll("[^0-9]", "");
            f2 = o2.getName().replaceAll("[^0-9]", "");
            return Integer.parseInt(f1) - Integer.parseInt(f2);
        }
    }
}
