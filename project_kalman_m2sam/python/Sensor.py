import numpy as np
from Measure import Measure

class Sensor:
    
    def __init__(self, angle_min, angle_max, M, max_range=15., dist_sigma=1.,
                    detect_prob=0.5, offsets=None):

        assert type(M) is int
        self.M = M
        self.angles = np.linspace(angle_min, angle_max, M+1)
        self.angles = self.angles[:-1]

        self.max_range = max_range
        self.dist_sigma = dist_sigma
        self.detect_prob = detect_prob

        self.ray_center = np.array([0, 0])
        if offsets is not None:
            self.angles = self.angles - offsets['theta']
            self.ray_center = np.array([offsets['x'], offsets['y']])

        # ray direction in world coordinates
        self.ray_dirs = np.array([np.cos(self.angles), np.sin(self.angles)])

    def new_meas(self):
        meas = Measure( angles=self.angles,
                        dists=np.ones(self.M)*self.max_range,
                        idxs=np.zeros(self.M, dtype=int)+-9999999)
        return meas

    def observe_false_positives(self, meas, prob, idx=0):
        assert type(meas.dists) == np.ndarray
        mask = np.random.rand(self.M) < prob
        assert mask.shape[0] == meas.dists.shape[0]
        meas.dists[mask] = np.random.rand(int(sum(mask))) * self.max_range
        meas.idxs[mask] = idx
        return meas

    def observe_point(self, meas, pos, radius, idx=0):
        # put sensor center at origin
        assert type(pos) == list
        assert all([type(x) == np.ndarray for x in pos])
        assert all([x.shape == (2,) for x in pos])
        pos = np.array([x-self.ray_center for x in pos]).swapaxes(0,1)
        assert pos.shape[0] == 2
        assert len(pos.shape) == 2

        radius2 = radius * radius; # precompute squared radius
        
        # check observations from closest to furthest
        dists2 = (pos * pos).sum(axis=0)
        order = dists2.argsort()
        dists2 = dists2[order]
        pos = pos[:, order]

        # test all rays
        for m in range(self.M):
            # distance to ray
            dist_om = self.ray_dirs[:,m].dot(pos)
            assert dist_om.shape == (pos.shape[1],)
            dist_om[dist_om < 0.] = 0.
            dist_om[dist_om > self.max_range] = self.max_range
            proj_om = self.ray_dirs[:,m].reshape(-1,1) * dist_om;
            assert proj_om.shape == (2, pos.shape[1])
            # perpendicular squared distance to ray
            assert proj_om.shape == pos.shape
            perp_dist2_om = np.sum((pos - proj_om) * (pos - proj_om), 0); 
            assert perp_dist2_om.shape == (pos.shape[1],)
            # test if object is detected
            prob = (perp_dist2_om < radius2) * self.detect_prob;
            detected = np.arange(prob.shape[0])[prob > np.random.rand()]
            for k in detected:
                # noise measurement
                new_dist = np.random.randn() * self.dist_sigma +\
                    np.sqrt(dists2[k])
                assert type(new_dist) == np.float64
                if new_dist < meas.dists[m]:
                    meas.dists[m] = new_dist;
                    meas.idxs[m] = idx;
                    # no need to check other observations
                    break;
        return meas

    def dist_to_pos(self, dists):
        xy_pos = self.ray_dirs * dists
        xy_pos = self.ray_center.reshape(2,1) + xy_pos
        assert xy_pos.shape[0] == 2
        return xy_pos

