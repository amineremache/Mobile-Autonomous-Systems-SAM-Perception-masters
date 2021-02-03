import numpy as np

def measurement(image):
    (num_px, _, _) = image.shape 
    z = image[:, :, 2] == 255 * np.ones((num_px, num_px))
    return z