import numpy as np

def motion_model(x):
    i = np.random.randint(1, 5)
    
    # Random movement of the input particle in any of the 4 possible directions
    if i == 1:
        x[0] += 1

    elif i == 2:
        x[1] += 1
        
    elif i == 3:
        x[0] -= 1
        
    else:
        x[1] -= 1
        
    x[(x == 0) | (x > 200)] = 1 # Keep particles in the image
    return x