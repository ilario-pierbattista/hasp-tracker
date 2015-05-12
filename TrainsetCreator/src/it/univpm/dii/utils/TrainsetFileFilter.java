package it.univpm.dii.utils;


import it.univpm.dii.model.DatasetManager;

import java.io.File;
import java.io.FilenameFilter;

/**
 * Created by ilario
 * on 11/05/15.
 */
public class TrainsetFileFilter implements FilenameFilter {
    @Override
    public boolean accept(File dir, String name) {
        return name.equals(DatasetManager.POSITIVES_DIR) || name.equals(DatasetManager.NEGATIVES_DIR);
    }
}
