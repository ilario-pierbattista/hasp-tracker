package it.univpm.dii.utils;

import javax.swing.*;
import java.util.HashMap;

/**
 * Created by ilario
 * on 02/05/15.
 */
public class Menus extends HashMap<String, JMenu> {
    /**
     * @param key
     * @param menu
     * @return
     */
    public Menus add(String key, JMenu menu) {
        put(key, menu);
        return this;
    }
}
