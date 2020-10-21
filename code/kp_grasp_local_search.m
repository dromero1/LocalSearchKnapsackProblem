function [x,fea] = kp_grasp_local_search(x0,n,m,W,A,b)
%KP_GRASP_LOCAL_SEARCH KP GRASP local search
%
%   Inputs:
%   x - Solution
%   n - Number of items
%   m - Number of constraints
%   W - Objective coefficients
%   A - Constraint coefficients
%   b - Resource capacity
%
%   Outputs:
%   x - Improved solution
%   fea - Feasibility percentage

% Current solution
x = x0;

% Current resource consumption
R = A*x0;

% Current objetive values
z = W*x0;

% Stop condition
stop = false;

% Neighborhood search
while stop == false
    stop = true;
    for i = 1:n
        if x(i) == true
            for j = 1:n
                if x(j) == false
                    % Determine if movement is legal
                    if R + A(:,j) - A(:,i) <= b
                        % New solution objetive values
                        z_tmp = z + W(:,j) - W(:,i);
                        % Determine if new solution dominates old one
                        if prod(z_tmp>=z) == 1 && sum(z_tmp>z) >= 1
                            % Update solution
                            x(i) = false;
                            x(j) = true;
                            % Update resource consumption
                            R = R + A(:,j) - A(:,i);
                            % New objetive values
                            z = z_tmp;
                            % Update stop condition
                            stop = false;
                            break;
                        end
                    end
                end
            end
        end
    end
end

% Feasibility percentage
fea = sum(A*x <= b)/m;

end