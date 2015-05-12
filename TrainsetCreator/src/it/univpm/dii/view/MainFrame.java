package it.univpm.dii.view;

import it.univpm.dii.model.DatasetManager;
import it.univpm.dii.utils.MenuItems;
import it.univpm.dii.utils.Menus;
import it.univpm.dii.view.component.DepthImagePanel;
import it.univpm.dii.view.component.SampleTable;
import it.univpm.dii.view.tablemodels.ElementModel;

import javax.swing.*;
import javax.swing.table.JTableHeader;
import java.awt.*;
import java.io.File;

/**
 * Created by ilario
 * on 01/05/15.
 */
public class MainFrame extends View {

    private JMenuBar menuBar;
    private MenuItems menuItems;
    private Menus menus;
    private JPanel panel1;
    private JTable sampleTable;
    private JButton aggiungiButton;
    private JButton eliminaButton;
    private JButton modificaButton;
    private JLabel trainsetLabel;
    private JLabel posNumLabel;
    private JLabel negNumLabel;
    private DepthImagePanel previewImagePanel;

    public MainFrame() {
        menuItems = new MenuItems();
        menus = new Menus();

        frame = new JFrame("Training Set Creator");
        frame.setContentPane(panel1);
        frame.setDefaultCloseOperation(JFrame.DO_NOTHING_ON_CLOSE);
        createMenuBar();
        frame.pack();
        frame.setLocationRelativeTo(null);
    }

    @Override
    public void refresh() {
        DatasetManager dm = DatasetManager.getInstance();
        if (dm != null) {   // C'è un'istanza attiva di DatasetManager
            posNumLabel.setText(Integer.toString(dm.getTrainSet().getPositives().size()));
            negNumLabel.setText(Integer.toString(dm.getTrainSet().getNegatives().size()));

            if(dm.getTrainSet() != null) {
                ElementModel tableModel = (ElementModel) sampleTable.getModel();
                tableModel.setData(dm.getTrainSet());
            }
        } else {    // Non c'è un'istanza attiva di DatasetManager
            posNumLabel.setText("-");
            negNumLabel.setText("-");
        }
    }

    private void createMenuBar() {
        menuBar = new JMenuBar();

        createMenu();
        createMenuItems();

        /* Aggiunta dei menuitems ai menu */
        for (MenuItems.Entry<String, JMenuItem> menuItemsEntry : menuItems.entrySet()) {
            String menuKey = getMenuFromMenuItemKey(menuItemsEntry.getKey());
            if (menuKey != null) {
                menus.get(menuKey).add(menuItemsEntry.getValue());
            }
        }

        /* Aggiunta dei menu alla menubar */
        for (Menus.Entry<String, JMenu> menuEntry : menus.entrySet()) {
            menuBar.add(menuEntry.getValue());
        }

        frame.setJMenuBar(menuBar);
    }

    private void createMenu() {
        menus.add("file", new JMenu("File"));
        //.add("insert", new JMenu("Inserisci"));
    }

    private void createMenuItems() {
        /* Nuovo set */
        JMenuItem file_new = new JMenuItem("Nuovo set");
        file_new.setAccelerator(KeyStroke.getKeyStroke('N', Toolkit.getDefaultToolkit().getMenuShortcutKeyMask()));
        menuItems.add("file_new", file_new);

        /* Apri set */
        JMenuItem file_open = new JMenuItem("Apri set");
        file_open.setAccelerator(KeyStroke.getKeyStroke('O', Toolkit.getDefaultToolkit().getMenuShortcutKeyMask()));
        menuItems.add("file_open", file_open);

        /* Apri recenti */
        JMenuItem file_recent = new JMenuItem("Aperti di recente");
        menuItems.add("file_recent", file_recent);

        /* Salva il set */
        JMenuItem file_save = new JMenuItem("Salva");
        file_save.setAccelerator(KeyStroke.getKeyStroke('S', Toolkit.getDefaultToolkit().getMenuShortcutKeyMask()));
        menuItems.add("file_save", file_save);
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

    public void setDatasetPath(File path) {
        if (path == null) {
            aggiungiButton.setEnabled(false);
            eliminaButton.setEnabled(false);
            modificaButton.setEnabled(false);
            trainsetLabel.setText("Nessun database di allenamento aperto");
            trainsetLabel.setEnabled(false);
        } else {
            aggiungiButton.setEnabled(true);
            eliminaButton.setEnabled(true);
            modificaButton.setEnabled(true);
            trainsetLabel.setText("Database: " + path.getAbsolutePath());
            trainsetLabel.setEnabled(true);
        }
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

    public JLabel getTrainsetLabel() {
        return trainsetLabel;
    }

    public SampleTable getSampleTable() {
        return (SampleTable) sampleTable;
    }

    public DepthImagePanel getPreviewImagePanel() {
        return previewImagePanel;
    }

    private void createUIComponents() {
        previewImagePanel = new DepthImagePanel(DepthImagePanel.MODE_PREVIEW);
        previewImagePanel.setPreferredSize(new Dimension(200, 200));
    }
}
