package it.univpm.dii.view;

import it.univpm.dii.model.entities.Element;

import javax.swing.*;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;
import java.awt.event.*;

public class EditDialog extends JDialog {
    private JPanel contentPane;
    private JButton buttonOK;
    private JButton buttonCancel;
    private JRadioButton positivoRadioButton;
    private JRadioButton negativoRadioButton;
    private JLabel nameLabel;
    private Element element;

    public EditDialog(Element element) {
        setContentPane(contentPane);
        setModal(true);
        getRootPane().setDefaultButton(buttonOK);

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

        setElement(element);

        RadioButtonHandler handler = new RadioButtonHandler();
        positivoRadioButton.addChangeListener(handler);
        negativoRadioButton.addChangeListener(handler);

        // call onCancel() on ESCAPE
        contentPane.registerKeyboardAction(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                onCancel();
            }
        }, KeyStroke.getKeyStroke(KeyEvent.VK_ESCAPE, 0), JComponent.WHEN_ANCESTOR_OF_FOCUSED_COMPONENT);

        this.pack();
        this.setLocationRelativeTo(null);
    }

    /**
     * Imposta i dati dell'elemento
     * @param element Elemento
     * @return Istanza di {@link EditDialog}
     */
    public EditDialog setElement(Element element) {
        this.element = element;
        nameLabel.setText(element.getFileName());
        if (element.isPositive()) {
            positivoRadioButton.setSelected(true);
            negativoRadioButton.setSelected(false);
        } else {
            positivoRadioButton.setSelected(false);
            negativoRadioButton.setSelected(true);
        }
        return this;
    }

    private void onCancel() {
        dispose();
    }

    public boolean getNewPositiveness() {
        return positivoRadioButton.isSelected() && !negativoRadioButton.isSelected();
    }

    class RadioButtonHandler implements ChangeListener {
        @Override
        public void stateChanged(ChangeEvent e) {
            mutualExclusion(e);
        }

        private void mutualExclusion(ChangeEvent e) {
            if (e.getSource() == positivoRadioButton) {
                negativoRadioButton.setSelected(!positivoRadioButton.isSelected());
            } else if (e.getSource() == negativoRadioButton) {
                positivoRadioButton.setSelected(!negativoRadioButton.isSelected());
            }
        }
    }

    public JButton getButtonOK() {
        return buttonOK;
    }
}
