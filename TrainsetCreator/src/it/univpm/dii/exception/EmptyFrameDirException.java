package it.univpm.dii.exception;

/**
 * Created by ilario
 * on 03/05/15.
 */
public class EmptyFrameDirException extends Exception {
    public EmptyFrameDirException(String path) {
        super("Non ci sono file .bin nella cartella '" + path + "'");
    }
}
