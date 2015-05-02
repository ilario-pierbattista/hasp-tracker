function saveImage(fileName, image)
fd = fopen(fileName, 'w');
fwrite(fd, transpose(image), 'uint16');
fclose(fd);
