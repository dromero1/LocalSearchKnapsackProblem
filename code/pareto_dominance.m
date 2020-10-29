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
x = (1:n)';

% Dominated set
D = false(n,1);

% Main loop
for i = 1:n
    for j = 1:n
        if i ~= j && D(j) == false
            if prod(Y(i,:)>=Y(j,:)) == 1 && sum(Y(i,:)>Y(j,:)) >= 1
                D(j) = true;
            end
        end
    end
end

% Remove duplicates
D = find(D);

% Non-dominated set
ND = setdiff(x,D);

end