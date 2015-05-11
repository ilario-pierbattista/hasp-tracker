package it.univpm.dii.model.entities;

/**
 * Created by ilario
 * on 01/05/15.
 */
public class Element {
    protected int id;
    private String fileName;
    private int width;
    private int height;
    private boolean positive;

    public int getId() {
        return id;
    }

    public Element setId(int id) {
        this.id = id;
        return this;
    }

    public String getFileName() {
        return fileName;
    }

    public Element setFileName(String fileName) {
        this.fileName = fileName;
        return this;
    }

    public int getWidth() {
        return width;
    }

    public Element setWidth(int width) {
        this.width = width;
        return this;
    }

    public int getHeight() {
        return height;
    }

    public Element setHeight(int height) {
        this.height = height;
        return this;
    }

    public boolean isPositive() {
        return positive;
    }

    public Element setPositive(boolean positive) {
        this.positive = positive;
        return this;
    }

    @Override
    public String toString() {
        return "Element{" +
                "id=" + id +
                ", fileName='" + fileName + '\'' +
                ", width=" + width +
                ", height=" + height +
                ", positive=" + positive +
                '}';
    }
}
