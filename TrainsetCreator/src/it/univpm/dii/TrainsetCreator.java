package it.univpm.dii;

import it.univpm.dii.contoller.MainController;
import it.univpm.dii.view.MainFrame;

import javax.swing.*;

/**
 * Created by ilario
 * on 01/05/15.
 */
public class TrainsetCreator {
    public static void main(String[] args) {
        setupLookAndFeel();
        MainFrame mf = new MainFrame();
        MainController mc = new MainController(mf);
    }

    private static void setupLookAndFeel() {
        try {
            UIManager.LookAndFeelInfo[] laf = UIManager.getInstalledLookAndFeels();
            boolean found = false;
            for (UIManager.LookAndFeelInfo singlelaf : laf) {
                if (singlelaf.getClassName().equals("com.sun.java.swing.plaf.gtk.GTKLookAndFeel")) {
                    UIManager.setLookAndFeel(singlelaf.getClassName());
                    found = true;
                }
            }
            if (!found) {
                UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
            }
        } catch (Exception ee) {
            ee.printStackTrace();
        }
    }
}
