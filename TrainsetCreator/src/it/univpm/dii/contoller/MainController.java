package it.univpm.dii.contoller;

import it.univpm.dii.exception.EmptyFrameDirException;
import it.univpm.dii.model.DatasetManager;
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
    protected File datasetPath;

    /**
     * Costanti per il directory chooser
     */
    private static final int DIRECTORY_EMPTY = 0;
    private static final int DIRECTORY_NOT_EMPTY = 1;

    public MainController(MainFrame view) {
        this.view = view;
        actionSetter();
        setDatasetPath(null);
        this.view.setVisible(true);
    }

    public void actionSetter() {
        view.getMenuItems().get("file_new")
                .addActionListener(new NewTrainingSetAction());
        view.getMenuItems().get("file_open")
                .addActionListener(new OpenTrainingSetAction());
        /* @TODO Aggiungere gli action listeners agli altri pulsanti */
        view.getAggiungiButton().addActionListener(new AddFrameAction());
    }

    public File getDatasetPath() {
        return datasetPath;
    }

    /**
     * Impostazione della path con il dataset
     *
     * @param datasetPath Path del dataset
     */
    public void setDatasetPath(File datasetPath) {
        view.setDatasetPath(datasetPath);
        this.datasetPath = datasetPath;
    }

    /**
     * Metodo per l'apertura del file chooser
     *
     * @param title
     * @param constraint
     * @return
     */
    private File openDirectoryChooser(String title, int constraint) {
        int returnValue;
        boolean flag = true;
        File selected = null;
        String error = null;
        JFileChooser jf = new JFileChooser();
        jf.setDialogTitle(title);
        jf.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
        do {
            returnValue = jf.showOpenDialog(view.frame);
            if (returnValue == JFileChooser.APPROVE_OPTION) {
                selected = jf.getSelectedFile();
                if (!selected.exists()) {
                    error = "La cartella non esiste";
                } else if (!selected.isDirectory()) {
                    error = "Non è stata selezionata una cartella";
                } else if (constraint == DIRECTORY_EMPTY &&
                        selected.list().length > 0) {
                    error = "La cartella selezionata non è vuota";
                } else if (constraint == DIRECTORY_NOT_EMPTY &&
                        selected.list().length == 0) {
                    error = "La cartella selezionata è vuota";
                } else {
                    flag = false;
                }

                if (error != null) {
                    JOptionPane.showMessageDialog(view.frame,
                            error,
                            "Errore di IO",
                            JOptionPane.ERROR_MESSAGE);
                    error = null;
                    selected = null;
                }
            } else {
                flag = false;
            }
        } while (flag);
        return selected;
    }

    /**
     * Creazione di un nuovo trainset
     */
    class NewTrainingSetAction implements ActionListener {

        @Override
        public void actionPerformed(ActionEvent e) {
            File selected = openDirectoryChooser("Scegliere la directory di destinazione", DIRECTORY_EMPTY);
            setDatasetPath(selected);
            DatasetManager.newInstance(datasetPath);
        }
    }

    /**
     * Apertura di un trainset
     */
    class OpenTrainingSetAction implements ActionListener {

        @Override
        public void actionPerformed(ActionEvent e) {
            File selected = openDirectoryChooser("Apri la cartella contenente il training set", DIRECTORY_NOT_EMPTY);
            setDatasetPath(selected);
            DatasetManager.newInstance(datasetPath);
        }
    }

    /**
     * Aggiunta di un frame al trainset
     */
    class AddFrameAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            File selected = null;
            boolean flag = true;
            do {
                selected = openDirectoryChooser("Apri la cartella con i frame", DIRECTORY_NOT_EMPTY);
                try {
                    new AddFrameController(selected);
                    flag = false;
                } catch (EmptyFrameDirException ee) {
                    JOptionPane.showMessageDialog(view.frame,
                            ee.getMessage(),
                            "Errore di IO",
                            JOptionPane.ERROR_MESSAGE);
                }
            } while (flag);
        }
    }
}
