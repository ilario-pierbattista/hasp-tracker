package it.univpm.dii.contoller.addframe;

import it.univpm.dii.TrainsetCreator;
import it.univpm.dii.exception.EmptyFrameDirException;
import it.univpm.dii.model.entities.Element;
import it.univpm.dii.utils.BinFileComparator;
import it.univpm.dii.utils.BinFileFilter;
import it.univpm.dii.view.AddFrameView;
import it.univpm.dii.view.FrameRenderView;
import it.univpm.dii.view.MainFrame;
import it.univpm.dii.view.tablemodels.ElementModel;

import java.awt.event.KeyEvent;
import java.io.File;
import java.io.FilenameFilter;
import java.util.Arrays;

/**
 * Created by ilario
 * on 03/05/15.
 */
public class AddFrameController {
    private AddFrameView view;
    private static AddFrameController instance;

    public static final String PREF_CROP_WIDTH = "TSC_Crop_Width";
    public static final String PREF_CROP_HEIGTH = "TSC_Crop_Height";
    public static final String PREF_CROP_HANDFREE = "TSC_Crop_Handfree";
    public static final String PREF_CROP_SQUARE = "TSC_Crop_Square";

    public AddFrameController(AddFrameView view) {
        instance = this;
        this.view = view;
        setupView();
    }

    private void setupView() {
        // Data setup
        setCropPreference(view);

        // Listeners setup
        view.getHandfreeCheckbox()
                .addActionListener(new HandFreeSelectionCheckedAction(view));
        view.getSquareCheckbox()
                .addActionListener(new SquareSelectionCheckedAction(view));
        view.getCropHeight()
                .addPropertyChangeListener("value", new DimCropChangeAction(view));
        view.getCropWidth()
                .addPropertyChangeListener("value", new DimCropChangeAction(view));
        view.getFineButton()
                .addActionListener(new FineAction(view));
        view.getAggiungiButton()
                .addActionListener(new SalvaAction(view));
        view.getFastNegsCheck()
                .addActionListener(new FastNegativesCheckedAction(view));
        view.getImagePanel()
                .addMouseWheelListener(new FrameMouseWheelListener(view));
        view.getSlider()
                .addChangeListener(new SliderChangedAction(view));
        ChangeFlipDirectionAction cfd = new ChangeFlipDirectionAction(view);
        view.getxFlipRadio().addActionListener(cfd);
        view.getyFlipRadio().addActionListener(cfd);

        // Mnemonic setup
        view.getAggiungiButton().setMnemonic(KeyEvent.VK_A);
    }

    /**
     * Imposta le ultime dimensioni usate per il crop
     */
    protected static void setCropPreference(AddFrameView view) {
        view.setCropWidthValue(TrainsetCreator.pref.get(PREF_CROP_WIDTH, ""));
        view.setCropHeightValue(TrainsetCreator.pref.get(PREF_CROP_HEIGTH, ""));
    }

    /**
     * Salva le ultime dimensioni usate per il crop
     *
     * @param w Larghezza
     * @param h Altezza
     */
    protected static void saveCropPreference(int w, int h) {
        TrainsetCreator.pref.put(PREF_CROP_WIDTH, Integer.toString(w));
        TrainsetCreator.pref.put(PREF_CROP_HEIGTH, Integer.toString(h));
    }

    /**
     * Aggiorna le dimensioni della finestra di crop
     */
    protected static void updateCropDimensions(AddFrameView view) {
        int cropH = 0, cropW = 0;
        try {
            cropH = Integer.parseInt(view.getCropHeight().getText());
            cropW = cropH;
            if (!view.getSquareCheckbox().isSelected()) {
                cropW = Integer.parseInt(view.getCropWidth().getText());
            }
            saveCropPreference(cropW, cropH);
        } catch (NumberFormatException ee) {
            cropH = 0;
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
}
