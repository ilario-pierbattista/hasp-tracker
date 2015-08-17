package it.univpm.dii.contoller.framerender;

import it.univpm.dii.TrainsetCreator;
import it.univpm.dii.exception.EmptyFrameDirException;
import it.univpm.dii.utils.BinFileComparator;
import it.univpm.dii.utils.BinFileFilter;
import it.univpm.dii.view.FrameRenderView;

import java.io.File;
import java.util.Arrays;

/**
 * Created by ilario
 * on 17/08/15.
 */
public class FrameRenderController {
    private File[] frames;

    public static final String PREF_IMAGE_WIDTH = "TSC_Image_Width";
    public static final String PREF_IMAGE_HEIGHT = "TSC_Image_Height";

    public FrameRenderController(File framesDir)
            throws EmptyFrameDirException {
        frames = readFrames(framesDir);
        createView();
    }

    /**
     * Lettura dei frames nella directory
     *
     * @param framesDir Directory contenente i frames
     * @return Array di frames
     * @throws EmptyFrameDirException Lanciata nel caso in cui la directory non contenga frames
     */
    private File[] readFrames(File framesDir)
            throws EmptyFrameDirException {
        frames = framesDir.listFiles(new BinFileFilter());
        if (frames.length == 0) {
            throw new EmptyFrameDirException(framesDir.getPath());
        }
        Arrays.sort(frames, new BinFileComparator());
        return frames;
    }

    /**
     * Creazione della vista
     *
     * @return Istanza di {@link FrameRenderView}.
     */
    private FrameRenderView createView() {
        FrameRenderView view = new FrameRenderView();
        view.setWidth(TrainsetCreator.pref.get(PREF_IMAGE_WIDTH, "0"))
                .setHeight(TrainsetCreator.pref.get(PREF_IMAGE_HEIGHT, "0"));
        view.getAvantiButton()
                .addActionListener(new AvantiRenderInfoAction(view, frames));
        view.getIndietroButton()
                .addActionListener(new IndietroRenderInfoAction(view));
        view.setVisible(true);
        return view;
    }
}
