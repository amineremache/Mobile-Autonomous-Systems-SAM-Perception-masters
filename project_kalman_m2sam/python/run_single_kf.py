import numpy as np

def run_single_kf(kf, sensor, measurements):
    # iterate over all T time steps
    for meas in measurements:
        ## Predict step
        kf.predict_step()

        # get measured distances at the current time step
        dists = meas.dists
        
        if any(dists < sensor.max_range):
            # convert the measured distances of the sensor to x,y coordinates
            meas_pos = sensor.dist_to_pos(dists)

            # measurments the equal maximum distance of the sensor
            # or probably not actual object detections.
            # Only keep the measurements that are below this range
            assert type(dists) == np.ndarray
            mask = (dists < sensor.max_range)
            meas_pos = meas_pos[:,mask]
            assert meas_pos.shape[1] > 0
            
            ## Update step
            #  we will only update with the working measurments
            for r in range(meas_pos.shape[1]):
                # the measurment along the r-th ray
                meas_r = meas_pos[:,r]
                # apply the Kalman Filter update equations
                kf.update_step(meas_r)
    return kf
