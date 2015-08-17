package it.univpm.dii.contoller.framerender;

import it.univpm.dii.TrainsetCreator;
import it.univpm.dii.contoller.addframe.AddFrameController;
import it.univpm.dii.service.DepthImage;
import it.univpm.dii.view.AddFrameView;
import it.univpm.dii.view.FrameRenderView;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.io.IOException;

/**
 * Salvataggio delle dimensioni e apertura dei frame
 */
class AvantiRenderInfoAction implements ActionListener {
    private FrameRenderView renderInfoView;
    private File[] frames;

    public AvantiRenderInfoAction(FrameRenderView renderInfoView, File[] frames) {
        this.renderInfoView = renderInfoView;
        this.frames = frames;
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        int width, height;
        width = renderInfoView.getWidth();
        height = renderInfoView.getHeight();

        /* Salvataggio delle preferenze */
        TrainsetCreator.pref.put(FrameRenderController.PREF_IMAGE_WIDTH, Integer.toString(width));
        TrainsetCreator.pref.put(FrameRenderController.PREF_IMAGE_HEIGHT, Integer.toString(height));

        renderInfoView.frame.dispose();

        try {
            DepthImage initDeptImage = new DepthImage(frames[0], width, height);
            AddFrameView view = new AddFrameView(initDeptImage, frames, width, height);
            new AddFrameController(view);
            view.setVisible(true);
        } catch (IOException ee) {
            ee.printStackTrace();
        }
    }
}
