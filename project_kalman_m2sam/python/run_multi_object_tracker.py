import numpy as np
from kf import Kf
from associate_measurements_to_tracks import associate_measurements_to_tracks
# Tracking multiple objects, creating and terminating tracks if needed.
#
# The Multi-Object Tracker performs as follows:
# Initially, there are no tracks.
# Then each time step, the tracker
#   1. GET MEASUREMENTS: retrieve the measurements of the new time step
#   2. PREDICT TRACKS: perform the KF predict step for all tracks
#   3. DATA ASSOCIATION: assign measurements to tracks (also do gating)
#   4. UPDATE TRACKS: use the assigned measurement for the KF update step
#   5. CREATE TRACKS: init new track by placing KF on unassigned measurements.
#        5 1/2. if needed, perform new DATA ASSOCIATION with added track
#   6. TERMINATE TRACKS: if a track has no measurement associated for
#         several time step, terminate it
#
def run_multi_object_tracker(sensor, measurements, track_termination_threshold):

    assert type(measurements) == list
    T = len(measurements)  # number of timesteps

    ## setup datastructures
    kfs = []  # will contain list of Kalman Filters for all tracked objects
    is_active = []  # indicates which KFs are active (terminated tracks are 'inactive')
    dt_without_update = []  # how many time steps without any associated measurement? Used to terminate tracks.

    # loop over all time instances
    for t in range(T):
        ## -- GET MEASUREMENTS --
        # get measures for this time step, convert the valid ones to (x,y) coordinates
        dists = measurements[t].dists
        meas_pos = sensor.dist_to_pos(dists)  # get x,y coordinates of measurements
        # measurments the equal maximum distance of the sensor
        # or probably not actual object detections.
        # Only keep the measurements that are below this range
        assert type(dists) == np.ndarray
        mask = (dists < sensor.max_range)
        meas_pos = meas_pos[:,mask]
        dists = dists[mask]
        #assert meas_pos.shape[1] > 0

        ## -- PREDICT TRACKS --
        # predict all active trackers

        # indices of active KFs
        J = len(kfs)
        assert len(kfs) == len(is_active)
        active_js = np.arange(J)[np.array(is_active)] if J > 0 else []
        for j in active_js:
            kfs[j].predict_step()
            dt_without_update[j] = dt_without_update[j] + 1

        ## -- DATA ASSOCIATION --    
        # determine which measurement belongs to which track
        assignment = associate_measurements_to_tracks(meas_pos, kfs, is_active)

        ## -- UPDATE TRACKS --
        # update tracks with assigned observations
        for j in active_js:
            rf = np.arange(assignment.shape[0])[assignment == j]
            for r in rf:
                #for r = find(assignment == j) # loop over all assigned measurements

                # Kalman Filter UPDATE step
                kfs[j].update_step(meas_pos[:,r])

                # reset its 'timesteps without measurements' counter
                dt_without_update[j] = 0

        ## -- CREATE TRACKS --
        # initialize new tracks for unassigned observations

        # determine indices of unassigned but valid measurements
        assert type(assignment) == np.ndarray
        assert type(dists) == np.ndarray
        assert assignment.shape == dists.shape
        unassigned_rs = np.arange(dists.shape[0], dtype=np.int64)
        unassigned_rs = unassigned_rs[(assignment == -9999) & (dists <
                                        sensor.max_range)]
        while unassigned_rs.shape[0] > 0:

            # get one of the unassigned measurements
            #r = unassigned_rs(1)
            r = unassigned_rs[0]
            assert type(r) == np.int64
            meas_r = meas_pos[:,r].reshape(2,1)

            # intialize a tracker on top of this measurement
            m_init = np.zeros((4,1))
            assert meas_r.shape == (2,1)
            m_init[:2] = meas_r
            S_init = np.diag([1e0, 1e0, 1e-1, 1e-1])

            new_kf = Kf(m_init, S_init)
            #new_kf.ts(end) = t;
            new_kf.ts[-1] = t

            # add the Kalman Filter to the list of trackers
            assert type(kfs) == list
            kfs = kfs + [new_kf]
            is_active = is_active + [True]
            assert len(kfs) == len(is_active)
            dt_without_update = dt_without_update + [0]

            # re-check assignment of all unassigned measurements
            assignment = associate_measurements_to_tracks(meas_pos, kfs, is_active)
            #unassigned_rs = find(isnan(assignment) & ~isnan(dists));
            assert type(assignment) == np.ndarray
            assert type(dists) == np.ndarray
            assert assignment.shape == dists.shape
            unassigned_rs = np.arange(dists.shape[0])
            unassigned_rs = unassigned_rs[(assignment == -9999) & (dists <
                                            sensor.max_range)]
            #if ismember(r, unassigned_rs);
            if r in unassigned_rs:
                # print("hmmm, the r-th measurement is still unassigned,"
                # " which is not a good sign. Maybe the gating threshold"
                # " is too strict?")
                break

        ## -- TERMINATE TRACKS --
        # invalidate tracks that have not been updated for too long
        assert len(is_active) == len(dt_without_update)
        is_active = [False if x >= track_termination_threshold else y for x,y in
                        zip(dt_without_update, is_active)]
        #is_active(dt_without_update >= track_termination_threshold) = false;

    return kfs

