package it.univpm.dii.contoller.main;

import it.univpm.dii.view.MainFrame;

import javax.swing.*;
import java.io.File;


public class MainController {
    protected MainFrame view;
    protected static File datasetPath;
    private static RecentFilesManager rfm;

    /**
     * Costanti per il directory chooser
     */
    protected static final int DIRECTORY_EMPTY = 0;
    protected static final int DIRECTORY_NOT_EMPTY = 1;

    public MainController(MainFrame view) {
        this.view = view;
        setDatasetPath(null);
        rfm = new RecentFilesManager();
        actionSetter();
        this.view.setVisible(true);
    }

    public void actionSetter() {
        // Listeners dei menu
        view.getMenuItems().get("file_new")
                .addActionListener(new NewTrainingSetAction());
        view.getMenuItems().get("file_open")
                .addActionListener(new OpenTrainingSetAction());
        rfm.setRecentMenuActions();
        view.getMenuItems().get("export_resize")
                .addActionListener(new OpenResizeDialog());

        // Listeners dei pulsanti
        view.getAggiungiButton()
                .addActionListener(new AddFrameAction());
        view.getEliminaButton()
                .addActionListener(new EliminaSelectedAction());
        view.getModificaButton()
                .addActionListener(new EditSelectedAction());

        // Listener della tabella
        view.getSampleTable()
                .getSelectionModel()
                .addListSelectionListener(new SampleSelectedAction());

        // Listern per l'uscita
        view.frame.addWindowListener(new QuitAction());
    }

    /**
     * Impostazione della path con il dataset
     *
     * @param datasetPath Path del dataset
     */
    public static void setDatasetPath(File datasetPath) {
        MainFrame.getInstance().setDatasetPath(datasetPath);
        MainController.datasetPath = datasetPath;
        if (datasetPath != null) {
            rfm.updateRecents(datasetPath);
        }
    }

    /**
     * Metodo per l'apertura del file chooser
     *
     * @param title      Titolo del file chooser
     * @param constraint Vincoli sul contenuto delle directory
     * @return Directory selezionata
     */
    protected static File openDirectoryChooser(String title, int constraint) {
        int returnValue;
        boolean flag = true;
        File selected = null;
        String error = null;
        JFileChooser jf = new JFileChooser();
        jf.setDialogTitle(title);
        jf.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
        do {
            returnValue = jf.showOpenDialog(MainFrame.getInstance().frame);
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
                    JOptionPane.showMessageDialog(MainFrame.getInstance().frame,
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
}
