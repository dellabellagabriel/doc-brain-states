function y = JS(p,q)
%JS takes two probability distributions p and q and computes the 
%Jensen Shannon divergence

    m = 0.5*(p+q);
    y = 0.5*(KL(p,m) + KL(q,m)); 

end

