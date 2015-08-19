package it.univpm.dii.view;

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.awt.image.AffineTransformOp;
import java.text.NumberFormat;

public class ResizeDialog extends JDialog {
    private JPanel contentPane;
    private JButton buttonOK;
    private JButton buttonCancel;
    private JFormattedTextField heightScaleField;
    private JFormattedTextField widthScaleField;
    private JProgressBar resizeProgressBar;
    private JLabel statusLabel;
    private JRadioButton nearestNeightborRadio;
    private JRadioButton bilinearInterpolationRadio;
    private JRadioButton bicubicInterpolationRadio;
    private JPanel resamplingAlgorithmPanel;
    private ButtonGroup resamplingButtonGroup;
    private int currentResizeProgress, numberOfImages;

    public ResizeDialog() {
        setContentPane(contentPane);
        setModal(true);
        getRootPane().setDefaultButton(buttonOK);

        // call closeWindow() when cross is clicked
        setDefaultCloseOperation(DO_NOTHING_ON_CLOSE);
        addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                closeWindow();
            }
        });

        // call closeWindow() on ESCAPE
        contentPane.registerKeyboardAction(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                closeWindow();
            }
        }, KeyStroke.getKeyStroke(KeyEvent.VK_ESCAPE, 0), JComponent.WHEN_ANCESTOR_OF_FOCUSED_COMPONENT);

        this.pack();
        this.setLocationRelativeTo(null);
    }

    private void closeWindow() {
        // add your code here if necessary
        dispose();
    }

    private void createUIComponents() {
        NumberFormat pixelFormat = NumberFormat.getNumberInstance();
        pixelFormat.setMaximumFractionDigits(0);
        widthScaleField = new JFormattedTextField(pixelFormat);
        heightScaleField = new JFormattedTextField(pixelFormat);

        /* Creazione del gruppo di radiobutton */
        nearestNeightborRadio = new JRadioButton("Nearest Neighbor");
        nearestNeightborRadio.setActionCommand(
                Integer.toString(AffineTransformOp.TYPE_NEAREST_NEIGHBOR)
        );

        bilinearInterpolationRadio = new JRadioButton("Bilinear Interpolation");
        bilinearInterpolationRadio.setActionCommand(
                Integer.toString(AffineTransformOp.TYPE_BILINEAR)
        );

        bicubicInterpolationRadio = new JRadioButton("Bicubic Interpolation");
        bicubicInterpolationRadio.setActionCommand(
                Integer.toString(AffineTransformOp.TYPE_BICUBIC)
        );

        resamplingButtonGroup = new ButtonGroup();
        resamplingButtonGroup.add(nearestNeightborRadio);
        resamplingButtonGroup.add(bilinearInterpolationRadio);
        resamplingButtonGroup.add(bicubicInterpolationRadio);
    }

    /**
     * Restituisce le dimensioni selezionate per gli elementi del dataset
     * dopo il resize.
     *
     * @return Dimensioni richieste.
     */
    public Dimension getResizeSampleDim() {
        int width, height;
        Dimension dim = null;

        width = widthScaleField.getValue() == null ?
                0 : Integer.parseInt(widthScaleField.getText());
        height = heightScaleField.getValue() == null ?
                0 : Integer.parseInt(heightScaleField.getText());

        if (width > 0 && height > 0) {
            dim = new Dimension(width, height);
        }

        return dim;
    }

    /**
     * Legge il codice del'algoritmo di resampling selezionato.
     *
     * @return Codice dell'algoritmo di resampling.
     */
    public int getResampleType() {
        String action = resamplingButtonGroup.getSelection().getActionCommand();
        int type = Integer.parseInt(action);
        // Controllo ulteriore sui valori
        switch (type) {
            case AffineTransformOp.TYPE_NEAREST_NEIGHBOR:
                return AffineTransformOp.TYPE_NEAREST_NEIGHBOR;
            case AffineTransformOp.TYPE_BILINEAR:
                return AffineTransformOp.TYPE_BILINEAR;
            case AffineTransformOp.TYPE_BICUBIC:
                return AffineTransformOp.TYPE_BICUBIC;
            default:
                return AffineTransformOp.TYPE_NEAREST_NEIGHBOR;
        }
    }

    /**
     * Inizializza la vista per il processo di resize
     *
     * @param max Numero di immagini da processare.
     */
    public void setupResizeProcess(int max) {
        numberOfImages = max;
        buttonOK.setEnabled(false);
        nearestNeightborRadio.setEnabled(false);
        bilinearInterpolationRadio.setEnabled(false);
        bicubicInterpolationRadio.setEnabled(false);
        widthScaleField.setEnabled(false);
        heightScaleField.setEnabled(false);
        resizeProgressBar.setEnabled(true);
        resizeProgressBar.setMinimum(0);
        resizeProgressBar.setMaximum(numberOfImages);
        currentResizeProgress = 0;
        statusLabel.setText("Inizio del resize");
    }

    /**
     * Incrementa il numero di immagini processate di 1.
     */
    public void increaseResizeProcess() {
        currentResizeProgress++;
        resizeProgressBar.setValue(currentResizeProgress);
        statusLabel.setText("Immagine " + currentResizeProgress + "/" + numberOfImages);
    }

    /**
     * Ripulisce la vista alla fine del processo di resize.
     */
    public void endResizeProcess() {
        currentResizeProgress = 0;
        resizeProgressBar.setValue(numberOfImages);
        resizeProgressBar.setEnabled(false);
        buttonOK.setEnabled(true);
        nearestNeightborRadio.setEnabled(true);
        bilinearInterpolationRadio.setEnabled(true);
        bicubicInterpolationRadio.setEnabled(true);
        widthScaleField.setEnabled(true);
        heightScaleField.setEnabled(true);
        statusLabel.setText("Fine");
    }

    public JButton getButtonOK() {
        return buttonOK;
    }

    public JButton getButtonCancel() {
        return buttonCancel;
    }

    public JFormattedTextField getHeightScaleField() {
        return heightScaleField;
    }

    public JFormattedTextField getWidthScaleField() {
        return widthScaleField;
    }

    public JProgressBar getResizeProgressBar() {
        return resizeProgressBar;
    }

    public JLabel getStatusLabel() {
        return statusLabel;
    }

    public JRadioButton getNearestNeightborRadio() {
        return nearestNeightborRadio;
    }

    public JRadioButton getBilinearInterpolationRadio() {
        return bilinearInterpolationRadio;
    }

    public JRadioButton getBicubicInterpolationRadio() {
        return bicubicInterpolationRadio;
    }
}
