classdef TestResult
    %TESTRESULT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        w
        b
        err
        C
        sc
        kFold
        mdl
        rl
    end
    
    methods
        function obj = TestResult(mdlW, mdlB, lossErr, currC, scaleNum, ...
                currK, myMdl, realL)
            %TESTRESULT Construct an instance of this class
            %   Detailed explanation goes here
            obj.w = mdlW;
            obj.b = mdlB;
            obj.err = lossErr;
            obj.C = currC;
            obj.sc = scaleNum;
            obj.kFold = currK;
            obj.mdl = myMdl;
        end
        
        function R = train(obj,data, label)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            if ~isempty(obj.w)
                R = (obj.w' * data') + obj.b;
                D(R < 0) = 1;
                D(R > 0) = 2;
                R = D';
            else
%                 wv = sum(obj.mdl.Alpha .* obj.mdl.SupportVectorLabels .* ...
%                     obj.mdl.SupportVectors);
%                 R = (wv * data') + obj.b;
                R = predict(obj.mdl, data);
            end
            
            
            obj.plotGroup(data, label, R);
        end
        
        function p = plotGroup(obj, data, label, R)
            classErr = sum(label ~= R);
            classErr = (classErr / length(data)) * 100;
            
            plot(data(R==1, 1), data(R==1, 2), '.b')
            hold on
            plot(data(R==2, 1), data(R==2, 2), '.r')
            xlabel('x1')
            ylabel('x2')
            title(sprintf('P(error)=%3.2f', classErr))
        end
    end
end

