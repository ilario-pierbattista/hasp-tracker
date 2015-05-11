package it.univpm.dii.utils;

import it.univpm.dii.model.dao.ElementDAO;

import java.io.File;
import java.io.FileFilter;
import java.io.FilenameFilter;

/**
 * Created by ilario
 * on 11/05/15.
 */
public class TrainsetFileFilter implements FilenameFilter {
    @Override
    public boolean accept(File dir, String name) {
        return name.equals(ElementDAO.POSITIVES_DIR) || name.equals(ElementDAO.NEGATIVES_DIR);
    }
}
