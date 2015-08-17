package it.univpm.dii.contoller.main;

import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;

/**
 * Implementa la chiusura del programma
 */
class QuitAction extends WindowAdapter {
    @Override
    public void windowClosing(WindowEvent e) {
        /* @TODO Implementare una logica di uscita migliore */
        System.exit(0);
    }
}