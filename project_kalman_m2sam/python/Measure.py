class Measure:

    def __init__(self, angles, dists, idxs):
        self.angles = angles
        self.dists = dists
        self.idxs = idxs
    def __str__(self):
        return (f"angles: {self.angles}\n"
                f"dists: {self.dists}\n"
                f"idxs: {self.idxs}\n")
        
