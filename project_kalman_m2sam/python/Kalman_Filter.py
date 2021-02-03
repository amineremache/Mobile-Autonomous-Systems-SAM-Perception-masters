import time
import numpy as np
import matplotlib.pyplot as plt

from kf import Kf
from Sensor import Sensor
from sanity_check_kf_init import sanity_check_kf_init
from funcs import mot_scenario_single_target, mot_scenario_multi_target
from visualizations import plot_measurement_matrix, plot_setup_mot,\
            plot_true_target_position, plot_measurements, plot_kfs,\
            animate_kf_uncertainty_regions
from run_single_kf import run_single_kf
from run_multiple_kfs import run_multiple_kfs
from run_single_kf_gating import run_single_kf_gating
from run_multi_object_tracker import run_multi_object_tracker
from preprocess_measurements import preprocess_measurements

if __name__ == '__main__':
    """
     Exercise 1.1: define the Linear Dynamical System used in the KF
     In the kf_init function the Linear Dynamical System (LDS) is defined
     that will be used in our Kalman Filters. In this assignment, we
     will use a 4D state space, and a 2D observation space.
    
     The 4D state space should correspond to the following dimensions
          [   x   ]  # <-- target's x position
          [   y   ]  # <-- target's y position
      X = [ vel.x ]  # <-- target's x velocity
          [ vel.y ]  # <-- target's y velocity
    
     The dimensions of the 2D observation space are just coordinates in the
     (x,y) plane, i.e.:
          [ x ]  # <-- measured x position
      Z = [ y ]  # <-- measured y position
    
     You will need to complete the code in
         kf.py
    """

    m_init = np.zeros((4,1))    # initial mean
    S_init = np.eye(4)          # initial covariance

    kf = Kf(m_init, S_init)

    # This function runs a few tests to see if you have
    # implemented the H and F matrix correctly.
    # It is not a very rigourous test though, but it should catch
    # the most common mistakes.
    # If you don't get an error or warning, you can move on.
    sanity_check_kf_init(kf)

    ## Exercise 1.2 & 1.3: implement the KF predict step
    #
    # You will need to complete the code in
    #     kf_predict_step

    m_init = np.zeros((4,1)) # initial mean
    S_init = np.eye(4)     # initial covariance
    kf = Kf(m_init, S_init) # t = 0

    # let's run the prediction 5 times
    kf.predict_step() # t = 1;
    kf.predict_step() # t = 2;
    kf.predict_step() # t = 3;
    kf.predict_step() # t = 4;
    kf.predict_step() # t = 5;

    print(f"the Kalman Filter processed {len(kf.ts)} "
            f"time steps (t = {min(kf.ts)} to t = {max(kf.ts)})\n")
    ## animate the result
    dims = [0, 1] # <-- ** Exercise 1.3 **: the dimensions of the state vector to show
    animate_kf_uncertainty_regions(kf, dims)
    #input("Press Enter to continue")

    ## Exercise 1.4: Pedestrian moving in front of a vehicle
    # We now turn to a simulated setup of an vehicle with a range sensor.
    # The vehicle is not moving, but located at the origin, and directed
    # along the positive y axis.
    # In the first scenario, there is a single pedestrian moving in front 
    # of the vehicle.
    #
    # The vehicle is equiped with a sensor that measures distance to objects
    # in front of the vehicle.
    # The vehicle measures the distance at R different angles,
    # resulting in R distance measures at each time step.
    # Of course, the measurements are not exact, but are inherently noise.
    #
    # -- DEFINE scenario setup --
    # define sensor
    R = 50 # number of measurement angles

    # The following call defines the simulated 'sensor'.
    # You don't need to know how it works.
    # But, in case you are wondering what its parameters mean,
    # They are the left extreme and right extreme angle
    # of the Field-Of-View in the (x,y) plane (defined in radians),
    # and the number of measurement rays distributed over this range.
    sensor = Sensor(np.pi/2. + np.pi/4., np.pi/2. - np.pi/4., R)

    # define the setup: one pedestrian
    #  - objects is a struct that contains the pedestrian's position
    #      for each time step
    #  - there are T = 50 timesteps
    #  - scenario_version determines if the pedestrian walks or stands still
    scenario_version = 1 # 1 or 2
    objects, T = mot_scenario_single_target(scenario_version)

    ## -- SIMULATE measurements of SINGLE pedestrian, NO noise --
    ##  A 'random seed' is an integer (here, 42)
    ##  which resets the internal random number generator to a specific
    ##  random sequence.
    ##  This makes sure that the randomness in experiment is repeatable.
    ##  Feel free to try out different values, which should result in slightly
    ##  different measurements and random noise.
    np.random.seed(42)

    ## create simulated measurments for all T time steps
    measurements = []
    for step in range(T):
        # measure the objects
        meas = sensor.new_meas()
        meas = sensor.observe_point(meas=meas, pos=[objects[0].pos[:, step]], 
                                    radius=1., idx=0)
        measurements.append(meas)

    # -- SHOW measurements --
    # Show all the measurements in a single figure.
    # Note that the sensor has a maximum range (sensor.max_range)
    #  of 15 meters
    plot_measurement_matrix(measurements)
    #input("Press Enter to continue")
    
    ### Exercise 1.5: Visualize the scenario
    ## Let's animate the scenario from a top-down viewpoint.
    ## this will draw the vehicle and sensor in figure 1 once
    plot_setup_mot(sensor)
    
    ## Iterate over the time steps.
    ## NOTE: sometimes it is useful to look at the result for one particular
    ##   or a few particular time steps. In that case, just change the
    ##   list of time steps in the 'for step=1:T' loop below!
    ##   For instance, to draw the 10-th step, just use
    ##      for step = 10
    ##   since the for loop does not care that you give it a single step number.
    ##   And when you want to animate steps 10 to 15 only, use
    ##      for step = 10:15
    ##
    plt.pause(1.)
    for step in range(0, T): # <-- you can change this to a particular time step
        
        # draw the true object positions as a '*' mark
        lines_target = plot_true_target_position(step, objects)
        # draw the measured distances as 'x' marks
        #   (skip measurements that are
        line_meas = plot_measurements(step, sensor, measurements)
        
        # The `pause` command can be used to control the speed of the
        # animation. Ot also ensures that the figure gets drawn, 
        # even though we are in a loop.
        # Without out it, matlab might delay showing the
        # plot until the for-loop has completely finished, which means
        # that we would only see the plot of the last timestep t = T.    
        plt.pause(0.05)
        if True:
            [x.remove() for x in lines_target]
            line_meas.remove()
    
    #plt.show()
    #input("Press Enter to continue")
    ## Exercise 1.6: KF initialization and prediction on pedestrian scenario
    # Now we can run your KF initialization and prediction functions
    # on the new scenario.
    
    # define initial state
    #   NOTE: for now, we assume that the target's true initial position is known!
    pos_init1 = list(objects[0].pos[:,0])
    m_init1 = np.array([pos_init1, [0, 0]]).reshape(4,1)
    S_init1 = np.diag([1, 1, .1, .1])
    
    # create the tracker
    kf = Kf(m_init1, S_init1)
    
    plot_setup_mot(sensor)
    plt.pause(1.)
    for step in range(T):
        
        # call the KF *predict* step
        #   (no *update* step yet, we will get to it in a moment)
        kf.predict_step()
    
        # show the result
        lines_kfs = plot_kfs(step, [kf])
        lines_target = plot_true_target_position(step, objects)
        
        plt.pause(.005)
        if True:
            [x.remove() for x in lines_target]
            if lines_kfs is not None:
                [x.remove() for x in lines_kfs]

    #input("Press Enter to continue")
    ## Exercise 1.7 & Exercise 1.8: updating the Kalman Filter
    # We now use the measurements to UPDATE the Kalman Filter state.
    # instead of running the kf_predict_step and kf_update_step
    #   directly, we will let the run_single_kf function do this for us.
    #
    # You will need to complete the code in
    #     kf_update_step
    
    # create the tracker
    kf = Kf(m_init1, S_init1)
    
    # here we scale up/down the process and observation noise
    #kf.Sigma_x = kf.Sigma_x * 1e0; % <-- ** Exercise 1.8 **
    #kf.Sigma_z = kf.Sigma_z * 1e0; % <-- ** Exercise 1.8 **
    
    # feed the measurments, filter the results
    kf = run_single_kf(kf, sensor, measurements)
    
    # visualize the result
    plot_setup_mot(sensor)
    ax = plt.gca()
    ax.set_title('KF')
    
    for step in range(T):
        lines_true = plot_true_target_position(step, objects)
        lines_meas = [plot_measurements(step, sensor, measurements)]
        lines_kfs = plot_kfs(step, [kf])
       
        # control animation speed and force that the figure gets drawn
        plt.pause(.005)
        for lines in [lines_true, lines_meas, lines_kfs]:
            if lines is not None: [x.remove() for x in lines]

    #input("Press Enter to continue")
    ## Exercise 1.9: outlier noise
    # now we also siumulate that the sensor can have outlier measurements
    # (i.e. false detections) that have nothing to do with the moving target.
    
    np.random.seed(42)  # random seed
    
    # generate new measurements with outliers
    measurements_outliers = []
    for step in range(T):
        # measure the objects
        meas = sensor.new_meas()
        meas = sensor.observe_false_positives(meas, .02)  # <-- outlier ratio
        meas = sensor.observe_point(meas, [objects[0].pos[:,step]], 
                                    radius=1., idx=0)
        measurements_outliers.append(meas)
    # show measurements
    plot_measurement_matrix(measurements_outliers)
    #input("Press Enter to continue")
    
    # run a Kalman Filter on measurements with NOISY OUTLIERS
    kf = Kf(m_init1, S_init1)
    kf = run_single_kf(kf, sensor, measurements_outliers)
    
    # visualize the result
    plot_setup_mot(sensor)
    ax = plt.gca()
    ax.set_title('KF on outliers')
    
    # animate
    for step in range(T):
        lines_true = plot_true_target_position(step, objects)
        lines_meas = [plot_measurements(step, sensor, measurements_outliers)]
        lines_kfs = plot_kfs(step, [kf])
        
        plt.pause(.005)
        for lines in [lines_true, lines_meas, lines_kfs]:
            if lines is not None: [x.remove() for x in lines]
    #input("Press Enter to continue")
    ## Exercise 1.10: pre-process measurements
    # One approach to deal with outliers is to perform a pre-processing step
    # to try to remove them as much as possible before feeding them to the
    # Kalman Filter. So we will try to 'filter out' the outliers spatially:
    # we compare each measured distance to the measurement of the adjacent
    # rays, and assign the MEDIAN value as the filtered output.
    # Note that in this context, 'filtering' refers to -spatial- filtering
    # since each adjacent ray corresponds to different spatial locations.
    # This is different from the KF, which performs -temporal- 'filtering'.
    #
    # You will need to complete the code in
    #     preprocess_measurements
    
    # use a pre-processing step to remove some noise from the measurments
    measurements_pp = preprocess_measurements(measurements_outliers)
    
    # show pre-processed measurements
    plot_measurement_matrix(measurements_pp)
    plt.pause(.005)
    #input("Press Enter to continue")
    
    # run a Kalman Filter on pre-processed measurements
    kf = Kf(m_init1, S_init1)
    kf = run_single_kf(kf, sensor, measurements_pp)
    
    # visualize the result
    plot_setup_mot(sensor)
    ax = plt.gca()
    ax.set_title('KF with pre-processing on outliers')
    # animate
    for step in range(T):
        lines_true = plot_true_target_position(step, objects)
        lines_meas = [plot_measurements(step, sensor, measurements_pp)]
        lines_kfs = plot_kfs(step, [kf])
        
        plt.pause(.005)
        for lines in [lines_true, lines_meas, lines_kfs]:
            if lines is not None: [x.remove() for x in lines]
    #input("Press Enter to continue")
    ## Exercise 1.11: Now with gating
    # Another important approach (that can be combined with pre-processing) is to
    # compare measurements to the predicted KF position. The measurement will
    # only be used for the update step if it is 'close enough' (below some
    # threshold). For this approach, we switch from the run_single_kf() function
    # to the run_single_kf_gating() function, which uses test_gating_score().
    #
    # You will need to complete the code in
    #     test_gating_score
    
    # run a Kalman Filter on all timesteps 
    kf = Kf(m_init1, S_init1)
    kf = run_single_kf_gating(kf, sensor, measurements_outliers)
    
    # visualize the result
    plot_setup_mot(sensor)
    ax = plt.gca()
    ax.set_title('KF with gating on outliers')
    
    # animate
    for step in range(T):
        lines_true = plot_true_target_position(step, objects)
        lines_meas = [plot_measurements(step, sensor, measurements_outliers)]
        lines_kfs = plot_kfs(step, [kf])
        plt.pause(.005)
        for lines in [lines_true, lines_meas, lines_kfs]:
            if lines is not None: [x.remove() for x in lines]
    #input("Press Enter to continue")
    ## Exercise 1.12: Scenarios with multiple targets
    # We now move to the scenario where there is more than
    # one target, which means that we have to decide to which
    # target an observation is associated (if any).
    #
    # For now, we will still assume that we know how many targets
    # there are (namely, two), and where they start.
    
    # define the setup: two pedestrians moving
    #   now objects(i) contains the positions of pedestrian i
    scenario_version = 1  # 1 = crossing, 2 = stopping
    objects_multi, T = mot_scenario_multi_target(scenario_version)
    
    np.random.seed(42)  # change this to try various play-outs of the scenario
    
    measurements_multi = []
    for step in range(T):
        # measure the objects
        meas = sensor.new_meas()
        meas = sensor.observe_false_positives(meas, .02)
        meas = sensor.observe_point(meas, [objects_multi[0].pos[:,step]], 
                                    radius=1., idx=0)
        meas = sensor.observe_point(meas, [objects_multi[1].pos[:,step]], 
                                    radius=1., idx=1)
        
        measurements_multi.append(meas)
    # show measurements
    plot_measurement_matrix(measurements_multi)
    #input("Press Enter to continue")
    
    ## Exercise 1.13: Multiple-targets: data association
    # The new function run_multiple_kfs() runs the KF predict and update
    # step on multiple Kalman Filters, which are given as a multi-dimensional
    # struct (e.g. kfs(1) is the first KF struct, and kfs(2) the second one).
    # Before the update step, data association must be performed to determine
    # which measurements update which KFs.
    #
    # Data association is one step beyond the gating approach implemented
    # before. We now need to compare a measurement to ALL KFs, and assign it
    # to the best one (if it passes the gating threshold).
    #
    # You will need to complete the code in
    #     associate_measurments_to_tracks
    
    # define intial position for a second Kalman Filter
    pos_init2 = objects_multi[1].pos[:,0]
    assert len(pos_init2.shape) == 1
    pos_init2 = list(pos_init2)
    m_init2 = np.array(pos_init2 + [0., 0.]).reshape(4, 1)
    S_init2 = np.diag([1., 1., .1, .1])
    
    # initialize two KFs for both persons
    kf = Kf(m_init1, S_init1)
    kf2 = Kf(m_init2, S_init2)
    
    # append both KFs into a single struct `kfs` with 2 dimesions
    #   such that kfs[0] = kf and kfs[1] = kf2
    kfs = [kf, kf2]
    
    # run both KFs simultaneously, using data association.
    kfs = run_multiple_kfs(kfs, sensor, measurements_multi)
    
    # You can also try out your previous Kalman Filter implementations
    #   that assumed a single target on these measurements.
    #kfs[0] = run_single_kf(kfs[0], sensor, measurements_multi)
    #kfs[0] = run_single_kf_gating(kfs[0], sensor, measurements_multi)
    
    # visualize the result
    plot_setup_mot(sensor)
    ax = plt.gca()
    ax.set_title('KF on multiple targets')
    
    for step in range(T):
        lines_true = plot_true_target_position(step, objects_multi)
        lines_meas = [plot_measurements(step, sensor, measurements_multi)]
        lines_kfs = plot_kfs(step, kfs)    
        plt.pause(.005)
        for lines in [lines_true, lines_meas, lines_kfs]:
            if lines is not None: [x.remove() for x in lines]
    #input("Press Enter to continue")
    ## Exercise 1.13: Complete Multi-object tracking
    # Till this point we have made several assumptions, such as
    #  - how many targets there are
    #  - where they are initially
    # Now we remove these assumptions, which means that we have to dynamically
    # add and remove Kalman Filters do determine the number of tracks on the
    # fly.
    
    # deactivate a KF tracker if it has had NO observations 
    #  in so many time steps:
    track_termination_threshold = 8
        
    # run multi-object tracker, on return set of KFs for all tracks
    kfs = run_multi_object_tracker(
        sensor,
        measurements_multi,
        track_termination_threshold
    )
    print(f"created {len(kfs)} tracks ... \n")
    
    # visualize the result
    plot_setup_mot(sensor)
    ax = plt.gca()
    ax.set_title('Multi-Object Tracking')
    
    # animate
    for step in range(T):
        lines_true = plot_true_target_position(step, objects_multi)
        lines_meas = [plot_measurements(step, sensor, measurements_multi)]
        lines_kfs = plot_kfs(step, kfs)
        plt.pause(.005)
        for lines in [lines_true, lines_meas, lines_kfs]:
            if lines is not None: [x.remove() for x in lines]
    #input("Press Enter to continue")
