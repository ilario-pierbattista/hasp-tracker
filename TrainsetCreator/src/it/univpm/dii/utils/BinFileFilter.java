package it.univpm.dii.utils;

import java.io.File;
import java.io.FilenameFilter;

/**
 * Created by ilario
 * on 10/05/15.
 */
public class BinFileFilter implements FilenameFilter {
    @Override
    public boolean accept(File dir, String name) {
        return name.endsWith(".bin");
    }
}
