from scipy.signal import medfilt

def preprocess_measurements(measurements):
    assert type(measurements) == list
    filter_order = 1  # <-- ** Exercise 1.10 ** order of the median filter

    T = len(measurements)
    # iterate over all time steps
    for t in range(T):
        dists = measurements[t].dists;
        # remove noise from the M-dimensional dists vector
        dists = medfilt(dists, filter_order)

        measurements[t].dists = dists;
    return measurements
