function [ND,D] = pareto_dominance(Y)
%PARETO_DOMINANCE Pareto dominance classification
%
%   Inputs:
%   Y - Objective values of solutions
%
%   Outputs:
%   ND - Non-dominated set
%   D - Dominated set

% Number of solutions and objectives
n = size(Y,1);

% Solutions
X = (1:n)';

% Dominated set
D = [];

% Main loop
for i = 1:n
    for j = 1:n
        if i ~= j
            if prod(Y(i,:)>=Y(j,:)) == 1 && sum(Y(i,:)>Y(j,:)) >= 1
                D = [D; j];
            end
        end
    end
end

% Remove duplicates
D = unique(D);

% Non-dominated set
ND = setdiff(X,D);

end