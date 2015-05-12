package it.univpm.dii.view.component;

import javax.swing.*;
import java.awt.*;

/**
 * @version 1.0 02/26/99
 */
public class BevelArrowIcon implements Icon {
    public static final int UP = 0;         // direction
    public static final int DOWN = 1;

    private static final int DEFAULT_SIZE = 8;

    private Color edge1;
    private Color edge2;
    private Color fill;
    private int size;
    private int direction;

    public BevelArrowIcon(int direction, boolean isRaisedView, boolean isPressedView) {
        if (isRaisedView) {
            if (isPressedView) {
                init(UIManager.getColor("controlLtHighlight"),
                        DEFAULT_SIZE, direction);
            } else {
                init(UIManager.getColor("controlHighlight"),
                        DEFAULT_SIZE, direction);
            }
        } else {
            if (isPressedView) {
                init(UIManager.getColor("controlDkShadow"),
                        DEFAULT_SIZE, direction);
            } else {
                init(UIManager.getColor("Label.disabledText"),
                        DEFAULT_SIZE, direction);
            }
        }
    }

    public BevelArrowIcon(Color edge1, Color edge2, Color fill,
                          int size, int direction) {
        init(edge1, edge2, fill, size, direction);
    }

    public void paintIcon(Component c, Graphics g, int x, int y) {
        switch (direction) {
            case DOWN:
                drawDownArrow(g, x, y);
                break;
            case UP:
                drawUpArrow(g, x, y);
                break;
        }
    }

    public int getIconWidth() {
        return size;
    }

    public int getIconHeight() {
        return size;
    }


    private void init(Color edge1, Color edge2, Color fill,
                      int size, int direction) {
        this.edge1 = edge1;
        this.edge2 = edge2;
        this.fill = fill;
        this.size = size;
        this.direction = direction;
    }

    private void init(Color color, int size, int direction) {
        this.edge1 = color;
        this.edge2 = color;
        this.fill = color;
        this.size = size;
        this.direction = direction;
    }

    private void drawDownArrow(Graphics g, int x0, int y0) {
        g.setColor(edge1);
        int[] X = {x0, x0 + DEFAULT_SIZE, x0 + DEFAULT_SIZE/2};
        int[] Y = {y0, y0, y0 + DEFAULT_SIZE};
        Polygon arrow = new Polygon(X, Y, X.length);
        g.drawPolygon(arrow);
        g.fillPolygon(arrow);
    }

    private void drawUpArrow(Graphics g, int x0, int y0) {
        g.setColor(edge1);
        int[] X = {x0, x0 + DEFAULT_SIZE, x0 + DEFAULT_SIZE/2};
        int[] Y = {y0 + DEFAULT_SIZE, y0 + DEFAULT_SIZE, y0};
        Polygon arrow = new Polygon(X, Y, X.length);
        g.drawPolygon(arrow);
        g.fillPolygon(arrow);
    }
}