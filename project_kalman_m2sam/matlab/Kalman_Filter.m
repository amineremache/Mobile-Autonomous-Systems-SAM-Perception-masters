clear all; close all; clc;
%% Ex 1.1: define the Linear Dynamical System used in the KF
m_init = zeros(4,1); % initial mean
S_init = eye(4);     % initial covariance
kf = kf_init(m_init, S_init); % t = 0

%% Ex 1.2 & 1.3: implement the KF predict step
% let's run the prediction 5 times
kf = kf_predict_step(kf); % t = 1;
kf = kf_predict_step(kf); % t = 2;
kf = kf_predict_step(kf); % t = 3;
kf = kf_predict_step(kf); % t = 4;
kf = kf_predict_step(kf); % t = 5;

fprintf('the Kalman Filter processed %d time steps (t = %d to t = %d)\n', numel(kf.ts), min(kf.ts), max(kf.ts));
dims = [1 4];
animate_kf_uncertainty_regions(kf, dims);

%% Ex 1.4: Pedestrian moving in front of a vehicle
% -- DEFINE scenario setup --
% define sensor
R = 50; % number of measurment angles
% defines the simulated 'sensor'
sensor = make_sensor(pi/2 + pi/4, pi/2 - pi/4, R);
% define the setup: one pedestrian
scenario_version = 1;
[objects, T] = mot_scenario_single_target(scenario_version);
% simulate measurements of SINGLE pedestrian,
jk_srand(90);
% create simulated measurments for all T time steps
for step = 1:T
    % measure the objects
    meas = sensor.new_meas();    
    meas = sensor.observe_point(meas, objects(1).pos(:,step), 1, 1);    

    measurements(step) = meas;
end
% show measurements
plot_measurement_matrix(measurements)

