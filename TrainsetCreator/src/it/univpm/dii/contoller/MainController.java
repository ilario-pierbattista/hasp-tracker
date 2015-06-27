package it.univpm.dii.contoller;

import it.univpm.dii.TrainsetCreator;
import it.univpm.dii.exception.EmptyFrameDirException;
import it.univpm.dii.model.DatasetManager;
import it.univpm.dii.model.entities.Element;
import it.univpm.dii.view.MainFrame;

import javax.swing.*;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;
import javax.swing.text.FieldView;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;


public class MainController {
    protected MainFrame view;
    protected File datasetPath;
    private ArrayList<File> recentDatasets;

    public static final String[] PREF_LAST_SET = {
            "TSC_Last_Set_0",
            "TSC_Last_Set_1",
            "TSC_Last_Set_2",
            "TSC_Last_Set_3"
    };

    /**
     * Costanti per il directory chooser
     */
    private static final int DIRECTORY_EMPTY = 0;
    private static final int DIRECTORY_NOT_EMPTY = 1;

    public MainController(MainFrame view) {
        this.view = view;
        setDatasetPath(null);
        recentDatasets = this.getRecentDatasets();
        view.setRecents(recentDatasets);
        actionSetter();
        this.view.setVisible(true);
    }

    public void actionSetter() {
        // Listeners dei menu
        view.getMenuItems().get("file_new")
                .addActionListener(new NewTrainingSetAction());
        view.getMenuItems().get("file_open")
                .addActionListener(new OpenTrainingSetAction());
        setRecentMenuActions();

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
        if (datasetPath != null) {
            updateRecents(datasetPath);
        }
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
     * Riprendere la path degli ultimi dataset utilizzati
     *
     * @return
     */
    private ArrayList<File> getRecentDatasets() {
        ArrayList<File> recents = new ArrayList<File>(5);
        String path;
        for (String preferenceKey : PREF_LAST_SET) {
            path = TrainsetCreator.pref.get(preferenceKey, null);
            if (path != null) {
                recents.add(new File(path));
            }
        }
        return recents;
    }

    /**
     * Aggiorna le preferenze, impostando le path degli ultimi database aperti
     *
     * @param path path del database aperto
     */
    private void updateRecents(File path) {
        int index = recentDatasets.size();
        boolean found = false;
        File element;

        // Ricerca dell'elemento nella lista dei file recenti
        for (int i = 0; i < recentDatasets.size() && !found; i++) {
            if (path.getAbsolutePath().equals(recentDatasets.get(i).getAbsolutePath())) {
                index = i;
                found = true;
            }
        }
        
        for (int i = index; i > 0; i--) {
            element = recentDatasets.get(i - 1);
            if (recentDatasets.size() <= i) {
                recentDatasets.add(i, element);
            } else {
                recentDatasets.set(i, element);
            }
        }

        if (recentDatasets.size() > 0) {
            recentDatasets.set(0, path);
        } else {
            recentDatasets.add(0, path);
        }

        for (int i = 0; i < Math.min(recentDatasets.size(), PREF_LAST_SET.length); i++) {
            TrainsetCreator.pref.put(PREF_LAST_SET[i], recentDatasets.get(i).getAbsolutePath());
        }

        if (recentDatasets.size() > PREF_LAST_SET.length) {
            recentDatasets = new ArrayList<File>(recentDatasets.subList(0, PREF_LAST_SET.length));
        }

        view.setRecents(recentDatasets);
        setRecentMenuActions();
    }

    private void setRecentMenuActions() {
        OpenRecentAction action = new OpenRecentAction();
        JMenu recentMenu = ((JMenu) view.getMenuItems().get("file_recent"));
        for (int i = 0; i < recentMenu.getItemCount(); i++) {
            JMenuItem item = recentMenu.getItem(i);
            item.addActionListener(action);
        }
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
     * Apertura di un trainset recente
     */
    class OpenRecentAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            File path = new File(e.getActionCommand());
            setDatasetPath(path);
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
                Element element = view.getSelectedElement();
                if (element != null) {
                    view.enableEdit(true);
                    try {
                        view.updatePreviewPanel(element);
                    } catch (IOException ee) {
                        ee.printStackTrace();
                    }
                } else {
                    view.enableEdit(false);
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
