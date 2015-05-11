package it.univpm.dii.view.component;

import it.univpm.dii.service.DepthImage;

import javax.swing.*;
import java.awt.*;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;
import java.awt.image.BufferedImage;

/**
 * Created by ilario
 * on 03/05/15.
 */
public class DepthImagePanel extends JPanel implements MouseListener, MouseMotionListener {
    private BufferedImage image;
    private Point startPt, endPt, currentPt, offsetPt;
    private Rectangle rectangle;
    private int rWidth, rHeight, resize;
    public static final Color BORDER_COLOR = Color.BLUE;
    public static final Color DRAWING_COLOR = Color.GREEN;
    public static final int MVPX = 10;
    public static final int N_RESIZE = 0;
    public static final int NE_RESIZE = 1;
    public static final int NW_RESIZE = 2;
    public static final int S_RESIZE = 3;
    public static final int SE_RESIZE = 4;
    public static final int SW_RESIZE = 5;
    public static final int E_RESIZE = 6;
    public static final int W_RESIZE = 7;
    public static final int DO_NOT_RESIZE = 8;

    public DepthImagePanel(DepthImage depthImage) {
        image = depthImage.getImage();
        this.setPreferredSize(new Dimension(
                image.getWidth(),
                image.getHeight()
        ));
        addMouseListener(this);
        addMouseMotionListener(this);
    }

    public BufferedImage getImage() {
        return image;
    }

    public Rectangle getRectangle() {
        return rectangle;
    }

    /**
     * Imposta una nuova immagine
     *
     * @param image
     * @return
     */
    public DepthImagePanel setImage(BufferedImage image) {
        this.image = image;
        this.startPt = null;
        this.endPt = null;
        this.rectangle = null;
        return this;
    }

    /**
     * Imposta le dimensioni del rettangolo
     *
     * @param w Larghezza
     * @param h Altezza
     * @return Istanza di DepthImagePanel
     */
    public DepthImagePanel setRectangleDimensions(int w, int h) {
        if (w >= 0 && w < image.getWidth()) {
            rWidth = w;
        }
        if (h >= 0 && h < image.getHeight()) {
            rHeight = h;
        }
        return this;
    }

    /**
     * Resize forzato per un cambiamento dei valori di
     * rWidth ed rHeight
     *
     * @return
     */
    public DepthImagePanel forceResize() {
        if (rWidth == 0 || rHeight == 0) {
            return this;
        }

        if (rectangle.x + rWidth >= image.getWidth()) {
            rectangle.setBounds(
                    image.getWidth() - rWidth - 1,
                    rectangle.y,
                    rWidth,
                    rectangle.height
            );
        } else {
            rectangle.setBounds(
                    rectangle.x, rectangle.y,
                    rWidth, rectangle.height
            );
        }

        if (rectangle.y + rHeight >= image.getHeight()) {
            rectangle.setBounds(
                    rectangle.x,
                    image.getHeight() - rHeight - 1,
                    rectangle.width,
                    rHeight
            );
        } else {
            rectangle.setBounds(
                    rectangle.x, rectangle.y,
                    rectangle.width, rHeight
            );
        }

        DepthImagePanel.this.repaint();
        return this;
    }

    @Override
    public void mouseClicked(MouseEvent e) {

    }

    @Override
    public void mousePressed(MouseEvent e) {
        startPt = e.getPoint();
        if (rectangle != null && rectangle.contains(e.getPoint())) {
            offsetPt = new Point(
                    e.getX() - rectangle.x,
                    e.getY() - rectangle.y
            );
        }
    }

    @Override
    public void mouseDragged(MouseEvent e) {
        currentPt = e.getPoint();
        if (rectangle != null && rectangle.contains(currentPt)) {
            if (resize == DO_NOT_RESIZE) {
                moveRectangle();
            } else {
                resizeRectangle();
            }
        }
        DepthImagePanel.this.repaint();
    }

