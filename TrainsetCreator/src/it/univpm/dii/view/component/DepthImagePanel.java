package it.univpm.dii.view.component;

import it.univpm.dii.service.DepthImage;
import org.w3c.dom.css.Rect;

import javax.swing.*;
import java.awt.*;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;
import java.awt.geom.Line2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.util.ArrayList;

/**
 * Created by ilario
 * on 03/05/15.
 */
public class DepthImagePanel extends JPanel implements MouseListener, MouseMotionListener {
    private DepthImage depthImage;
    private BufferedImage image;
    private Point startPt, endPt, currentPt, offsetPt;
    private Rectangle rectangle;
    private int rWidth, rHeight, resize;
    private int mode, flipDirection = DISABLE_FLIP;
    public static final Color BORDER_COLOR = Color.BLUE;
    public static final Color DRAWING_COLOR = Color.GREEN;
    public static final Color GRID_COLOR = Color.RED;
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
    public static final int MODE_PREVIEW = 0;
    public static final int MODE_CROP = 1;
    public static final int DISABLE_FLIP = 0;
    public static final int X_FLIP = 1;
    public static final int Y_FLIP = 2;

    /**
     * Costruisce il componente senza impostarne l'immagine
     *
     * @param mode Modalità. Valori ammessi MODE_CROP e MODE_PREVIEW.
     */
    public DepthImagePanel(int mode) {
        this.mode = mode;
        setListeners();
    }

    /**
     * Costruisce il componente
     *
     * @param depthImage Immagine da impostare
     * @param mode       Modalità del componente. Valori ammessi MODE_PREVIEW
     *                   e MODE_CROP
     */
    public DepthImagePanel(DepthImage depthImage, int mode) {
        this.depthImage = depthImage;
        this.mode = mode;
        image = this.depthImage.getImage();
        setPreferredSize(image);
        setListeners();
    }

    /**
     * Costruisce il componente in modalità CROP impostando
     * un'immagine
     *
     * @param depthImage Immagine
     */
    public DepthImagePanel(DepthImage depthImage) {
        this(depthImage, MODE_CROP);
        this.mode = MODE_CROP;
    }

    /**
     * Imposta le dimensioni preferite del componente in base alla dimensione
     * dell'immagine
     *
     * @param image Immagine
     * @return Il componente stesso
     */
    public DepthImagePanel setPreferredSize(BufferedImage image) {
        this.setPreferredSize(new Dimension(
                image.getWidth(),
                image.getHeight()
        ));
        return this;
    }

    /**
     * Imposta i listeners in entrambe le modalità
     */
    public void setListeners() {
        switch (this.mode) {
            case MODE_CROP:
                addMouseListener(this);
                addMouseMotionListener(this);
                break;
            case MODE_PREVIEW:
                break;
            default:
                break;
        }
    }

    /**
     * Imposta una nuova immagine
     *
     * @param depthImage DepthImage da impostare
     * @return Istanza corrente di DepthImagePanel
     */
    public DepthImagePanel setDepthImage(DepthImage depthImage) {
        this.depthImage = depthImage;
        image = this.depthImage.getImage();
        setPreferredSize(image);
        this.startPt = null;
        this.endPt = null;
        this.rectangle = null;
        this.repaint();
        return this;
    }

    /**
     * Restituisce il rettangolo disegnato
     *
     * @return Rettangolo
     */
    public Rectangle getRectangle() {
        return rectangle;
    }

    /**
     * Imposta la direzione dell'operazione di flipping
     *
     * @param direction Direzione.
     * @return Componente.
     */
    public DepthImagePanel setFlipDirection(int direction) {
        this.flipDirection = direction;
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
     * Salva la porzione selezionata
     *
     * @param out File dove salvare l'immagine
     * @return Istanza corrente di DepthImagePanel
     */
    public DepthImagePanel cropAndSave(File out) {
        if (rectangle != null) {
            try {
                depthImage.crop(rectangle.x, rectangle.y, rectangle.width, rectangle.height);
                depthImage.save(out);
            } catch (Exception ee) {
                ee.printStackTrace();
            }
        }
        return this;
    }

    /**
     * Resize forzato per un cambiamento dei valori di
     * rWidth ed rHeight
     *
     * @return Istanza attiva di DepthImagePanel
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
        if (SwingUtilities.isRightMouseButton(e)) {
            switch (this.flipDirection) {
                case X_FLIP:
                    depthImage.flipVertical();
                    image = depthImage.getImage();
                    repaint();
                    break;
                case Y_FLIP:
                    depthImage.flipHorizontal();
                    image = depthImage.getImage();
                    break;
                default:
                    break;
            }
        }
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
        if (this.mode == MODE_PREVIEW) { // Serve a cancellare l'immagine disegnata in precedenza
            g.setColor(getBackground());
            g.fillRect(0, 0, getWidth(), getHeight());
        }

        g.drawImage(image, 0, 0, this);

        if (this.mode == MODE_CROP) {
            drawGrid(g, GRID_COLOR);
        }

        /* Painting del rettangolo durante la selezione dell'area */
        if (rectangle == null && startPt != null && currentPt != null) {
            Rectangle r = generateRectangle(startPt, currentPt);
            drawRectangle(g, r, DRAWING_COLOR);
        } else if (rectangle != null) {
            drawRectangle(g, rectangle, BORDER_COLOR);
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
     * Disegna un rettangolo con griglia
     *
     * @param g     Componente grafico su cui disegnare il rettangolo
     * @param r     Rettangolo
     * @param color Colore dei bordi del rettangolo
     */
    private void drawRectangle(Graphics g, Rectangle r, Color color) {
        int midx, midy;
        midx = r.x + (r.width / 2);
        midy = r.y + (r.height / 2);
        g.setColor(color);
        g.drawRect(r.x, r.y, r.width, r.height);
        g.drawLine(r.x, midy, (int) r.getMaxX(), midy);
        g.drawLine(midx, r.y, midx, (int) r.getMaxY());
    }

    /**
     * Disegna la griglia sull'immagine
     *
     * @param g Componente grafico
     * @param c Colore della griglia
     */
    private void drawGrid(Graphics g, Color c) {
        int midleftx, midrightx, midtopy, midbottomy;

        g.setColor(c);
        midleftx = image.getWidth() / 3;
        midrightx = midleftx * 2;
        midtopy = image.getHeight() / 3;
        midbottomy = midtopy * 2;

        g.drawLine(0, midtopy, image.getWidth() - 1, midtopy);
        g.drawLine(0, midbottomy, image.getWidth() - 1, midbottomy);
        g.drawLine(midleftx, 0, midleftx, image.getHeight() - 1);
        g.drawLine(midrightx, 0, midrightx, image.getHeight() - 1);
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
