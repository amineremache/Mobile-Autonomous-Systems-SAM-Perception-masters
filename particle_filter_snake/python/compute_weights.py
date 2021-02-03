def compute_weights(x, z):
    
    # x = particle, z = measure
    if z[int(x[0]) - 1, int(x[1]) - 1]:
        print("z[int(x[0]) - 1, int(x[1]) - 1] : ",z[int(x[0]) - 1, int(x[1]) - 1])
    if z[int(x[0]) - 1, int(x[1]) - 1] == 1:
        w = 1    

    else:
        w = 0

    return w