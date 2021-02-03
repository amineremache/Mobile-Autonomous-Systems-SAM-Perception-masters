import warnings
import numpy as np
import matplotlib.pyplot as plt
import time

def plot_measurement_matrix(measurements):
    """
    Visualize all the measurments over time in a single figure
    This function first concatenate the measurements of all time 
    steps in a single T x M matrix, such that row t in this matrix
    contains the measurements of time t
    """
    assert type(measurements) == list
    D = np.array([x.dists for x in measurements])
    assert len(D.shape) == 2

    plt.figure()
    plt.imshow(D.T, origin='lower')  #, extent=[0, 1, 0, 1])
    plt.xlabel('time -->')
    plt.ylabel('sensor ray')
    plt.title('measured distance by sensor rays over time')   
    plt.colorbar()
    plt.show()

def plot_setup_mot(sensor):
    # setup the figure, draw the vehicle and the sensors
    fig = plt.figure()
    ax = fig.gca()
    ax.axis('equal')
    ax.set_xlim([-15, 15])
    ax.set_ylim([-5, 20])
    #hold all;
    #grid on
    ax.set_xlabel('lateral - x (meters)')
    ax.set_ylabel('longitudinal - y (meters)')
    ax.grid(True, alpha=0.5)
    #plt.pause(5)

    # plot sensor rays
    #delete(findobj('Tag', 'sensor'))
    plot_sensor_rays(ax, sensor)

    # define vehicle state, located at origin
    veh = {'x': 0, 'y': 0, 'theta': 0, 'kappa': 0, 'v': 0, 'a': 0};
    #delete(findobj('Tag', 'vehicle'))
    plot_vehicle_state(ax, veh)

def plot_vehicle_state(ax, s):
    # rotation, translation
    ct = np.cos(s['theta'])
    st = np.sin(s['theta'])
    R = np.array([[ct, st], [-st, ct]])
    T = np.array([s['x'], s['y']])
    
    slong = 4.5 # longitudinal size (meter)
    slat = 2 # lateral size (meter)
    
    # car outset
    lines = box_in_frame(ax, 0, 0, slat, slong, R, T, c='k') 
    return lines

def box_in_frame(ax, cx, cy, w, h, R, T, c='k'):
    # car outset
    points = np.array([
        [1, -1, -1,  1,  1],
        [-1, -1,  1,  1, -1]
    ])
    points[0,:] = points[0,:] * w/2. + cx;
    points[1,:] = points[1,:] * h/2. + cy;
    lines = plot_in_frame(ax, points, R, T, c=c)
    return lines

def plot_in_frame(ax, points, R, T, c):
    # apply transformation
    points = R.dot(points)
    lines, = ax.plot(points[0,:] + T[0], points[1,:] + T[1], c=c)
    return lines

def plot_sensor_rays(ax, sensor, varargin=None):

    # (x,y) coordinates of the sensor
    center_pos = sensor.ray_center
    
    # (x,y) coordinates of end positions of all M rays
    end_pos = sensor.dist_to_pos(sensor.max_range)
    assert len(end_pos.shape) == 2
    
    # number of rays
    M = end_pos.shape[1]
    lines = []
    for m in range(M):
        line, = ax.plot([center_pos[0], end_pos[0, m]], [center_pos[1], end_pos[1,m]],
                        alpha=0.5, c='#BFBFBF')
        lines = lines + [line]
    return lines

def plot_true_target_position(t, objects):
    assert type(objects) == list
    # plot true target positions
    #delete(findobj('Tag', 'object'));
    ax = plt.gca()
    lines = []
    for obj in objects:
        line = ax.scatter(obj.pos[0,t], obj.pos[1,t], c=obj.plot_color, marker='*')
        lines.append(line)
    return lines

def plot_measurements(t, sensor, measurements, c='k', marker='x'):
    # get the measured distances at time t
    assert type(measurements) == list
    meas_dists = measurements[t].dists # the distances at the current time step

    # get x,y coordinates of measurements
    meas_pos = sensor.dist_to_pos(meas_dists)
    
    # plot measurements
    #delete(findobj('Tag', 'meas'));
    ax = plt.gca()
    line = ax.scatter(meas_pos[0,:], meas_pos[1,:], c=c, marker='x')
    return line
    #plot(meas_pos(1,:), meas_pos(2,:), 'kx', 'Tag', 'meas', varargin{:});

