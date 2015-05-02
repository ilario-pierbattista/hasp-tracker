function subimg = cutImage(image, x0, y0, width, height)
% Funzione per ritagliare una porzione d'immagine
subimg = image(y0:y0+height-1, x0:x0+width-1);
