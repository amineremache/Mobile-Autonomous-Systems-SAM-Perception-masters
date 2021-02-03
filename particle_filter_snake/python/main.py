from measurement import measurement
from particle_filter import particle_filter
import numpy as np
import matplotlib.pyplot as plt
import imageio
import cv2

M = 50 # Num. of particles
num_img = 1019
p = []

for i in range(M):
    p.append(np.random.randint(1, 201, size=(2,))) # Initialize particles

for i in range(num_img):
    img = imageio.imread("../images/snake_color/snake_" + str(i).zfill(4) + ".png")
    img[:,:,[0,2]] = img[:,:,[2,0]]
    p = particle_filter(p, measurement(img), M)