    @Override
    public void mouseReleased(MouseEvent e) {
        endPt = e.getPoint();
        /* creazione del rettangolo */
        if (rectangle == null) {
            rectangle = generateRectangle(startPt, endPt);
            // Impostazione delle dimensioni di default
            if (rWidth != 0 && rHeight != 0) {
                rectangle.setBounds(
                        rectangle.x, rectangle.y,
                        rWidth, rHeight
                );
            }
        }
        currentPt = null;
        DepthImagePanel.this.repaint();
    }

    @Override
    public void mouseEntered(MouseEvent e) {

    }

    @Override
    public void mouseExited(MouseEvent e) {

    }

    @Override
    public void mouseMoved(MouseEvent e) {
        if (rectangle != null && rectangle.contains(e.getPoint())) {
            if (rWidth == 0 && rHeight == 0) {
                if (rectangle.y + MVPX > e.getY() &&
                        rectangle.x + MVPX < e.getX() &&
                        rectangle.x + rectangle.width - MVPX > e.getX()) {
                    /** NORTH */
                    setCursor(Cursor.getPredefinedCursor(Cursor.N_RESIZE_CURSOR));
                    resize = N_RESIZE;
                } else if (rectangle.y + MVPX > e.getY() &&
                        rectangle.x + MVPX < e.getX() &&
                        rectangle.x + rectangle.width - MVPX < e.getX()) {
                    /** NORTH-EAST */
                    setCursor(Cursor.getPredefinedCursor(Cursor.NE_RESIZE_CURSOR));
                    resize = NE_RESIZE;
                } else if (rectangle.y + MVPX > e.getY() &&
                        rectangle.x + MVPX > e.getX() &&
                        rectangle.x + rectangle.width - MVPX > e.getX()) {
                    /** NORTH-WEST */
                    setCursor(Cursor.getPredefinedCursor(Cursor.NW_RESIZE_CURSOR));
                    resize = NW_RESIZE;
                } else if (rectangle.y + rectangle.height - MVPX < e.getY() &&
                        rectangle.x + MVPX < e.getX() &&
                        rectangle.x + rectangle.width - MVPX > e.getX()) {
                    /** SOUTH */
                    setCursor(Cursor.getPredefinedCursor(Cursor.S_RESIZE_CURSOR));
                    resize = S_RESIZE;
                } else if (rectangle.y + rectangle.height - MVPX < e.getY() &&
                        rectangle.x + MVPX < e.getX() &&
                        rectangle.x + rectangle.width - MVPX < e.getX()) {
                    /** SOUTH-EAST */
                    setCursor(Cursor.getPredefinedCursor(Cursor.SE_RESIZE_CURSOR));
                    resize = SE_RESIZE;
                } else if (rectangle.y + rectangle.height - MVPX < e.getY() &&
                        rectangle.x + MVPX > e.getX() &&
                        rectangle.x + rectangle.width - MVPX > e.getX()) {
                    /** SOUTH-WEST */
                    setCursor(Cursor.getPredefinedCursor(Cursor.SW_RESIZE_CURSOR));
                    resize = SW_RESIZE;
                } else if (rectangle.x + MVPX > e.getX() &&
                        rectangle.y + MVPX < e.getY() &&
                        rectangle.y + rectangle.height - MVPX > e.getY()) {
                    /** WEST */
                    setCursor(Cursor.getPredefinedCursor(Cursor.W_RESIZE_CURSOR));
                    resize = W_RESIZE;
                } else if (rectangle.x + rectangle.width - MVPX < e.getX() &&
                        rectangle.y + MVPX < e.getY() &&
                        rectangle.y + rectangle.height - MVPX > e.getY()) {
                    /** EAST */
                    setCursor(Cursor.getPredefinedCursor(Cursor.E_RESIZE_CURSOR));
                    resize = E_RESIZE;
                } else {
                    setCursor(Cursor.getPredefinedCursor(Cursor.MOVE_CURSOR));
                    resize = DO_NOT_RESIZE;
                }
            } else {
                setCursor(Cursor.getPredefinedCursor(Cursor.MOVE_CURSOR));
                resize = DO_NOT_RESIZE;
            }
        } else {
            setCursor(Cursor.getDefaultCursor());
        }
    }

