#include <iostream>
#include "modules/Image.h"

using namespace std;

int main() {
    char * filename = new char(200);
    int height, width;
    Image* image;
    cout << "Path dell'immagine: ";
    cin >> filename;
    cout << "Larghezza e altezza (separati da uno spazio): ";
    cin >> width >> height;
    image = new Image(filename, width, height);


    return 0;
}