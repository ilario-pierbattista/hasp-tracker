package it.univpm.dii.view;

import it.univpm.dii.model.DatasetManager;
import it.univpm.dii.model.entities.Element;
import it.univpm.dii.service.DepthImage;
import it.univpm.dii.utils.MenuItems;
import it.univpm.dii.utils.Menus;
import it.univpm.dii.view.component.DepthImagePanel;
import it.univpm.dii.view.component.SampleTable;
import it.univpm.dii.view.tablemodels.ElementModel;

import javax.swing.*;
import java.awt.*;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

/**
 * Created by ilario
 * on 01/05/15.
 */
public class MainFrame extends View {
    private static MainFrame instance;

    // Dimensioni della finestra di preview
    private static final int PREVIEW_WIDTH = 200;
    private static final int PREVIEW_HEIGHT = 200;

    private JMenuBar menuBar;
    private MenuItems menuItems;
    private Menus menus;
    private JPanel mainPanel;
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
        frame.setContentPane(mainPanel);
        frame.setDefaultCloseOperation(JFrame.DO_NOTHING_ON_CLOSE);
        createMenuBar();
        frame.pack();
        frame.setLocationRelativeTo(null);
        instance = this;
        enableEdit(false);
    }

    @Override
    public void refresh() {
        DatasetManager dm = DatasetManager.getInstance();
        if (dm != null) {   // C'è un'istanza attiva di DatasetManager
            posNumLabel.setText(Integer.toString(dm.getTrainingSet().getPositives().size()));
            negNumLabel.setText(Integer.toString(dm.getTrainingSet().getNegatives().size()));

            if (dm.getTrainingSet() != null) {
                ElementModel tableModel = (ElementModel) sampleTable.getModel();
                tableModel.setData(dm.getTrainingSet());
            }
        } else {    // Non c'è un'istanza attiva di DatasetManager
            posNumLabel.setText("-");
            negNumLabel.setText("-");
        }
    }

    /**
     * Crea la barra del menu
     */
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
        menus.add("export", new JMenu("Esporta"));
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
        JMenu file_recent = new JMenu("Aperti di recente");
        menuItems.add("file_recent", file_recent);

        /* Resize set */
        JMenuItem resize = new JMenuItem("Resize");
        menuItems.add("export_resize", resize);
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

    /**
     * Imposta la path del dataset corrente
     *
     * @param path Path del dataset
     */
    public void setDatasetPath(File path) {
        if (path == null) {
            aggiungiButton.setEnabled(false);
            trainsetLabel.setText("Nessun database di allenamento aperto");
            trainsetLabel.setEnabled(false);
            menuItems.get("export_resize").setEnabled(false);
        } else {
            aggiungiButton.setEnabled(true);
            trainsetLabel.setText("Database: " + path.getAbsolutePath());
            trainsetLabel.setEnabled(true);
            menuItems.get("export_resize").setEnabled(true);
        }
    }

    /**
     * Abilitazione/Disabilitazione dei pulsanti di modifica e cancellazione
     *
     * @param enable Abilitazione/Disabilitazione
     */
    public void enableEdit(boolean enable) {
        eliminaButton.setEnabled(enable);
        modificaButton.setEnabled(enable);
    }

    /**
     * Imposta la lista dei dataset utilizzati più di recente nella lista del menu
     *
     * @param paths Path dei dataset utilizzati di recente
     */
    public void setRecents(ArrayList<File> paths) {
        JMenuItem item;
        JMenu recent = (JMenu) menuItems.get("file_recent");
        recent.removeAll();
        if (paths.size() > 0) {
            for (File path : paths) {
                item = new JMenuItem(path.getAbsolutePath());
                recent.add(item);
            }
            recent.setEnabled(true);
        } else {
            recent.setEnabled(false);
        }
        this.refresh();
    }

    /**
     * Restituisce l'elemento selezionato
     *
     * @return Elemento selezionato
     */
    public Element getSelectedElement() {
        ElementModel model = (ElementModel) sampleTable.getModel();
        return model.getRow(sampleTable.getSelectedRow());
    }

    /**
     * Aggiorna il pannello della preview
     *
     * @param e Elemento di cui mostrare la preview
     * @throws IOException
     */
    public void updatePreviewPanel(Element e) throws IOException {
        DepthImage depthImage = new DepthImage(
                new File(e.getFileName()),
                e.getWidth(),
                e.getHeight());
        previewImagePanel.setDepthImage(depthImage);
    }

    /**
     * Aggiunge un elemento appena inserito nel dataset alla vista principale
     *
     * @param element Elemento da inserire
     */
    public void addElement(Element element) {
        ElementModel model = (ElementModel) this.sampleTable.getModel();
        model.addElement(element);
        if (element.isPositive()) {
            setPositiveSamplesNumber(getPositiveSamplesNumber() + 1);
        } else {
            setNegativeSamplesNumber(getNegativeSamplesNumber() + 1);
        }
    }

    /**
     * Rimuove un elemento del dataset dalla vista principale
     *
     * @param element Elemento da rimuovere
     */
    public void removeElement(Element element) {
        ElementModel model = (ElementModel) this.sampleTable.getModel();
        model.removeElement(element);
        if (element.isPositive()) {
            setPositiveSamplesNumber(getPositiveSamplesNumber() - 1);
        } else {
            setNegativeSamplesNumber(getNegativeSamplesNumber() - 1);
        }
    }

    public void updateElement(Element element) {
        ElementModel model = (ElementModel) this.sampleTable.getModel();
        model.updateElement(element);
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

    /**
     * Creazione custom dei componenti grafici della vista
     */
    private void createUIComponents() {
        previewImagePanel = new DepthImagePanel(DepthImagePanel.MODE_PREVIEW);
        previewImagePanel.setPreferredSize(new Dimension(PREVIEW_WIDTH, PREVIEW_HEIGHT));
    }

    public static MainFrame getInstance() {
        return instance;
    }

    private int getPositiveSamplesNumber() {
        return Integer.parseInt(posNumLabel.getText());
    }

    private MainFrame setPositiveSamplesNumber(int n) {
        posNumLabel.setText(Integer.toString(n));
        return this;
    }

    private int getNegativeSamplesNumber() {
        return Integer.parseInt(negNumLabel.getText());
    }

    private MainFrame setNegativeSamplesNumber(int n) {
        negNumLabel.setText(Integer.toString(n));
        return this;
    }
}
