function L2 = SqrError(wt,wMap)
%SQRERROR calculate ||wt - wMap||^2

L2 = norm(wt - wMap)^2;
end

