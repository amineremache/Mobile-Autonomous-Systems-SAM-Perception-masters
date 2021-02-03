import numpy as np
from test_gating_score import test_gating_score

# Data association: assign measurments to tracks
def associate_measurements_to_tracks(meas_pos, kfs, is_active):

    assert type(kfs) == list
    is_active = np.array(is_active)
    J = len(kfs) # number of filters
    R = meas_pos.shape[1]  # number of measurement rays
    
    # assignment(r) = j means that measurement r is assigned to KF j
    assignment = np.zeros(R, dtype=np.int64) - 9999

    # check if there are any measurements
    if R < 1:
        return assignment

    # this array can be used to keep track of the best gating score
    # per measurement r, found over all active Kalman Filters.
    best_scores = np.ones(R) * 1e12
    
    if J == 0:
        # no filters present
        #return np.array([-1])
        return assignment
    
    # indices of active KFs
    assert J == len(is_active)
    active_js = np.arange(J)[is_active]
    
    if active_js.shape[0] < 1:
        return assignment
    # evaluate log likelihood of all observations per tracker
    for r in range(meas_pos.shape[1]):  # iterate over valid measurements ...
        for j in active_js: # iterate over active KFs ...
            # get 2D location of r-th measurement
            meas_r = meas_pos[:,r]
            
            # Here we call test_gating_score to perform the gating test.
            # We also obtain the gating score.
            #
            # If the test succeeds, do the following, in pseudo-code
            #
            #     if score is better than best_score(r):
            #          best_score(r) = score
            #          assignment(r) = j
            
#########################
## YOUR_CODE_GOES_HERE ##
#########################
    return assignment
