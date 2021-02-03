import numpy as np

class Kf:

    def __init__(self, mu, Sigma):
        # we will use this struct to setup all the 
        # information needed for the Kalman filter, namely:
        #   - its current state (mean and covariance)
        #   - historic state (mean and covariance of previous timesteps)
        #   - the definition of Linear Dynamical System used
        #     later for the predict and update steps.
        
        # check that initial state makes sense
        Dx = mu.shape[0]
        assert mu.shape == (Dx, 1)
        assert Sigma.shape == (Dx, Dx)

        # list which will store the predicted and updated
        #  mean and covariance (arrays) for each time step, e.g.
        #
        #     mu_preds[t] = predicted mu at time t (type: np.ndarray)
        #     Sigma_preds[t] = predicted Sigma at time t (type: np.ndarray)  
        #
        # and
        #
        #     mu_upds[t] = updated mu at time t (type: np.ndarray)
        #     Sigma_upds[t] = updated Sigma at time t (type: np.ndarray)   
        #
        # The lists are initialized with 0 length,
        # since initially no time has passed, but will be extended
        # in the predict and update steps.
        self.mu_preds = []
        self.Sigma_preds = []
        self.mu_upds = []
        self.Sigma_upds = []

        # ts (short for timestamps) will store the
        #  time indices corresponding to the predicted and
        #  updated mu, Sigma. Keeping track of the actual
        #  time instance will be useful when we
        #  have multiple Kalman Filters which may have started
        #  at different time instances.
        # initially, zero time steps are recorded
        self.ts = []

        # Ok, let's put in the actual 'initial state' for t = 0
        # and let's add the initial state to the history
        self.mu_preds.append(mu)
        self.Sigma_preds.append(Sigma)
        # we also set the 'updated' values for the new time step
        # equal to the predict ones 
        self.mu_upds.append(mu)
        self.Sigma_upds.append(Sigma)
        self.ts.append(0.) # this is time t = 0
            
        # the dimensionality of the state vector
        self.Dx = Dx
        
        # x_t+1 = F x_t + epsilon_t, where noise epsilon_t ~ N(0, Sigma)
        # z_t   = H x_t + eta_t,     where noise eta_t ~ N(0, R)
        noise_var_x_pos = 1e-1 # variance of spatial process noise
        noise_var_x_vel = 1e-2 # variance of velocity process noise
        noise_var_z = 3. # variance of measurement noise for z_x and z_y

        # define the linear dynamics
        #    You should define the F and H matrixes
        self.F = np.array([[1,0,1,0],[0,1,0,1],[0,0,1,0],[0,0,0,1]], dtype=float) # <-- student code should replace this
        self.H = np.array([[1,0,0,0],[0,1,0,0]], dtype=float) # <-- student code should replace this
        self.Sigma_x = np.array(np.diag([noise_var_x_pos,noise_var_x_pos,noise_var_x_vel,noise_var_x_vel])) # <-- student code should replace this (hint: see np.diag() function)
        self.Sigma_z = np.array(np.diag([noise_var_z,noise_var_z])) # <-- student code should replace this (hint: see np.diag() function)
#########################
## YOUR_CODE_GOES_HERE ##
#########################

        # finally, check that everything has correct dimensions
        Dz, _ = self.H.shape # dimensionality of observations
        assert self.F.shape == (Dx, Dx)
        assert self.H.shape == (Dz, Dx)
        assert self.Sigma_x.shape == (Dx, Dx)
        assert self.Sigma_z.shape == (Dz, Dz)
        # check that dtype is np.float64
        # if other type (e.g. np.float32) verification of matrices will fail
        # in sanity_check_kf_init.py
        # TIP: np.array([0, 1], dtype=np.float64) creates np.ndarray with dtype
        # np.float64
        assert self.F.dtype == np.float64
        assert self.H.dtype == np.float64
        assert self.Sigma_x.dtype == np.float64
        assert self.Sigma_z.dtype == np.float64

    def predict_step(self):
        # get the last (i.e. updated) state from the previous timestep
        mu_prev = self.mu_upds[-1]
        Sigma_prev = self.Sigma_upds[-1]
        t = self.ts[-1]

        # Write here the two Kalman predict equations here to compute
        #   from previous state distribution of t-1, N(x_{t-1} |mu_prev, Sigma_prev)
        #   the predicted state distribution for t, N(x_t | mu, Sigma)
        mu = self.F.dot(mu_prev)
        Sigma = (self.F.dot(Sigma_prev)).dot(np.transpose(self.F)) + self.Sigma_x

#########################
## YOUR_CODE_GOES_HERE ##
#########################
        assert mu.shape == mu_prev.shape
        assert Sigma.shape == Sigma_prev.shape

        # after the predicted mu and Sigma have been computed,
        #   store them in the struct as the latest predicted state
        self.mu_preds.append(mu)
        self.Sigma_preds.append(Sigma)
        # we also set the 'updated' values for the new time step
        # equal to the predicted ones 
        self.mu_upds.append(mu)
        self.Sigma_upds.append(Sigma)
        self.ts.append(t + 1)

    def update_step(self, z):
        # You can use `np.linalg.inv(S)` to compute the inverse of a matrix S.
        # Use the `np.eye` function to create the identity matrix I

        # get the latest predicted state, which should be the current time step
        mu = self.mu_upds[-1]
        Sigma = self.Sigma_upds[-1]
        z = z.reshape((z.shape[0],1))
        assert len(mu.shape) == 2
        assert mu.shape[1] == 1
        # Kalman Update equations go here:
        #
        #   Use mu and Sigma to compute the 'updated' distribution described by
        #    mu_upd, Sigma_upd using the Kalman Update equations
        #
#########################
## YOUR_CODE_GOES_HERE ##
#########################

        et = z - self.H.dot(mu)
        st = (self.H.dot(Sigma)).dot(np.transpose(self.H)) + self.Sigma_z
        Kt = (Sigma.dot(np.transpose(self.H))).dot(np.linalg.inv(st))
        mu_upd = mu + Kt.dot(et)
        KtH = Kt.dot(self.H)
        Sigma_upd = Sigma + (np.eye(N=KtH.shape[0],M=KtH.shape[1]) - KtH).dot(Sigma)

        assert mu_upd.shape == mu.shape
        assert Sigma_upd.shape == Sigma.shape

        # ok, store the result
        self.mu_upds[-1] = mu_upd
        self.Sigma_upds[-1] = Sigma_upd

    def predict_obs(self):
        mu = self.mu_preds[-1]
        Sigma = self.Sigma_preds[-1]

        assert mu.shape == (4,1)
        assert Sigma.shape == (4,4)

        z_mu = self.H.dot(mu)
        z_Sigma = self.H.dot(Sigma).dot(self.H.T) + self.Sigma_z
        return z_mu, z_Sigma
