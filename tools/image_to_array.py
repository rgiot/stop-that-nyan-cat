#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""Short summary

Longer summary
"""

# imports
import matplotlib.pyplot as plt
import sys
import numpy as np


# code
if __name__ == '__main__':
    fname = sys.argv[1]
    img = plt.imread(fname)
    img = img[::-1]
#    img = img[:,::2]
    assert len(img.shape) == 2, 'Gray color is expected'


    print '; %d,%d' % img.shape
    for i in img.ravel():
        print '\tdb %d' %i

    pass


# metadata
__author__ = 'Romain Giot'
__copyright__ = 'Copyright 2011, ENSICAEN'
__credits__ = ['Romain Giot']
__licence__ = 'GPL'
__version__ = '0.1'
__maintainer__ = 'Romain Giot'
__email__ = 'romain.giot@ensicaen.fr'
__status__ = 'Prototype'

