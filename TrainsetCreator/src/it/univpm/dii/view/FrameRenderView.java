package it.univpm.dii.view;

import javax.swing.*;
import java.text.NumberFormat;

/**
 * Created by ilario
 * on 03/05/15.
 */
public class FrameRenderView extends View {
    private JButton avantiButton;
    private JButton indietroButton;
    private JPanel panel;
    private JFormattedTextField heightTextField;
    private JFormattedTextField widthTextField;

    public FrameRenderView() {
        frame = new JFrame("FrameRenderView");
        frame.setContentPane(panel);
        frame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        frame.pack();
        frame.setLocationRelativeTo(null);
    }

    public int getWidth() {
        return Integer.parseInt(widthTextField.getText());
    }

    public int getHeight() {
        return Integer.parseInt(heightTextField.getText());
    }

    public FrameRenderView setWidth(String width) {
        widthTextField.setText(width);
        return this;
    }

    public FrameRenderView setHeight(String height) {
        heightTextField.setText(height);
        return this;
    }

    public JButton getAvantiButton() {
        return avantiButton;
    }

    public JButton getIndietroButton() {
        return indietroButton;
    }

    private void createUIComponents() {
        NumberFormat pixelFormat = NumberFormat.getNumberInstance();
        pixelFormat.setMaximumFractionDigits(0);
        heightTextField = new JFormattedTextField(pixelFormat);
        widthTextField = new JFormattedTextField(pixelFormat);
    }
}
