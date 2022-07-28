# doc-brain-states

Required packages are:
- MNE (https://mne.tools/stable/index.html)
- Nice tools (https://github.com/nice-tools/nice)
- Numpy
- scipy 
- h5py

## interpolation
Interpolates the signal at specified locations using `spheric_spline` from EEGLAB

## dynamic-wsmi
Computes the dynamic connectivity matrices using wSMI as a measure (as implemented in the NICE Tools library)

## kmeans
Performs a subsampling of windows and the clustering itself as well as the ordering of centroids based on entropy

## realtime
Computes the realtime simulation statistics
