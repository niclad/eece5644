function [ muM, covM, wgtM ] = EM( data, mu, cov, wgt, nc, iter, tol )
%EM Run EM algorithm
%   @param nc is the number of components to test for (e.g. 1:6)
%   @param iter is the maximum number of iteration allowed before EM stops
%   (if tolerance is not reached)
%   @param tol is the tolerance of the EM algorithm
%   

for itr = 1:iter
    if itr == 1
        [ ll, post ] = E_Step(data, mu, cov, wgt, nc);
        [ muM, covM, wgtM ] = M_Step(data, post, nc);
        curLL = ll;
        llV   = ll;
        
    else
        [ ll, post ] = E_Step(data, muM, covM, wgtM, nc);
        [ muM, covM, wgtM ] = M_Step(data, post, nc);
        
        llDelta = abs(curLL - ll);
        if llDelta < tol
            break
        else
            curLL = ll;
        end
    end
end

end

