package it.univpm.dii.contoller;

import it.univpm.dii.view.MainFrame;
import it.univpm.dii.view.View;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

/**
 * Created by ilario
 * on 02/05/15.
 */
public class MainController {
    MainFrame view;

    public MainController(MainFrame view) {
        this.view = view;
        actionSetter();
        this.view.setVisible(true);
    }

    public void actionSetter() {
        view.getMenuItems().get("file_new")
                .addActionListener(new NewTrainingSetAction(view));
    }

    class NewTrainingSetAction implements ActionListener {
        View v;
        public NewTrainingSetAction(View v) {
            this.v = v;
        }

        @Override
        public void actionPerformed(ActionEvent e) {
            JFileChooser jf = new JFileChooser();
            System.out.println(jf.showOpenDialog(v.frame));
        }
    }
}
