package it.univpm.dii.utils;

import java.io.File;
import java.util.Comparator;

/**
 * Comparatore per i nomi dei file .bin
 */
public class BinFileComparator implements Comparator<File> {
    @Override
    public int compare(File o1, File o2) {
        String f1, f2;
        int difference;
        f1 = o1.getName().replaceAll("[^0-9]", "");
        f2 = o2.getName().replaceAll("[^0-9]", "");
        try {
            difference = Integer.parseInt(f1) - Integer.parseInt(f2);
        } catch (NumberFormatException ee) {
            ee.printStackTrace();
            difference = 1;
        }
        return difference;
    }
}