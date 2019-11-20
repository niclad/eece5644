classdef Leaf
    %LEAF Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        predictions
    end
    
    methods
        function obj = Leaf(rows)
            %LEAF Construct an instance of this class
            %   Detailed explanation goes here
            tab = tabulate(rows(:,end));
            pred = cell(size(tab,1), 2);
            for i = 1:size(tab,1)
                pred{i,1} = tab(i,1);
                pred{i,2} = tab(i,2);
            end
            obj.predictions = pred;
        end
    end
end

