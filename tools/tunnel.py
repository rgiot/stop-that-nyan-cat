#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""Try to generate a tunnel offset map

"""

# imports
import numpy as np
import matplotlib.pyplot as plt

# code

TEX_WIDTH=16
TEX_HEIGHT=16
SCREEN_HEIGHT=38
SCREEN_WIDTH=52


def unsigned(nb):
    if nb < 0:
        return -nb
    else:
        return nb


def store_table(table1, table2):

    if False:
        # Interleave data 
        for y in range(table1.shape[0]):
            for x in range(table1.shape[1]):
                print '\tdb %d, %d' % (table1[y,x], table2[y,x])

    else:
        # do not interleave data
        for y in range(table1.shape[0]):
            for x in range(table1.shape[1]):
                print '\tdb %d' % (table1[y,x])

        for y in range(table1.shape[0]):
            for x in range(table1.shape[1]):
                print '\tdb %d' % (table2[y,x])



def produce_data():
    distance_table = np.empty((SCREEN_HEIGHT, SCREEN_WIDTH))
    angle_table = np.empty_like(distance_table)
    _buffer = np.empty_like(distance_table)
    texture = np.empty((TEX_HEIGHT, TEX_WIDTH))


    for x in range(TEX_WIDTH):
        for y in range(TEX_HEIGHT):
           texture[y,x] = (x * 256 / TEX_WIDTH) ^ (y * 256 / TEX_HEIGHT);
    ratio = 4

    for y in range(SCREEN_HEIGHT):
        for x in range(SCREEN_WIDTH):

             distance = int(ratio * TEX_HEIGHT / (0.00000000001+np.sqrt(\
                (x - SCREEN_WIDTH / 2.0) * (x - SCREEN_WIDTH / 2.0) + \
                (y - SCREEN_HEIGHT / 2.0) * (y - SCREEN_HEIGHT / 2.0)))) % TEX_HEIGHT
             angle = int(unsigned(0.5 * TEX_WIDTH * np.arctan2(y - SCREEN_HEIGHT / 2.0, x - SCREEN_WIDTH / 2.0) / 3.1416))
             distance_table[y][x] = distance;
             angle_table[y][x] = angle;



    #patch table to correct the little bug
    distance_table[0][0] = 2
    # cut tables
    if True:
        distance_table = distance_table[: distance_table.shape[0]/2+1]
        angle_table = angle_table[: angle_table.shape[0]/2+1]
    
    print 'TUNNEL_TABLES'
    store_table(distance_table, angle_table)

    plt.figure()
    plt.imshow(distance_table, interpolation='nearest')
    plt.figure()
    plt.imshow(angle_table,  interpolation='nearest')
    plt.figure()
    plt.imshow(texture, interpolation='nearest')



    plt.show()

    plt.ion()
    animation = 0
    shiftX=0
    shiftY=0
    while False:
    #while True:
        animation = animation+1

 #       shiftX = 0#int(TEX_WIDTH * 1.0 * animation);
 #       shiftY = 0#int(TEX_HEIGHT * 0.25 * animation);        
     
        shiftX = shiftX + 1
        for x in range(SCREEN_WIDTH):
            for y in range(SCREEN_HEIGHT):
 
                #get the texel from the texture by using the tables, shifted with the animation values
                color = texture[unsigned(angle_table[y][x]) % TEX_HEIGHT][unsigned(distance_table[y][x] + shiftX)  % TEX_WIDTH]
                _buffer[y][x] = color;
        
        plt.imshow(_buffer, interpolation="nearest")
        plt.draw()
if __name__ == '__main__':

    produce_data()
    pass



