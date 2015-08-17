package it.univpm.dii.view;

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.awt.geom.AffineTransform;
import java.awt.image.AffineTransformOp;

public class ResizeDialog extends JDialog {
    private JPanel contentPane;
    private JButton buttonOK;
    private JButton buttonCancel;
    private JFormattedTextField heightScaleField;
    private JFormattedTextField widthScaleField;
    private JProgressBar progressBar1;
    private JLabel statusLabel;
    private JRadioButton nearestNeightborRadioButton;
    private JRadioButton bilinearInterpolationRadioButton;
    private JRadioButton bicubicInterpolationRadioButton;
    private JPanel resamplingAlgorithmPanel;
    private ButtonGroup resamplingButtonGroup;

    public ResizeDialog() {
        setContentPane(contentPane);
        setModal(true);
        getRootPane().setDefaultButton(buttonOK);

        buttonOK.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                onOK();
            }
        });

        buttonCancel.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                onCancel();
            }
        });

        // call onCancel() when cross is clicked
        setDefaultCloseOperation(DO_NOTHING_ON_CLOSE);
        addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                onCancel();
            }
        });

        // call onCancel() on ESCAPE
        contentPane.registerKeyboardAction(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                onCancel();
            }
        }, KeyStroke.getKeyStroke(KeyEvent.VK_ESCAPE, 0), JComponent.WHEN_ANCESTOR_OF_FOCUSED_COMPONENT);

        this.pack();
        this.setLocationRelativeTo(null);
    }

    private void onOK() {
        // add your code here
        dispose();
    }

    private void onCancel() {
        // add your code here if necessary
        dispose();
    }

    private void createUIComponents() {
        /* Creazione del gruppo di radiobutton */
        this.resamplingButtonGroup = new ButtonGroup();
        nearestNeightborRadioButton.setActionCommand(
                Integer.toString(AffineTransformOp.TYPE_NEAREST_NEIGHBOR)
        );
        bilinearInterpolationRadioButton.setActionCommand(
                Integer.toString(AffineTransformOp.TYPE_BILINEAR)
        );
        bicubicInterpolationRadioButton.setActionCommand(
                Integer.toString(AffineTransformOp.TYPE_BICUBIC)
        );
        resamplingButtonGroup.add(nearestNeightborRadioButton);
        resamplingButtonGroup.add(bilinearInterpolationRadioButton);
        resamplingButtonGroup.add(bicubicInterpolationRadioButton);
    }
}
