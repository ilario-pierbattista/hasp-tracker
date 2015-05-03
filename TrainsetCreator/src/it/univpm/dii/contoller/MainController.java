package it.univpm.dii.contoller;

import it.univpm.dii.exception.EmptyFrameDirException;
import it.univpm.dii.view.MainFrame;
import it.univpm.dii.view.View;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;

/**
 * Created by ilario
 * on 02/05/15.
 */
public class MainController {
    protected MainFrame view;

    public MainController(MainFrame view) {
        this.view = view;
        actionSetter();
        this.view.setVisible(true);
    }

    public void actionSetter() {
        view.getMenuItems().get("file_new")
                .addActionListener(new NewTrainingSetAction(view));
        view.getMenuItems().get("file_open")
                .addActionListener(new OpenTrainingSetAction(view));
        view.getAggiungiButton().addActionListener(new AddFrameAction(view));
    }

    /**
     * Creazione di un nuovo trainset
     */
    class NewTrainingSetAction implements ActionListener {
        View v;

        public NewTrainingSetAction(View v) {
            this.v = v;
        }

        @Override
        public void actionPerformed(ActionEvent e) {
            int returnValue;
            boolean flag = true;
            File selected;
            String error = null;
            JFileChooser jf = new JFileChooser();
            jf.setDialogTitle("Scegliere la directory di destinazione");
            jf.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
            do {
                returnValue = jf.showOpenDialog(v.frame);
                if (returnValue == JFileChooser.APPROVE_OPTION) {
                    selected = jf.getSelectedFile();
                    if (!selected.exists()) {
                        error = "La cartella non esiste";
                    } else if (!selected.isDirectory()) {
                        error = "Non è stata selezionata una cartella";
                    } else if (selected.list().length > 0) {
                        error = "La cartella selezionata non è vuota";
                    } else {
                        System.out.println(selected.getAbsolutePath());
                        flag = false;
                    }

                    if (error != null) {
                        JOptionPane.showMessageDialog(this.v.frame,
                                error,
                                "Errore di IO",
                                JOptionPane.ERROR_MESSAGE);
                        error = null;
                    }
                } else {
                    flag = false;
                }
            } while (flag);
        }
    }

    /**
     * Apertura di un trainset
     */
    class OpenTrainingSetAction implements ActionListener {
        View view;

        public OpenTrainingSetAction(View v) {
            this.view = v;
        }

        @Override
        public void actionPerformed(ActionEvent e) {
            int returnValue;
            boolean flag = true;
            File selected;
            String error = null;
            JFileChooser jf = new JFileChooser();
            jf.setDialogTitle("Apri la directory con il training set");
            jf.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
            do {
                returnValue = jf.showOpenDialog(view.frame);
                if (returnValue == JFileChooser.APPROVE_OPTION) {
                    selected = jf.getSelectedFile();
                    if (!selected.exists()) {
                        error = "La cartella non esiste";
                    } else if (!selected.isDirectory()) {
                        error = "Non è stata selezionata una cartella";
                    } else if (selected.list().length == 0) {
                        error = "La cartella selezionata è vuota";
                        /* @TODO Effettuare il check del file meta */
                    } else {
                        System.out.println(selected.getAbsolutePath());
                        flag = false;
                    }

                    if (error != null) {
                        JOptionPane.showMessageDialog(this.view.frame,
                                error,
                                "Errore di IO",
                                JOptionPane.ERROR_MESSAGE);
                        error = null;
                    }
                } else {
                    flag = false;
                }
            } while (flag);
        }
    }

    /**
     * Aggiunta di un frame al trainset
     */
    class AddFrameAction implements ActionListener {
        private View v;

        public AddFrameAction(View v) {
            this.v = v;
        }

        @Override
        public void actionPerformed(ActionEvent e) {
            int returnValue;
            boolean flag = true;
            File selected;
            String error = null;
            JFileChooser jf = new JFileChooser();
            jf.setDialogTitle("Scegliere la directory con i frames");
            jf.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
            do {
                returnValue = jf.showOpenDialog(v.frame);
                if (returnValue == JFileChooser.APPROVE_OPTION) {
                    selected = jf.getSelectedFile();
                    if (!selected.exists()) {
                        error = "La cartella non esiste";
                    } else if (!selected.isDirectory()) {
                        error = "Non è stata selezionata una cartella";
                    } else if (selected.list().length == 0) {
                        error = "La cartella selezionata è vuota";
                    } else {
                        try {
                            new AddFrameController(selected);
                            flag = false;
                        } catch (EmptyFrameDirException ee) {
                            error = ee.getMessage();
                        }
                    }

                    if (error != null) {
                        JOptionPane.showMessageDialog(this.v.frame,
                                error,
                                "Errore di IO",
                                JOptionPane.ERROR_MESSAGE);
                        error = null;
                    }
                } else {
                    flag = false;
                }
            } while (flag);
        }
    }
}
