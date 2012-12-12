#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""Compute the bump mapping table.

Longer summary
"""

import matplotlib.pyplot as plt
import sys
import numpy as np

# imports

# code

def get_bump_table(fname):
    img = plt.imread(fname)
    assert len(img.shape) == 2, 'Gray color is expected'

    height, width = img.shape
    import scipy.misc
    img = scipy.misc.imresize(img,0.5)
#    img = img[::2,::2]


    img = img*-1.0*-1.0 # signed version
    img = img[::-1]


    diffx = (img[:,:-2] - img[:,2:])*2
    diffy = (img[:-2,:] - img[2:,:])*2

    plt.gray()

    plt.subplot(2,2,1)
    plt.imshow(img, interpolation='nearest') ; plt.title('Original bitmap')

    return diffx, diffy


def produce_asm(diffx, diffy):

    diffx = analyse_lines(diffx)
    diffx = analyse_columns(diffx)

    diffy = analyse_lines(diffy)
    diffy = analyse_columns(diffy)


    plt.subplot(2,2,2)
    plt.imshow(diffx, interpolation='nearest') ; plt.title('Horizontal slopes')
    plt.subplot(2,2,3)
    plt.imshow(diffy, interpolation='nearest') ; plt.title('Vertical slopes')



    diffx = diffx.ravel()
    diffy = diffy.ravel()

    #diffx = diffx[::2]
    #diffy = diffy[::2]

    maxx = np.max(diffx)
    minx = np.min(diffx)
    maxy = np.max(diffy)
    miny = np.min(diffy)


    print '; Maxx ', maxx, ' - Minx', minx, "\n" ;
    print '; Maxy ', maxy, ' - Miny', miny, "\n" ;
    print '; octet x,y,x,y,...'
    print ';', len(diffx),' octets', "\n" ; 

    if False:
        for x,y in zip(diffx, diffy):
            print '\tdb %d,%d' % (x,y)

    else:
        print_array(diffx)
        print_array(diffy)

def analyse_lines(diff, thr=100):
    prev = diff[0]

    for i in range(1,diff.shape[0]):
        score = np.sum((prev - diff[i])**2)
        if score < thr:
            diff[i] = prev
        prev =  diff[i]


    return diff

def analyse_columns(diff, thr=100):
    prev = diff[:,0]

    for i in range(1,diff.shape[1]):
        score = np.sum((prev - diff[:,i])**2)
        if score < thr:
            diff[:,i] = prev
        prev =  diff[:,i]
    
    return diff

def print_array(diff):
    prev =  diff[0]
    print '\t db %d' % prev

    for x in diff[1:]:
 #       print '\tdb %d' % (x-prev)
        print '\tdb %d' % max(min(x,128),-127)
        prev = x




if __name__ == '__main__':
    fname = sys.argv[1]

    diffx, diffy = get_bump_table(fname)
    produce_asm(diffx, diffy)

    plt.show()
    pass