    @Override
    protected void paintComponent(Graphics g) {
        g.drawImage(image, 0, 0, this);

        /* Painting del rettangolo durante la selezione dell'area */
        if (rectangle == null && startPt != null && currentPt != null) {
            g.setColor(DRAWING_COLOR);
            Rectangle r = generateRectangle(startPt, currentPt);
            g.drawRect(r.x, r.y, r.width, r.height);
        } else if (rectangle != null) {
            g.setColor(BORDER_COLOR);
            g.drawRect(rectangle.x, rectangle.y, rectangle.width, rectangle.height);
        }
    }

    /**
     * Genera la figura del rettangolo
     *
     * @return Rettangolo generato
     */
    private Rectangle generateRectangle(Point sp, Point ep) {
        Rectangle r = new Rectangle();
        int x = Math.min(sp.x, ep.x);
        int y = Math.min(sp.y, ep.y);
        int width = Math.abs(sp.x - ep.x);
        int height = Math.abs(sp.y - ep.y);
        r.setBounds(x, y, width, height);
        return r;
    }

    /**
     * Muove il rettangolo
     */
    private void moveRectangle() {
        Point tl, br;
        tl = new Point(currentPt.x - offsetPt.x, currentPt.y - offsetPt.y);
        br = new Point(tl.x + rectangle.width, tl.y + rectangle.height);
        if (tl.x >= 0 && tl.y >= 0 &&
                br.x < image.getWidth() && br.y < image.getHeight()) {
            rectangle.setLocation(tl);
        } else if (tl.x >= 0 && br.x < image.getWidth() && (
                tl.y < 0 || br.y >= image.getHeight()
        )) {
            rectangle.setLocation(tl.x, rectangle.y);
        } else if (tl.y >= 0 && br.y < image.getHeight() && (
                tl.x < 0 || br.x >= image.getWidth()
        )) {
            rectangle.setLocation(rectangle.x, tl.y);
        }
    }

    /**
     * Ridimensiona il rettangolo
     */
    private void resizeRectangle() {
        if (resize == W_RESIZE) {
            resizeW();
        } else if (resize == E_RESIZE) {
            resizeE();
        } else if (resize == N_RESIZE) {
            resizeN();
        } else if (resize == S_RESIZE) {
            resizeS();
        } else if (resize == NW_RESIZE) {
            resizeW();
            resizeN();
        } else if (resize == NE_RESIZE) {
            resizeE();
            resizeN();
        } else if (resize == SW_RESIZE) {
            resizeW();
            resizeS();
        } else if (resize == SE_RESIZE) {
            resizeE();
            resizeS();
        }
    }

    /**
     * Resize dal lato ovest
     */
    private void resizeW() {
        int newX = currentPt.x - MVPX;
        if (newX >= 0) {
            int newWidth = rectangle.x + rectangle.width - newX;
            rectangle.setBounds(newX, rectangle.y, newWidth, rectangle.height);
        }
    }

    /**
     * Resize lato est
     */
    private void resizeE() {
        int newEndX = currentPt.x + MVPX;
        if (newEndX < image.getWidth()) {
            int newWidth = newEndX - rectangle.x;
            rectangle.setBounds(rectangle.x, rectangle.y, newWidth, rectangle.height);
        }
    }

    /**
     * Resize a nord
     */
    private void resizeN() {
        int newY = currentPt.y - MVPX;
        if (newY >= 0) {
            int newHeight = rectangle.y + rectangle.height - newY;
            rectangle.setBounds(rectangle.x, newY, rectangle.width, newHeight);
        }
    }

    /**
     * Resize a sud
     */
    private void resizeS() {
        int newEndY = currentPt.y + MVPX;
        if (newEndY < image.getHeight()) {
            int newHeight = newEndY - rectangle.y;
            rectangle.setBounds(rectangle.x, rectangle.y, rectangle.width, newHeight);
        }
    }
}
