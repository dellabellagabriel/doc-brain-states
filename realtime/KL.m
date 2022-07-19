function s = KL(p,q)
%KL computes the Kullback Leibler divergence between p and q
%assumed to be normalized
    
    s = 0;
    sum_term = 0;
    for i=1:length(p)
        if p(i) == 0
           sum_term = 0;
        else
            if q(i) ~= 0
                sum_term = p(i)*log(p(i)/q(i));
            else
                error('q(i) can''t be zero if p(i) is not zero');
            end
        end
        
        s = s + sum_term;
    end
end

