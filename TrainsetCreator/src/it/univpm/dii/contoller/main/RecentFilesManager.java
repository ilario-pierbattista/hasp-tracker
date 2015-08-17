package it.univpm.dii.contoller.main;

import it.univpm.dii.TrainsetCreator;
import it.univpm.dii.view.MainFrame;

import javax.swing.*;
import java.io.File;
import java.util.ArrayList;

/**
 * Created by ilario
 * on 17/08/15.
 */
class RecentFilesManager {
    private ArrayList<File> recentDatasets;
    public static final String[] PREF_LAST_SET = {
            "TSC_Last_Set_0",
            "TSC_Last_Set_1",
            "TSC_Last_Set_2",
            "TSC_Last_Set_3"
    };

    public RecentFilesManager() {
        recentDatasets = getRecentDatasets();
        MainFrame.getInstance().setRecents(recentDatasets);
    }

    /**
     * Riprendere la path degli ultimi dataset utilizzati
     *
     * @return Istanze di File alle cartelle degli ultimi dataset
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
    protected void updateRecents(File path) {
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

        MainFrame.getInstance().setRecents(recentDatasets);
        setRecentMenuActions();
    }

    /**
     * Imposta gli action listeners agli elementi del menu che
     * puntano ai dataset usati di recente
     */
    protected void setRecentMenuActions() {
        OpenRecentAction action = new OpenRecentAction();
        JMenu recentMenu = ((JMenu) MainFrame.getInstance().getMenuItems().get("file_recent"));
        for (int i = 0; i < recentMenu.getItemCount(); i++) {
            JMenuItem item = recentMenu.getItem(i);
            item.addActionListener(action);
        }
    }

}
