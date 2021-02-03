import numpy as np

def test_gating_score(kf, meas_r):
    meas_r = np.expand_dims(meas_r, axis=-1)
    # get the expected measurement position from the Kalman Filter
    pred_z_mu, _ = kf.predict_obs()
    
    # the given observation and the 'expected observation' pred_z_mu
    #   should have the same dimensions. Just checking if everything is ok.
    assert meas_r.shape == pred_z_mu.shape
    
    # For the gating procedure we can use the Euclidean distance.
    #   Let the `score` variable be the distance
    # You also need to define the `gating_threshold` to which the score
    # is compared. 
    # Assuming that all position (and hence Euclidean distances) are given
    # in meters, try out a gating threshold between 1 and 10 meter,
    # and pick one you think works well.
    #
    # Euclidean distance score:
    #                 ________________________________________
    #           _    /  ---
    #   score =  \  /   \     ( meas_r(d) - pred_z_mu(d) )^2
    #             \/    /__ d 
    #
    # The measurement can be accepted iff (score < gating_threshold)
    
    # *NOTE*
    # the gating threshold is some fixed number for YOU (student) to determine
    gating_threshold = 3 #None
    
    # this will be the score of the measurement for this KF    
    #   (the score will also be used for data association later on)
    score = np.sqrt(np.power(np.sum(meas_r-pred_z_mu),2))
    
#########################
## YOUR_CODE_GOES_HERE ##
#########################

    # compare score to threshold
    is_ok = (score < gating_threshold)
    return is_ok, score
