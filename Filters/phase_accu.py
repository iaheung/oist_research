import numpy as np 
import matplotlib.pyplot as plt

dt = 0.001 # time step
# define the three frequencies in radians per sample
omegaT1 = 2*np.pi*.73*dt
omegaT2 = 2*np.pi*2*dt
omegaT3 = 2*np.pi*5*dt

x=np.arange(1,5,0.001)
y=list()
phi = 0; # phase accumulator
for i in range(0,len(x)):
    c = np.cos(phi) # cosine of current phase
    y.append(c)
    # increment phase based on current frequency
    if x[i]<2:
       phi = phi + omegaT1
    elif x[i]<3:
       phi = phi + omegaT2
    else:
       phi = phi + omegaT3

plt.plot(x, y)
plt.show()