%load('/home/usuario/disco2/interpolation/closest_32.mat');
%load('/home/usuario/disco2/interpolation/closest_64.mat');

input = struct;
input.n_windows = 300;
input.n_channels = 128;
%input.specific_channels = closest_electrodes;

input.import_path = '../examples/dataset/dynamic-wsmi/Healthy';
healthy = brainstates(input);

input.import_path = '../examples/dataset/dynamic-wsmi/MCS';
mcs = brainstates(input);

input.import_path = '../examples/dataset/dynamic-wsmi/UWS';
uws = brainstates(input);

dataset_liping = single(cat(1, healthy, mcs, uws));
%dataset_liping = single(cat(1, mcs, uws));