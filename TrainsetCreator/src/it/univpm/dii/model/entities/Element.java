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
    private int x;
    private int y;
    private boolean positive;

    public Element() {
        super();
    }

    public Element(Element e) {
        this.id = e.getId();
        this.fileName = e.getFileName();
        this.width = e.getWidth();
        this.height = e.getHeight();
        this.x = e.getX();
        this.y = e.getY();
        this.positive = e.isPositive();
    }

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

    public int getX() {
        return x;
    }

    public Element setX(int x) {
        this.x = x;
        return this;
    }

    public int getY() {
        return y;
    }

    public Element setY(int y) {
        this.y = y;
        return this;
    }

    public boolean equals(Element obj) {
        if (this == obj) {
            return true;
        } else if (this.id == obj.getId()) {
            return true;
        }
        return false;
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
