import numpy as np
from associate_measurements_to_tracks import associate_measurements_to_tracks

def run_multiple_kfs(kfs, sensor, measurements):
    assert type(kfs) == list
    J = len(kfs) # number of Kalman Filters
    # iterate over all T time steps
    for meas in measurements:
        ## Predict step
        for j in range(J):
            # predict step for the j-th Kalman Filter
            kfs[j].predict_step()
        
        # get measured distances at the current time step
        dists = meas.dists
        
        if any(dists < sensor.max_range):
            # convert the measured distances of the sensor to x,y coordinates
            meas_pos = sensor.dist_to_pos(dists)

            # measurments the equal maximum distance of the sensor
            #   or probably not actual object detections.
            # Only keep the measurements that are below this range
            assert type(dists) == np.ndarray
            mask = (dists < sensor.max_range)
            meas_pos = meas_pos[:,mask]
            assert meas_pos.shape[1] > 0

            ## Update step

            # In this function, we will assume that all given Kalman Filters
            # are 'active'. Later, when we start adding and terminating tracks,
            # some KFs might not be active anymore (i.e. terminated).
            # The associate_measurments_to_tracks function uses this information
            # to know which KFs it can use.
            # For now, we will say that all J Kalman Filters can be used.
            is_active = [True]*J
            
            # determine for all R measurements to which Kalman Filter they
            # belong (if any). Gating is also considerd in the assignment.
            assignment = associate_measurements_to_tracks(meas_pos, kfs, is_active)

            for j in range(J):
                #  update the j-th KF with each of its assigned measurements
                rf = np.arange(assignment.shape[0])[assignment == j]
                if rf.shape[0] < 1:
                    continue
                for r in rf:
                    meas_r = meas_pos[:,r]
                    kfs[j].update_step(meas_r)
    return kfs
