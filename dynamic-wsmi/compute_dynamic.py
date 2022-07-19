from dynamic_wsmi import computeWSMI
import glob
import os
import scipy.io as sio
import numpy as np

#we list all mat files in a directory
files = glob.glob('../../datos_128/Healthy/*.mat')
#this file saves the progress by writing the filename when it finishes. If you run it again it won't process
#files in this list
progress = open('progress.txt', 'r').read()

for subject in files:
    subject_filename = os.path.basename(subject)
    if subject_filename in progress:
        print('Ignoring ' + subject_filename + ' since it was found in progress.txt')
        continue
        
    data = {}
    sio.loadmat(subject, data)
    data = np.array(data['epochs_data'])# this is channel x trials x samples
    data = np.transpose(data, (1, 2, 0))# transpose to trials x samples x channel
    data = np.reshape(data, (data.shape[0]*data.shape[1], data.shape[2]))
    print(data.shape)
    total_time = int(data.shape[0]/250)
    computeWSMI(
        file_to_compute=subject,
        word_to_compute='epochs_data',
        output_path='../examples/dataset/realtime-wsmi/Healthy',
        sample_rate=250,
        channels=128,
        samples_per_trial=386,
        tau=8,
        total_time=total_time,
        window_size=1,
        window_offset=0.5,
        healthyData=data
    )
    f = open("progress.txt", "a").write(subject_filename + ',')