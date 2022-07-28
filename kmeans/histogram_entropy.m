n_states = 5;
n_channels = 64;

Cm = [];
Cmat = [];
for i=1:n_states
    Cmat(i,:,:) = vec2tri(C(i,:));
    Cm(i,:) = reshape(vec2tri(C(i,:)),1,n_channels*n_channels);
end

Ldata = n_channels*n_channels;
bines = round(sqrt(Ldata));
H = [];
for i=1:n_states
    
     x=Cord(i,:);
     
     P=hist(x,bines)/Ldata;

     I=find(P~=0); P=P(I);

     H(i) = -sum(P.*log(P))./log(bines); %shannon
end

plot(H)

[v, idx] = sort(H, 'descend');
Cord = Cm(idx, :);