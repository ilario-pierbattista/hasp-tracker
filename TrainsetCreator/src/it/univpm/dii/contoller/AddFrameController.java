package it.univpm.dii.contoller;

import it.univpm.dii.exception.EmptyFrameDirException;
import it.univpm.dii.service.DepthImage;
import it.univpm.dii.view.AddFrameView;
import it.univpm.dii.view.FrameRenderView;

import javax.swing.*;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
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
        renderInfoView.getAvantiButton()
                .addActionListener(new AvantiRenderInfoAction());
        renderInfoView.getIndietroButton()
                .addActionListener(new IndietroRenderInfoAction());
        renderInfoView.setVisible(true);
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
            /* @TODO Qua si va avanti */
            width = renderInfoView.getWidth();
            height = renderInfoView.getHeight();
            renderInfoView.frame.dispose();

            try {
                DepthImage initDeptImage = new DepthImage(frames[0], width, height);
                view = new AddFrameView(initDeptImage, frames, width, height);
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
            System.out.println(newCursor);
            view.setCurrent(newCursor);
            view.refresh();
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

    class BinFileFilter implements FilenameFilter {
        @Override
        public boolean accept(File dir, String name) {
            return name.endsWith(".bin");
        }
    }

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
