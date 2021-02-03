import numpy as np
from Object import Object

def mot_scenario_single_target(scenario_id=0):
    assert type(scenario_id) is int
    scenario_id = scenario_id if scenario_id > 0 else 1

    # number of timesteps
    T = 50

    # trajectory (x1, y1) of object 1 
    o1_pos = [
        np.linspace(-13, 9, T), # x1
        np.linspace(10, 5, T)  # y1
    ]
    o1_pos = np.array(o1_pos)
    
    if scenario_id == 1:
        desc = '1 person walking straight'
        # nothing to change to trajectory
    elif scenario_id == 2:
        desc = '1 person walking and stopping'
        t_stop = 34
        o1_pos[0, t_stop:] = o1_pos[0, t_stop]
        o1_pos[1, t_stop:] = o1_pos[1, t_stop]
    else:
        raise ValueError(f"incorrect scenario id ({scenario_id}) given")
    
    objects = [Object(pos=o1_pos, plot_color='b')]
    
    print(f"** single target scenario {scenario_id}: {desc}\n")

    return objects, T

def mot_scenario_multi_target(scenario_id=0):

    assert type(scenario_id) is int
    scenario_id = scenario_id if scenario_id > 0 else 1

    # number of timesteps
    T = 50

    # trajectory (x1, y1) of object 1 
    o1_pos = [
        np.linspace(-13, 9, T), # x1
        np.linspace(10, 5, T)  # y1
    ]
    o1_pos = np.array(o1_pos)

    # trajectory (x2, y2) if object 2
    o2_pos = [
        np.linspace(5, -9, T), # x2
        np.linspace(7, 5, T)  # y2
    ]
    o2_pos = np.array(o2_pos)

    if scenario_id == 1:
        desc = '2 persons, crossing'
        # nothing to change to trajectory
    elif scenario_id == 2:
        desc = '2 persons crossing,one stopping'
        t_stop = 30
        o1_pos[0, t_stop:] = o1_pos[0, t_stop]
        o1_pos[1, t_stop:] = o1_pos[1, t_stop]
    else:
        raise ValueError(f"incorrect scenario id ({scenario_id}) given")
    
    objects = [
                Object(pos=o1_pos, plot_color='b'),
                Object(pos=o2_pos, plot_color='r')
                ]

    print(f"** MULTI-target scenario {scenario_id}: {desc}\n")

    return objects, T
