package it.univpm.dii.utils;

import javax.swing.*;
import java.util.HashMap;

/**
 * Created by ilario
 * on 02/05/15.
 */
public class MenuItems extends HashMap<String, JMenuItem> {
    /**
     * Add entry to hashmap
     *
     * @param key
     * @param menuItem
     * @return
     */
    public MenuItems add(String key, JMenuItem menuItem) {
        put(key, menuItem);
        return this;
    }
}
