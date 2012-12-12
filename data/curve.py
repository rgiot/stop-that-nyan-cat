#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""Short summary

Longer summary
"""

# imports
import matplotlib.pyplot as plt
import numpy as np
import math

# code

def output_curve(data):
    for byte in data:
        print '\tdb %d' % min(255, max(0, byte))

def get_curve(amplitude, freq):
    Y = []
    for i in range(256):
        factor = i/256.0*math.pi*2
        Y.append(amplitude/2*math.sin(freq*factor) + amplitude/2)
 
    return np.array(Y)

if __name__ == '__main__':
    amplitude = 30
    freq=2

#    Y = get_curve(40, 1) + \
#            get_curve(25,0.5) + \
#                get_curve(10,3)

    Y = get_curve(amplitude,freq)
   
    plt.plot(Y)

    output_curve(Y)
    plt.show()

# metadata
__author__ = 'Romain Giot'
__copyright__ = 'Copyright 2012, ENSICAEN'
__credits__ = ['Romain Giot']
__licence__ = 'GPL'
__version__ = '0.1'
__maintainer__ = 'Romain Giot'
__email__ = 'romain.giot@ensicaen.fr'
__status__ = 'Prototype'

