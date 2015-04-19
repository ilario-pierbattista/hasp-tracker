#!/usr/bin/env python3

import os
import sys
import urllib.request
import urllib.error
import threading
import time
from bs4 import BeautifulSoup as BS


class Element:
    """
    Classe che modella un elemento da scaricare
    """
    def __init__(self, url):
        self.url = url
        url_parts = url.split('/')
        self.name = url_parts[-1]
        name_parts = self.name.split('-')
        self.dataset = name_parts[0]
        self.index = name_parts[1]
        

    def print_info(self):
        """
        Stampa le informazioni dell'elemento
        """
        print("""url: %s\nname: %s\ndataset: %s\nindex: %s""" %
                (self.url, self.name, self.dataset, self.index))

    def get_info(self):
        """
        Scarica le info dei file
        """
        try:
            resp = urllib.request.urlopen(self.url)
            self.size = int(resp.headers['content-length'])
        except urllib.error.HTTPError:
            self.size = -1;

    def download(self, path):
        """Scarica o mantieni il file"""
        target_path = self._generate_path(path)
        target_file = os.path.join(target_path, self.name)
        downf = not os.path.exists(target_file)
        if not downf: 
            """ A questo livello, il file esiste"""
            self.path = target_file
            self.directory = target_path
        downf = downf or (self.size != os.path.getsize(target_file))
        if downf:
            try:
                request = urllib.request.urlopen(self.url)
                f = open(target_file, 'wb')
                while True:
                    data = request.read(100*1024)
                    if data:
                        print("""downloading %s (%d/%d)\r""" % 
                                (self.name, os.path.getsize(target_file), self.size))
                        f.write(data)
                    else:
                        break
                print("""%s completed""" % (self.name))
                f.close()
                self.path = target_file
                self.directory = target_path
            except urllib.error.HTTPError:
                path = None

    def extract(self):
        """
        Estrae gli archivi
        """
        if hasattr(self, 'path') and self.path is not None:
            exts = self.path.split('.')[-1]
            if exts == 'zip':
                os.system("unzip -q "+
                        self.path + 
                        " -d " + self.directory)
                print("""%s extracted""" % (self.name))


    def _generate_path(self, path):
        """
        Genera la path
        """
        dataset_level = os.path.join(path, self.dataset)
        index_level = os.path.join(dataset_level, self.index)
        if not os.path.exists(dataset_level):
            os.mkdir(dataset_level)
        if not os.path.exists(index_level):
            os.mkdir(index_level)
        return index_level
        

class HtmlPage:
    """
    Classe che modella una pagina web
    """
    def __init__(self, url):
        """
        Costruttore
        """
        response = urllib.request.urlopen(url)
        data = response.read();
        data = data.decode('utf-8')
        self.soup = BS(data)

    def pretty_print(self):
        """
        Stampa l'html ben formattato
        """
        print(self.soup.prettify())

    def parse_tables(self):
        """
        Parsa il contenuto delle tabelle (copia
        tutti i link contenuti)
        """
        self.elements = []
        for td in self.soup.find_all('td'):
            for anchor in td.find_all('a'):
                self.elements.append(Element(anchor.get('href')))


"""
Inizializzazione oggetto per il multithreading
"""
done = threading.Lock()

def usage():
    """
    Stampa le istruzioni d'uso
    """
    print("""Usage: %s <url> <dest_dir> <number_of_thread>""" % (sys.argv[0]))

def child_info(subset):
    """
    Figli per scaricare le informazioni
    """
    subset = subset[0]
    global done
    
    for elem in subset:
        elem.get_info()
    """ Bisogna considerare anche il padre come un thread"""
    if threading.active_count() <= 2:
        done.release()
        done = threading.Lock()
    sys.exit(0)

def child_download(subset):
    """
    Figli per scaricare i file
    """
    subset = subset[0]

    for elem in subset:
        elem.download(sys.argv[2])
    if threading.active_count() <= 2:
        done.release()
    sys.exit(0)

def balance_load(childnum, main_runner, dataset):
    """
    Bilancia il carico di lavoro dividendo l'input
    """
    global done
    i = 0
    partitions = [None]*childnum
    for k,v in enumerate(partitions):
        partitions[k] = []
    while i < len(dataset):
        j = 0
        while j < childnum:
            if i >= len(dataset):
                break
            partitions[j].append(dataset[i])
            i += 1
            j += 1

    possibles = globals().copy()
    possibles.update(locals())
    function = possibles.get(main_runner)
    if not function:
        raise Exception("Funzione %s non implementata" % main_runner)

    done.acquire()
    for partition in partitions:
        threading.Thread(target=function, 
                args=([partition],)
                ).start()
    done.acquire()

def main():
    """
    Main del programma
    """
    if(len(sys.argv) != 4):
        usage()
        sys.exit(1)
    page = HtmlPage(sys.argv[1])
    thread_num = int(sys.argv[3])
    print('Sto scaricando le informazioni...')
    page.parse_tables()
    balance_load(thread_num, "child_info", page.elements)
    
    total_size = 0
    for elem in page.elements:
        if elem.size != -1:
            total_size += elem.size
    print("Dimensione minima dei dataset %s B" % (total_size))
    balance_load(thread_num, "child_download", page.elements)
    print("Estrazione")
    for elem in page.elements:
        elem.extract()
    print("File aggiornati")


main()
