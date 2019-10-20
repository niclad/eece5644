function wMap = GammaExperiment(wt, sigma, N, exGamma, I, D)
%GAMMAEXPERIMENT Summary of this function goes here
    %[xVals, v, D] = GenerateSamples(wt, sigma, N);
    wMap = WMAP(exGamma, I, wt, D, sigma, N);
    
end

