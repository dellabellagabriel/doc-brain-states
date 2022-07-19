function y = brainstates(datastruct)
    %this function returns the matrix you should pass to
    %k-means

    %datastruct must be a struct with the following fields:
    %import_path: path for extracting the mat files
    %n_windows: number of windows to sample
    %n_channels: number of channels in your data

    import_path = datastruct.import_path;
    n_windows = datastruct.n_windows;
    n_channels = datastruct.n_channels;
    if isfield(datastruct, 'specific_channels')
        specific_channels = datastruct.specific_channels;
    else
        specific_channels = 1:n_channels;
    end

    files = dir(strcat(import_path, '/*.mat'));
    filenames = {files(:).name};
    
    dataset = zeros(n_windows*length(filenames), n_channels*(n_channels-1)/2);
    for i=1:length(filenames)
       display(strcat('Processing ...', filenames{i}))
       load(strcat(import_path, '/', filenames{i}), 'data');
       data = data(:,specific_channels,specific_channels);
       %datanew = reshape(data, n_windows, n_channels*n_channels);
       windows = size(data,1);
       
       datanew = zeros(windows, n_channels*(n_channels-1)/2);
       for w=1:windows
           datanew(w,:) = tri2vec(squeeze(data(w,:,:)));
       end
       
       indices = 1:floor(windows/n_windows):windows;
       datanew = datanew(indices(1:n_windows),:);
       
       dataset((i-1)*n_windows+1:i*n_windows, :) = datanew;
    end
    
    y = dataset;

end