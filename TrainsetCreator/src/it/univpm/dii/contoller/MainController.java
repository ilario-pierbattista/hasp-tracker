package it.univpm.dii.contoller;

import it.univpm.dii.exception.EmptyFrameDirException;
import it.univpm.dii.model.DatasetManager;
import it.univpm.dii.model.entities.Element;
import it.univpm.dii.service.DepthImage;
import it.univpm.dii.view.MainFrame;
import it.univpm.dii.view.component.SampleTable;
import it.univpm.dii.view.tablemodels.ElementModel;

import javax.swing.*;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.File;
import java.io.IOException;

/**
 * Created by ilario
 * on 02/05/15.
 */
public class MainController {
    protected MainFrame view;
    protected File datasetPath;

    /* @TODO Da usare per aprire velocemente i set apert di recente */
    public static final String PREF_LAST_SET_0 = "TSC_Last_Set 0";
    public static final String PREF_LAST_SET_1 = "TSC_Last_Set 1";
    public static final String PREF_LAST_SET_2 = "TSC_Last_Set 2";
    public static final String PREF_LAST_SET_3 = "TSC_Last_Set 3";

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
        // Listeners dei menu
        view.getMenuItems().get("file_new")
                .addActionListener(new NewTrainingSetAction());
        view.getMenuItems().get("file_open")
                .addActionListener(new OpenTrainingSetAction());

        // Listeners dei pulsanti
        /* @TODO Aggiungere gli action listeners agli altri pulsanti */
        view.getAggiungiButton().addActionListener(new AddFrameAction());

        // Listener della tabella
        view.getSampleTable().getSelectionModel().addListSelectionListener(new SampleSelectedAction());

        // Listern per l'uscita
        view.frame.addWindowListener(new QuitAction());
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
     * @param title      Titolo del file chooser
     * @param constraint Vincoli sul contenuto delle directory
     * @return Directory selezionata
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
            view.refresh();
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
            view.refresh();
        }
    }

    /**
     * Aggiunta di un frame al trainset
     */
    class AddFrameAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            File selected;
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

    class SampleSelectedAction implements ListSelectionListener {
        @Override
        public void valueChanged(ListSelectionEvent e) {
            if (!e.getValueIsAdjusting()) {
                SampleTable table = view.getSampleTable();
                ElementModel model = (ElementModel) table.getModel();
                Element element = model.getRow(table.getSelectedRow());
                if (element != null) {
                    try {
                        DepthImage depthImage = new DepthImage(
                                new File(element.getFileName()),
                                element.getWidth(),
                                element.getHeight());
                        view.getPreviewImagePanel()
                                .setDepthImage(depthImage);
                    } catch (IOException ee) {
                        ee.printStackTrace();
                    }
                }
            }
        }
    }

    /**
     * Implementa la chiusura del programma
     */
    class QuitAction extends WindowAdapter {
        @Override
        public void windowClosing(WindowEvent e) {
            /* @TODO Implementare una logica di uscita migliore */
            System.out.println("Uscita");
            System.exit(0);
        }
    }
}