%% Ex 1.5: Visualize the scenario
% Let's animate the scenario from a top-down viewpoint.
figure(1);
clf
plot_setup_mot(sensor);
% Iterate over the time steps.
for step = 1:T 
    
    % draw the true object positions as a '*' mark
    plot_true_target_position(step, objects);
    
    % draw the measured distances as 'x' marks
    %   (skip measurements that are
   plot_measurements(step, sensor, measurements);
    
    % The `pause` command can be used to control the speed of the
    % animation. Ot also ensures that the figure gets drawn, 
    % even though we are in a loop.
    % Without out it, matlab might delay showing the
    % plot until the for-loop has completely finished, which means
    % that we would only see the plot of the last timestep t = T.    
    pause(.01);
end

%% Ex 1.6: KF initialization and prediction on pedestrian scenario

% define initial state
%   NOTE: for now, we assume that the target's true initial position is known!
pos_init1 = objects(1).pos(:,1);
m_init1 = [pos_init1; 0; 0];
S_init1 = diag([1 1 .1 .1]);

% create the tracker
kf = kf_init(m_init1, S_init1);

figure(1);
clf
plot_setup_mot(sensor);
for step = 1:T
    
    % call the KF *predict* step
    %   (no *update* step yet, we will get to it in a moment)
    kf = kf_predict_step(kf);

    % show the result
    plot_kfs(step, kf);    
    plot_true_target_position(step, objects);
    pause(.01);
end

%% Ex 1.7 & Ex 1.8: updating the Kalman Filter
% create the tracker
kf = kf_init(m_init1, S_init1);

% here scale up/down the process and observation noise
%kf.Sigma_x = kf.Sigma_x * 1e0; % <-- ** Ex 1.8 
%kf.Sigma_z = kf.Sigma_z * 1e0; % <-- ** Ex 1.8 

% feed the measurments, filter the results
kf = run_single_kf(kf, sensor, measurements);

% visualize the result
figure(1); clf
plot_setup_mot(sensor); title('KF'); 

for step = 1:T
    plot_true_target_position(step, objects);
    plot_measurements(step, sensor, measurements);
    plot_kfs(step, kf);
   % control animation speed and force that the figure gets drawn
    pause(.01);
end

%% Ex 1.9: outlier noise
% now we also siumulate that the sensor can have outlier measurements
%   (i.e. false detections) that have nothing to do with the moving target.

jk_srand(42); % random seed

% generate new measurements with outliers
clear measurements_outliers
for step = 1:T
    % measure the objects
    meas = sensor.new_meas();
    meas = sensor.observe_false_positives(meas, .02); % <-- outlier ratio
    meas = sensor.observe_point(meas, objects(1).pos(:,step), 1, 1);
     
    measurements_outliers(step) = meas;
end

% show measurements
plot_measurement_matrix(measurements_outliers)

% run a Kalman Filter on measurements with NOISY OUTLIERS
kf = kf_init(m_init1, S_init1);
kf = run_single_kf(kf, sensor, measurements_outliers);

% visualize the result
figure(1);
clf
plot_setup_mot(sensor);
title('KF on outliers'); 

% animate
for step = 1:T
    plot_true_target_position(step, objects);
    plot_measurements(step, sensor, measurements_outliers);
    plot_kfs(step, kf);
    
    pause(.01);
end

%% Ex 1.10: pre-process measurements
% use a pre-processing step to remove some noise from the measurments
measurements_pp = preprocess_measurements(measurements_outliers);

% show pre-processed measurements
plot_measurement_matrix(measurements_pp)

% run a Kalman Filter on pre-processed measurements
kf = kf_init(m_init1, S_init1);
kf = run_single_kf(kf, sensor, measurements_pp);

% visualize the result
figure(1);
clf
plot_setup_mot(sensor);
title('KF with pre-processing on outliers'); 

% animate
for step = 1:T
    plot_true_target_position(step, objects);
    plot_measurements(step, sensor, measurements_pp);
    plot_kfs(step, kf);
    
    pause(.01);
end

%% Ex11: Now with gating
% run a Kalman Filter on all timesteps 
kf = kf_init(m_init1, S_init1);
kf = run_single_kf_gating(kf, sensor, measurements_outliers);

% visualize the result
figure(1); clf
plot_setup_mot(sensor);
title('KF with gating on outliers'); 

% animate
for step = 1:T
    plot_true_target_position(step, objects);
    plot_measurements(step, sensor, measurements_outliers);
    plot_kfs(step, kf);
    
    pause(.01);
end

%% Ex 1.12: Scenarios with multiple targets
% define the setup: two pedestrians moving
%   now objects(i) contains the positions of pedestrian i
scenario_version = 2; % 1 = crossing, 2 = stoppingcenario_version = 2; % 1 = crossing, 2 = stopping
[objects_multi, T] = mot_scenario_multi_target(scenario_version);

jk_srand(42); % random seed

clear measurements_multi
for step = 1:T
    
    % measure the objects
    meas = sensor.new_meas();
    meas = sensor.observe_false_positives(meas, .02);
    meas = sensor.observe_point(meas, objects_multi(1).pos(:,step), 1, 1);
    meas = sensor.observe_point(meas, objects_multi(2).pos(:,step), 1, 2);
    
    measurements_multi(step) = meas;
end

% show measurements
plot_measurement_matrix(measurements_multi)

%% Ex 1.13: Multiple-targets: data association
% define intial position for a second Kalman Filter
pos_init2 = objects_multi(2).pos(:,1);
m_init2 = [pos_init2; 0; 0];
S_init2 = diag([1 1 .1 .1]);

% initialize two KFs for both persons
kf = kf_init(m_init1, S_init1);
kf2 = kf_init(m_init2, S_init2);

% append both KFs into a single struct `kfs` with 2 dimesions
%   such that kfs(1) = kf and kfs(2) = kf2
kfs = [kf, kf2];

% run both KFs simultaneously, using data association.
kfs = run_multiple_kfs(kfs, sensor, measurements_multi);

% You can also try out your previous Kalman Filter implementations
%   that assumed a single target on these measurements.
%kfs(1) = run_single_kf(kfs(1), sensor, measurements_multi);
%kfs(1) = run_single_kf_gating(kfs(1), sensor, measurements_multi);

% visualize the result
figure(1);
clf
plot_setup_mot(sensor);
title('KF on multiple targets'); 

for step = 1:T
    plot_true_target_position(step, objects_multi);
    plot_measurements(step, sensor, measurements_multi);
    plot_kfs(step, kfs);    
    pause(.01);
end

%% Ex 1.13: Complete Multi-object tracking
% deactivate a KF tracker if it has had NO observations 
%  in so many time steps:
track_termination_threshold = 8;
    
% run multi-object tracker, on return set of KFs for all tracks
kfs = run_multi_object_tracker( ...
    sensor, ...
    measurements_multi, ...
    track_termination_threshold ...
);
fprintf('created %d tracks ...\n', numel(kfs));

% visualize the result
figure(1);
clf
plot_setup_mot(sensor);
title('Multi-Object Tracking'); 

% animate
for step = 1:T
    plot_true_target_position(step, objects_multi);
    plot_measurements(step, sensor, measurements_multi);
    plot_kfs(step, kfs);
    
    pause(.05);
end