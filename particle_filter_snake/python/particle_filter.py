import numpy as np
from motion_model import motion_model
from compute_weights import compute_weights

def particle_filter(x_t, z, M):
    w_t = np.ones(M)
    p = []
    
    for i in range(M):
        x_t[i] = motion_model(x_t[i])
        w_t[i] = compute_weights(x_t[i], z)
        p.append(w_t[i] * x_t[i])
    idx = np.flatnonzero(w_t) # Indices of particles with w = 1
    # print(w_t)
    # print(idx)
    
    # Resampling
    for i in range(M):
        if not idx.size == 0:
            if (w_t[i] == 0) and (idx[0] > 0): # Problem here: idx remains empty (no weight = 1)
                rand = np.random.randint(len(idx))
                p[i] = motion_model(p[idx[rand]])
                
            elif w_t[i] == 1:
                p[i] = p[i]
                
            else:
                p[i] = np.random.randint(1, 201, size=(2,))
        else:
            continue
    return p