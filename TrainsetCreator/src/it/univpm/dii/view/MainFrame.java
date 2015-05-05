package it.univpm.dii.view;

import it.univpm.dii.utils.MenuItems;
import it.univpm.dii.utils.Menus;

import java.awt.*;
import java.util.HashMap;
import javax.swing.*;

/**
 * Created by ilario
 * on 01/05/15.
 */
public class MainFrame extends View {

    private JMenuBar menuBar;
    private MenuItems menuItems;
    private Menus menus;
    private JPanel panel1;
    private JTable table1;
    private JButton aggiungiButton;
    private JButton eliminaButton;
    private JButton modificaButton;
    private JLabel trainsetLabel;

    public MainFrame() {
        menuItems = new MenuItems();
        menus = new Menus();

        frame = new JFrame("MainFrame");
        frame.setContentPane(panel1);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        createMenuBar();
        frame.pack();
        frame.setLocationRelativeTo(null);
    }

    private void createMenuBar() {
        menuBar = new JMenuBar();

        createMenu();
        createMenuItems();

        /* Aggiunta dei menuitems ai menu */
        for (MenuItems.Entry<String, JMenuItem> menuItemsEntry : menuItems.entrySet()) {
            String menuKey = getMenuFromMenuItemKey(menuItemsEntry.getKey());
            if(menuKey != null) {
                menus.get(menuKey).add(menuItemsEntry.getValue());
            }
        }

        /* Aggiunta dei menu alla menubar */
        for(Menus.Entry<String, JMenu> menuEntry : menus.entrySet()) {
            menuBar.add(menuEntry.getValue());
        }

        frame.setJMenuBar(menuBar);
    }

    private void createMenu() {
        menus.add("file", new JMenu("File"))
                .add("insert", new JMenu("Inserisci"));
    }

    private void createMenuItems() {
        menuItems.add("file_new", new JMenuItem("Nuovo set"))
                .add("file_open", new JMenuItem("Apri set"))
                .add("insert_from_frameset", new JMenuItem("Frame da una Registrazione"));
    }

    private String getMenuFromMenuItemKey(String mikey) {
        String[] parts = mikey.split("_");
        String key = null;
        try {
            key = parts[0];
        } catch (NullPointerException ee) {
            ee.printStackTrace();
        }
        return key;
    }

    public MenuItems getMenuItems() {
        return menuItems;
    }

    public Menus getMenus() {
        return menus;
    }

    public JButton getAggiungiButton() {
        return aggiungiButton;
    }

    public JButton getEliminaButton() {
        return eliminaButton;
    }

    public JButton getModificaButton() {
        return modificaButton;
    }
}
