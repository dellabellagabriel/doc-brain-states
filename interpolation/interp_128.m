function [ newdata ] = interp_128(EEG, chanlocs_interp)
% Takes EEG struct with chanlocs and interpolates the data
% at the coordinates given by chanlocs_interp (chanlocs struct)
    
    %Normalization of EEG.chanlocs
    xelec = [EEG.chanlocs.X];
    yelec = [EEG.chanlocs.Y];
    zelec = [EEG.chanlocs.Z];
    rad = sqrt(xelec.^2+yelec.^2+zelec.^2); 
    xelec = xelec ./ rad;
    yelec = yelec ./ rad;
    zelec = zelec ./ rad;
    
    %Normalization of chanlocs_interp
    xelec_interp = [chanlocs_interp.X];
    yelec_interp = [chanlocs_interp.Y];
    zelec_interp = [chanlocs_interp.Z];
    rad_interp = sqrt(xelec_interp.^2+yelec_interp.^2+zelec_interp.^2);
    xelec_interp = xelec_interp ./ rad_interp;
    yelec_interp = yelec_interp ./ rad_interp;
    zelec_interp = zelec_interp ./ rad_interp;

    eegdata = EEG.data;
    
    %Reshape into channels x samples*epochs
    channels = size(eegdata,1);
    samples = size(eegdata,2);
    epochs = size(eegdata,3);
    if epochs ~= 1
        eegdata = reshape(eegdata, channels, samples*epochs);
    end
    
    channels_interp = length(chanlocs_interp);
    
    %Interpolation
    newdata = zeros(channels_interp, samples*epochs);
    for i=1:channels_interp
        display(['Interpolating channel ', num2str(i)])
        [~,~,~,tmpdata] = spheric_spline(xelec, yelec, zelec, xelec_interp(i), yelec_interp(i), zelec_interp(i), eegdata);
        newdata(i, :) = tmpdata;
    end
    
    newdata = reshape(newdata, channels_interp, samples, epochs);

end

