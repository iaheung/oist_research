import scipy.signal as signal
import numpy as np
import matplotlib.pyplot as plt
import os
import datetime

# Assign file path   
directory = 'C:\\Users\\Ian\\Desktop\\OIST\\FilterTest\\Graphs'
now = datetime.datetime.now()
path = os.path.join(directory, now.strftime('%y%m%d_%H%M%S'))
os.mkdir(path)

# Define the filter specifications
order = 4  # Filter order
sampling = 50000 # Sampling Rate
cutoff_freq = 1000 # Cutoff Frequency (Units Unknown)
duration = 0.1 # Signal duration in seconds

# Nyquist and Normalizaztion Step
nyquist_freq = sampling * 0.5
normalized = cutoff_freq / nyquist_freq

b, a = signal.butter(order, normalized, btype='low', analog=False, output='ba')

filter = signal.dlti(b, a)

# Display coefficients in console
print('b Coefficients:')
print(b)
print('a Coefficients:')
print(a)

# X Axis - Time (s), Y Axis - Amplitude (V)
t = np.linspace(0, duration, int(duration * sampling), endpoint=False)
y = list()

# Phase accumulator
dt = duration / sampling


# The values were arbitarily assigned. Still trying to figure out the units
omegaT1 = 10000*dt
omegaT2 = 50000*dt
omegaT3 = 100000*dt
omegaT4 = 200000*dt

print(dt)
print(omegaT1)
print(omegaT2)
print(omegaT3)
print(omegaT4)

phi = 0

for i in range(0,len(t)):
    sine = np.sin(phi) # sine of current phase
    y.append(sine)
    print(sine)
    # increment phase based on current frequency
    if t[i]<0.025:
       phi = phi + omegaT1
    elif t[i]<0.05:
       phi = phi + omegaT2
    elif t[i]<0.075:
       phi = phi + omegaT3
    else:
       phi = phi + omegaT4
       
# Apply the filter to the input signal
filtered_signal = signal.lfilter(b, a, y)

# Plot the original and filtered signals
plt.figure()
plt.plot(t, y, label='Original Signal')
plt.plot(t, filtered_signal, label='Filtered Signal')
plt.title('Butterworth Filter Signal Response')
plt.xlabel('Time [Seconds]')
plt.ylabel('Amplitude [Volts]')
plt.legend()
fig_name_filter_response = 'filter_response_'+ now.strftime('%y%m%d_%H%M%S')+'.png'
plt.savefig(os.path.join(path,fig_name_filter_response))

# Plot Frequency Response
plt.figure()
w, h = signal.freqz(b, a, fs = sampling)
plt.semilogx(w,  np.log10(abs(h)))
plt.title('Butterworth Filter Frequency Response')
plt.xlabel('Frequency [Radians / Second]') 
plt.ylabel('Amplitude [dB]') 
plt.margins(0, 0.1)
plt.grid(which='both', axis='both')
plt.axvline(cutoff_freq, color='green')
fig_name_freq_response = 'freq_response_'+ now.strftime('%y%m%d_%H%M%S')+'.png'
plt.savefig(os.path.join(path,fig_name_freq_response))

# Plot Phase Response
plt.figure()
phase = np.angle(h)
plt.semilogx(w,  phase)
plt.title('Butterworth Filter Phase Response')
plt.xlabel('Frequency [Radians / Second]') 
plt.ylabel('Phase [Radians]')
fig_name_phase_response = 'phase_response_'+ now.strftime('%y%m%d_%H%M%S')+'.png'
plt.savefig(os.path.join(path,fig_name_phase_response))
