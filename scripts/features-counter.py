#!/usr/bin/env python3


def generate_dimensions(height, width, e, l, c):
    """
    Genera tutte le dimsnioni possibili per le feature
    edge -> min 1x2, divisibile per 2
    linear -> min 1x3, divisibile per 3
    cross -> min 2x2, quadrata
    """
    edge = []
    if e:
        for i in range(2, width+1, 2):
            for j in range(1, height+1):
                edge.append([i, j])
        revers = []
        for f in edge:
            if f[0] != f[1]:
                revers.append([f[1], f[0]])
        edge += revers

    linear = []
    if l:
        for i in range(3, width+1, 3):
            for j in range(1, height+1):
                linear.append([i, j])
        revers = []
        for f in linear:
            if f[0] != f[1]:
                revers.append([f[1], f[0]])
        linear += revers

    cross = []
    if c:
        for i in range(2, width+1, 2):
            for j in range(2, height+1, 2):
                cross.append([i, j])
        revers = []
        for f in cross:
            if f[0] != f[1]:
                revers.append([f[1], f[0]])
        cross += revers
    return edge + linear + cross


def calc_number(height, width, e, l, c):
    """
    Calcola il numero totale di feature in una
    finestra
    """
    somma = 0
    dims = generate_dimensions(height, width, e, l, c)
    for d in list(dims):
        configurations = (width - d[0] + 1) * (height - d[1] + 1)
        print("""feature %d x %d -> %d""" % (d[0], d[1], configurations))
        somma = somma + configurations
    return somma


def parse_ans(stringa):
    if stringa == "n":
        return False
    return True


def main():
    width = int(input("Largezza: "))
    height = int(input("Altezza: "))
    edge = input("Edge feature [Y/n] ")
    linear = input("linear feature [Y/n] ")
    cross = input("Cross feature [Y/n] ")
    edge = parse_ans(edge)
    linear = parse_ans(linear)
    cross = parse_ans(cross)
    num = calc_number(height, width, edge, linear, cross)
    print("Totale: " + str(num))

main()
