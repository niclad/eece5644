classdef DecisionNode
    %DECISIONNODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        question
        trueBranch
        falseBranch
    end
    
    methods
        function obj = DecisionNode(question, trueBranch, falseBranch)
            %DECISIONNODE Construct an instance of this class
            %   Detailed explanation goes here
            obj.question = question;
            obj.trueBranch = trueBranch;
            obj.falseBranch = falseBranch;
        end
    end
end

