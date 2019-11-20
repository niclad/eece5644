classdef Question
    %QUESTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        column
        value
    end
    
    methods
        function obj = Question(col,val)
            %QUESTION Construct an instance of this class
            %   Detailed explanation goes here
            obj.column = col;
            obj.value = val;
        end
        
        function g = match(obj,example)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            val = example(obj.column);
            g = val < obj.value;
        end
    end
end

