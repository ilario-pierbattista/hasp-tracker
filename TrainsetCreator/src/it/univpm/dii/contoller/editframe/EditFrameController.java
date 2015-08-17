package it.univpm.dii.contoller.editframe;

import it.univpm.dii.model.entities.Element;
import it.univpm.dii.view.EditDialog;

/**
 * Created by ilario
 * on 27/06/15.
 */
public class EditFrameController {
    private EditDialog view;

    public EditFrameController(Element element) {
        view = new EditDialog(element);
        view.getButtonOK().addActionListener(new OkButtonListener(view, element));
        view.setVisible(true);
    }
}
