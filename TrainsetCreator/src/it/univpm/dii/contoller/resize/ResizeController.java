package it.univpm.dii.contoller.resize;

import it.univpm.dii.view.ResizeDialog;

/**
 * Created by ilario
 * on 17/08/15.
 */
public class ResizeController {
    private ResizeDialog view;
    private boolean stopResizeAction = false,
            resizeDone = false,
            resizeRunning = false;
    private static ResizeController instance;

    public ResizeController() {
        instance = this;
        view = new ResizeDialog();
        setupView();
        view.setVisible(true);
    }

    /**
     * Configura la vista con impostazioni di default e listeners
     */
    private void setupView() {
        // Valori di default
        view.getNearestNeightborRadio().setSelected(true);
        view.getStatusLabel().setText("Selezionare la dimensione");
        view.getButtonOK().setEnabled(false);
        view.getResizeProgressBar().setEnabled(false);

        // Listeners
        SizeFieldChangeAction sfc = new SizeFieldChangeAction(view);
        view.getWidthScaleField().addPropertyChangeListener(sfc);
        view.getHeightScaleField().addPropertyChangeListener(sfc);
        view.getButtonOK().addActionListener(new ResizeSetAction(view));
        view.getButtonCancel().addActionListener(new CancelAction(view));
    }

    public static ResizeController getInstance() {
        return ResizeController.instance;
    }

    public boolean isStopResizeAction() {
        return stopResizeAction;
    }

    public ResizeController setStopResizeAction(boolean stopResizeAction) {
        this.stopResizeAction = stopResizeAction;
        return this;
    }

    public boolean isResizeDone() {
        return resizeDone;
    }

    public void setResizeDone(boolean resizeDone) {
        this.resizeDone = resizeDone;
    }

    public boolean isResizeRunning() {
        return resizeRunning;
    }

    public void setResizeRunning(boolean resizeRunning) {
        this.resizeRunning = resizeRunning;
    }
}