def plot_kfs(t, kfs):
    assert type(kfs) == list
    #tracker_color = lines(numel(kfs));

    # plot tracker results
    lines = []
    for j, kf in enumerate(kfs):
        assert type(kf.ts) == list
        if t not in kf.ts or t < 1.:
            continue
        ts = np.array(kf.ts)
        assert len(kf.ts) == len(kf.mu_upds)
        #if np.all(kf.ts != t):

        # grab the positional mean and covariance
        # of the filtered state up to time t
        #
        # (note that dimensions 1 & 2 of the state
        # correspond to the filtered position,
        # and the dimensions 3 & 4 to the filtered
        # velocity).
        tmask = (ts <= t) & (ts > 0)

        assert type(kf.mu_upds) == list
        assert type(kf.Sigma_upds) == list
        mus = np.array(kf.mu_upds)[tmask, :2]
        #mus = kf.mu_upds(1:2, tmask)
        Sigmas = np.array(kf.Sigma_upds)[tmask, :2, :2]
        #Sigmas = kf.Sigma_upds(1:2,1:2, tmask);
        assert mus.shape[0] != 0
        assert Sigmas.shape[0] != 0

        #color = tracker_color(j, :);

        # plot the filtered mean position up to the current time
        ax = plt.gca()
        ax.plot(mus[:, 0, :].flatten(), mus[:, 1, :].flatten(), '-')
        #plot(mus(1,:), mus(2,:), '-', 'Color', color, 'Tag', 'track');

        # plot the state distribution of the last time step
        #  (i.e. time t)
        lines = lines + plot_gauss2d(mus[-1,:2], Sigmas[-1,:2,:2], c='b')

        if True:
            # also plot the observation likelihood
            idx = int(np.arange(ts.shape[0])[ts == t])
            z_mu = kf.H.dot(np.array(kf.mu_upds)[idx,:])
            z_Sigma = kf.H.dot(np.array(kf.Sigma_upds)[idx,:,:]).dot(kf.H.T) + kf.Sigma_z
            lines = lines + plot_gauss2d(z_mu, z_Sigma, c='r')
    return lines

def plot_gauss2d(mu, Sigma, radii=[1.], c='b'):
    hs = []
    ax = plt.gca()

    # Sigma needs to be positive definite. Otherwise, cholesky decomposition
    # throws error
    assert len(Sigma.shape) == 2
    assert Sigma.shape[0] == Sigma.shape[1]
    try:
        C = np.linalg.cholesky(Sigma).T
    except np.linalg.LinAlgError:
        warnings.warn("I have run into a Sigma matrix that is not positive definite.")
        return [None]
    L = np.linspace(0., 2*np.pi, 100)
    L = np.array([np.cos(L), np.sin(L)])
    lines = []
    for radius in radii:
        X = C.T.dot(L * radius)
        l, = ax.plot(X[0,:] + mu[0], X[1,:] + mu[1], c=c, alpha=0.5)
        lines.append(l)
    return lines

def animate_kf_uncertainty_regions(kf, dims):
    assert type(dims) == list
    assert len(dims) == 2
    assert all([x in [0,1,2,3] for x in dims])
    dim_names = ['state dim 1 - x', 'state dim 2 - y', 'state dim 3 - vel. x', 'state dim 4 - vel. y']

    # setup figure
    plt.figure(figsize=(10,10))
    ax = plt.gca()
    ax.axis('equal')
    ax.set_xlim([-4, 4])
    ax.set_ylim([-4, 4])
    plt.pause(0.005)
    ax.set_xlabel(dim_names[dims[0]])
    ax.set_ylabel(dim_names[dims[1]])
    ax.set_title('KF state distribution')
    plt.pause(0.005)

    #colors = jet(numel(kf.ts));
    for step, t in enumerate(kf.ts):
        # get the updated
        mu = kf.mu_upds[step]
        Sigma = kf.Sigma_upds[step]

        # plot the uncertainty region of the two given dimensions
        #display_name = sprintf('time step %d', t);
        plot_gauss2d(mu[dims], Sigma[dims][:,dims])
        #title(sprintf('KF state distribution @ time step %d', t))

        # update figure
        #time.sleep(.1)
        plt.pause(0.005)#.1)
    
def plot_setup_selfloc(m):
    # Draw the occupancy grid, setup axes, etc.
    ax = plt.gca()
    #ax.imagesc(map.xs, map.ys, ~map.grid)
    extent = [m['xs'].min(), m['xs'].max(), m['ys'].min(), m['ys'].max()]
    ax.imshow(np.abs(m['grid']-1.), extent=extent, origin='lower')  #, extent=[0, 1, 0, 1])
    #colormap gray
    #axis square

    #set(gca, 'YDir', 'normal')
    ax.set_xlabel('world - x (meters)')
    ax.set_ylabel('world - y (meters)')
    #hold all

def plot_current_measurements(ax, sensor, measurement):
    # Plot the measurements at time t in the (x,y) plane.
    # Usage:
    #    plot_current_measurements(sensor, measurements)
    #    plot_current_measurements(sensor, measurements, 'Color', 'r')
    #
    # SEE ALSO plot_measurements
    # get the measured distances at time t
    meas_dists = measurement.dists # the distances at the current time step

    # get x,y coordinates of measurements
    meas_pos = sensor.dist_to_pos(meas_dists)
    
    # plot measurements
    ax.scatter(meas_pos[0,:], meas_pos[1,:], c='k', marker='x')

